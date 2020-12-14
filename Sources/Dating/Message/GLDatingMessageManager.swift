//
//  GLDatingMessageManager.swift
//  SwiftTool
//
//  Created by Yule on 2020/12/11.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import UIKit
import GRDB
import RxSwift
import RxCocoa

private let tableDirectory = "GLDatingUserDatabase"
private let tablePath = "user.db"

public class GLDatingMessageObject {
    public let conversationID: String?
    public var messages: [GLDatingMessage] = []
    public var cancellable: DatabaseCancellable?
    public init(conversationID: String?) {
        self.conversationID = conversationID
    }
}

public class GLDatingMessageManager {
    /// 单列
    public static let `default` = GLDatingMessageManager()
    
    
    private var dbQueue: DatabaseQueue?
    private var ownerID: String?
    private var unreadCountCancellable: DatabaseCancellable?
    private var conversationListCancellable: DatabaseCancellable?
    
    /// 未读消息数量
    public let unreadCount = BehaviorRelay<Int>(value: 0)
    /// 会话列表
    public let conversationList = BehaviorRelay<[GLDatingConversation]>(value: [])
    /// 消息列表（实时回调，每发送一条消息，都会收到回调）只有监听了的才会回调
    public let messages = BehaviorRelay<[GLDatingMessageObject]>(value: [])
    
    
    private init() {
        
    }
}

extension GLDatingMessageManager {
    /// 初始化消息数据库
    private func _initDatabase() {
        guard let basePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last else { return }
        let dirPath = basePath + "/" + tableDirectory
        var isDirectory: ObjCBool = true
        if !FileManager.default.fileExists(atPath: dirPath, isDirectory: &isDirectory) {
            try? FileManager.default.createDirectory(atPath: dirPath, withIntermediateDirectories: true, attributes: nil)
        }
        let path = dirPath + "/" + tablePath
        GLDatingLog("消息数据库路径:\(path)")
        var configuration = GRDB.Configuration()
        configuration.busyMode = .timeout(10)
        configuration.readonly = false
        //        configuration.prepareDatabase { (db) in
        //            db.trace(options: [.statement]) { (event) in
        //                #if DEBUG
        //                print("\(event.description)") // 打印SQL语句
        //                #endif
        //            }
        //        }
        do {
            let dbQueue = try DatabaseQueue(path: path, configuration: configuration)
            self.dbQueue = dbQueue
            GLDatingLog("初始化消息数据库成功")
        } catch {
            GLDatingLog("初始化消息数据库失败: \(error.localizedDescription)")
        }
    }
    
    /// 创建消息数据库
    private func _creatMessageDatabase() {
        guard let dbQueue = self.dbQueue else {
            GLDatingLog("数据库队列不存在，不能创建消息数据库")
            return
        }
        do {
            try dbQueue.write({ (db) in
                if try db.tableExists(GLDatingMessageTableName) {
                    throw GLDatingError.error("消息表已存在，不能再创建")
                }
                try db.create(table: GLDatingMessageTableName, temporary: false, ifNotExists: true, body: { (t) in
                    t.column(GLDatingMessage.CodingKeys.message_id.rawValue, .text).primaryKey().indexed()
                    t.column(GLDatingMessage.CodingKeys.conversation_id.rawValue, .text)
                    t.column(GLDatingMessage.CodingKeys.owner_id.rawValue, .text)
                    t.column(GLDatingMessage.CodingKeys.message_type.rawValue, .integer)
                    t.column(GLDatingMessage.CodingKeys.content.rawValue, .text)
                    t.column(GLDatingMessage.CodingKeys.time_stmp.rawValue, .integer)
                    t.column(GLDatingMessage.CodingKeys.is_sender.rawValue, .boolean)
                    t.column(GLDatingMessage.CodingKeys.is_read.rawValue, .boolean)
                    t.column(GLDatingMessage.CodingKeys.user_info.rawValue, .text)
                })
            })
            GLDatingLog("消息表创建成功")
        } catch {
            GLDatingLog("消息表创建失败: \(error.localizedDescription)")
        }
    }
}

extension GLDatingMessageManager {
    /// 注册`ownerID`(第一步)
    public func register(ownerID: String?) {
        self.ownerID = ownerID
    }
    
    /// 创建消息数据库(第二步)
    public func creatDataBase() {
        self._initDatabase()
        self._creatMessageDatabase()
    }
    
    /// 注销（退出登录的时候调用）
    public func unRegister() {
        self.ownerID = nil
        self.conversationList.accept([])
        self.unreadCountCancellable?.cancel()
        self.conversationListCancellable?.cancel()
        var messages = self.messages.value
        for (_, obejct) in messages.enumerated() {
            obejct.cancellable?.cancel()
            obejct.messages = []
        }
        messages.removeAll()
        self.messages.accept([])
        self.dbQueue = nil
    }
    
    /// 发送消息
    @discardableResult
    public func sendMessage(conversationID: String?,
                            messageType: GLDatingMessageType,
                            messageContent: String?,
                            isSender: Bool,
                            isRead: Bool,
                            userInfo: GLDatingMessageUserInfo?) -> GLDatingMessage? {
        guard let conversationID = conversationID else {
            GLDatingLog("[发送消息] conversationID = nil")
            return nil
        }
        guard let ownerID = self.ownerID else {
            GLDatingLog("[发送消息] ownerID = nil")
            return nil
        }
        guard let dbQueue = self.dbQueue else {
            GLDatingLog("[发送消息] 数据库队列不存在")
            return nil
        }
        
        let message = GLDatingMessage()
        message.conversation_id = conversationID
        message.content = messageContent
        message.owner_id = ownerID
        message.message_type = messageType
        message.is_sender = isSender
        message.is_read = isRead
        message.user_info = userInfo
        
        do {
            try dbQueue.write({ (db) in
                do {
                    try message.insert(db)
                } catch {
                    throw error
                }
            })
            GLDatingLog("[发送消息] [消息发送成功]")
            return message
        } catch {
            GLDatingLog("[发送消息] [消息发送失败] \(error.localizedDescription)")
            return nil
        }
    }
    
    /// 监控消息未读数量
    public func startListeningMessageUnreadCount() {
        guard let dbQueue = self.dbQueue else {
            GLDatingLog("[监控总未读消息数量失败] 数据库队列不存在")
            self.unreadCount.accept(0)
            return
        }
        
        guard let ownerID = self.ownerID else {
            GLDatingLog("[监控总未读消息数量失败] ownerID = nil")
            self.unreadCount.accept(0)
            return
        }
        
        self.unreadCountCancellable = ValueObservation.tracking({ (db) -> Int in
            let predicate: GRDB.SQLSpecificExpressible =
                Column(GLDatingMessage.CodingKeys.owner_id.rawValue) == ownerID &&
                Column(GLDatingMessage.CodingKeys.is_read.rawValue) == false
            return try GLDatingMessage.filter(predicate).fetchCount(db)
        }).removeDuplicates().start(in: dbQueue, onError: { [weak self] (error) in
            guard let self = self else { return }
            GLDatingLog("[监控总未读消息数量发生错误] \(error.localizedDescription)")
            self.unreadCount.accept(0)
        }, onChange: { [weak self] (count) in
            guard let self = self else { return }
            GLDatingLog("[监控总未读消息数量成功] [收到总未读消息数量改变] \(count)")
            self.unreadCount.accept(count)
        })
    }
    
    /// 监控会话列表
    public func startListeningConversationList() {
        guard let dbQueue = self.dbQueue else {
            GLDatingLog("[监控所有会话列表失败] 数据库队列不存在")
            self.unreadCount.accept(0)
            return
        }
        
        guard let ownerID = self.ownerID else {
            GLDatingLog("[监控所有会话列表失败] ownerID = nil")
            self.unreadCount.accept(0)
            return
        }
        self.conversationListCancellable = ValueObservation.tracking({ (db) -> [String] in
            let predicate: GRDB.SQLSpecificExpressible =
                Column(GLDatingMessage.CodingKeys.owner_id.rawValue) == ownerID
            return try GLDatingMessage
                .filter(predicate)
                .group(Column(GLDatingMessage.CodingKeys.conversation_id))
                .fetchAll(db)
                .map{ $0.conversation_id }
        }).start(in: dbQueue, onError: { (error) in
            GLDatingLog("[监控所有会话列表失败] \(error.localizedDescription)")
        }, onChange: { [weak self] (allConversationIDs) in
            guard let self = self else { return }
            GLDatingLog("[监控所有会话列表成功] [收到所有会话列表改变]")
            do {
                let conversationList = try dbQueue.write { (db) -> [GLDatingConversation] in
                    var conversationList: [GLDatingConversation] = []
                    for (_, conversationID) in allConversationIDs.enumerated() {
                        let predicate: GRDB.SQLSpecificExpressible =
                            Column(GLDatingMessage.CodingKeys.owner_id.rawValue) == ownerID &&
                            Column(GLDatingMessage.CodingKeys.conversation_id.rawValue) == conversationID
                        let tmpMessages = try GLDatingMessage
                            .filter(predicate)
                            .order(Column(GLDatingMessage.CodingKeys.time_stmp).asc)
                            .fetchAll(db)
                        let unReadCount = tmpMessages.filter{ $0.is_read == false }.count
                        let latestMessage = tmpMessages.last
                        let conversation = GLDatingConversation()
                        conversation.conversationID = conversationID
                        conversation.messageType = latestMessage?.message_type ?? .text
                        conversation.timeStmp = latestMessage?.time_stmp ?? 0
                        conversation.unReadCount = unReadCount
                        conversation.latestMessage = latestMessage?.content
                        let isSender = latestMessage?.is_sender ?? false
                        if isSender {
                            conversation.avatar = latestMessage?.user_info?.receiver_avatar
                            conversation.nickName = latestMessage?.user_info?.receiver_name
                        } else {
                            conversation.avatar = latestMessage?.user_info?.sender_avatar
                            conversation.nickName = latestMessage?.user_info?.sender_name
                        }
                        //
                        conversationList.append(conversation)
                    }
                    return conversationList
                }
                let tmpConversationList = conversationList.sorted { (o1, o2) -> Bool in
                    return o1.timeStmp >= o2.timeStmp
                }
                self.conversationList.accept(tmpConversationList)
            } catch {
                self.conversationList.accept([])
            }
        })
    }
    
    /// 开始监听某个会话的所有消息(多次调用该方法，且每次传入的`conversationID`不同，表示同时监控这些会话消息)。监听的只是数量改变，消息本身状态改变不会被监听
    public func startListeningAllMessages(conversationID: String?) {
        guard let conversationID = conversationID else {
            GLDatingLog("[监控会话消息失败] conversationID = nil")
            return
        }
        guard let dbQueue = self.dbQueue else {
            GLDatingLog("[监控会话`\(conversationID)`消息失败] 数据库队列不存在")
            return
        }
        guard let ownerID = self.ownerID else {
            GLDatingLog("[监控会话`\(conversationID)`消息失败] ownerID = nil")
            return
        }
        
        var messages = self.messages.value
        var contain: Bool = false
        for (_, object) in messages.enumerated() {
            if object.conversationID == conversationID {
                contain = true
                break
            }
        }
        if contain {
            GLDatingLog("[已经监控会话`\(conversationID)`] 不能再次监控")
            return
        }
        
        let cancellable = ValueObservation.tracking { (db) -> Int in
            let predicate: GRDB.SQLSpecificExpressible =
                Column(GLDatingMessage.CodingKeys.owner_id.rawValue) == ownerID &&
                Column(GLDatingMessage.CodingKeys.conversation_id.rawValue) == conversationID
            return try GLDatingMessage.filter(predicate).fetchCount(db)
        }.removeDuplicates().start(in: dbQueue) { (error) in
            GLDatingLog("[监控会话`\(conversationID)`失败] \(error.localizedDescription)")
        } onChange: { [weak self] (count) in
            guard let self = self else { return }
            GLDatingLog("[监控会话`\(conversationID)`成功] [收到消息变化]")
            do {
                let tmpMessages = try dbQueue.write { (db) -> [GLDatingMessage] in
                    let predicate: GRDB.SQLSpecificExpressible =
                        Column(GLDatingMessage.CodingKeys.owner_id.rawValue) == ownerID &&
                        Column(GLDatingMessage.CodingKeys.conversation_id.rawValue) == conversationID
                    return try GLDatingMessage
                        .filter(predicate)
                        .order(Column(GLDatingMessage.CodingKeys.time_stmp).asc)
                        .fetchAll(db)
                }
                GLDatingLog("[监控会话`\(conversationID)`成功] [收到消息变化] [之后查询所有消息成功]")
                let messages = self.messages.value
                var isChange: Bool = false
                for (_, object) in messages.enumerated() {
                    if object.conversationID == conversationID {
                        object.messages = tmpMessages
                        isChange = true
                        break
                    }
                }
                if isChange {
                    self.messages.accept(messages)
                }
            } catch {
                GLDatingLog("[监控会话`\(conversationID)`成功] [收到消息变化] [之后查询所有消息失败] \(error.localizedDescription)")
            }
        }
        let object = GLDatingMessageObject(conversationID: conversationID)
        object.cancellable = cancellable
        object.messages = []
        messages.append(object)
        self.messages.accept(messages)
    }
    
    /// 取消监听某个会话的所有消息，同时该会话下的消息会被清空
    public func unListeningAllMessages(conversationID: String?) {
        var messages = self.messages.value
        for (index, object) in messages.enumerated() {
            if object.conversationID == conversationID {
                object.cancellable?.cancel()
                messages.remove(at: index)
                break
            }
        }
        self.messages.accept(messages)
    }
    
    /// 标记某个会话已读
    public func markHasRead(conversationID: String?) {
        guard let conversationID = conversationID else {
            GLDatingLog("[标记会话已读] conversationID = nil")
            return
        }
        guard let dbQueue = self.dbQueue else {
            GLDatingLog("[标记会话`\(conversationID)`已读失败] 数据库队列不存在")
            return
        }
        guard let ownerID = self.ownerID else {
            GLDatingLog("[标记会话`\(conversationID)`已读失败] ownerID = nil")
            return
        }
        do {
            try dbQueue.write { (db) in
                let predicate: GRDB.SQLSpecificExpressible =
                    Column(GLDatingMessage.CodingKeys.owner_id.rawValue) == ownerID &&
                    Column(GLDatingMessage.CodingKeys.conversation_id.rawValue) == conversationID &&
                    Column(GLDatingMessage.CodingKeys.is_read.rawValue) == false
                
                let assignment: ColumnAssignment = Column(GLDatingMessage.CodingKeys.is_read.rawValue).set(to: true)
                
                try GLDatingMessage
                    .filter(predicate)
                    .updateAll(db, assignment)
            }
            GLDatingLog("[标记会话`\(conversationID)`已读成功]")
        } catch {
            GLDatingLog("[标记会话`\(conversationID)`已读失败] \(error.localizedDescription)")
        }
    }
}
