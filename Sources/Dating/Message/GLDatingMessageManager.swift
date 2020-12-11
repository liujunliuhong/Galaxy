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
    /// 消息列表（实时回调，每发送一条消息，都会受到回调）只有监听了的才会回调
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
        #if DEBUG
        print("消息数据库路径:\(path)")
        #endif
        var configuration = GRDB.Configuration()
        configuration.busyMode = .timeout(10)
        configuration.readonly = false
        do {
            let dbQueue = try DatabaseQueue(path: path, configuration: configuration)
            self.dbQueue = dbQueue
            #if DEBUG
            print("初始化消息数据库成功")
            #endif
        } catch {
            #if DEBUG
            print("初始化消息数据库失败: \(error.localizedDescription)")
            #endif
        }
    }
    
    /// 创建消息数据库
    private func _creatMessageDatabase() {
        guard let dbQueue = self.dbQueue else {
            #if DEBUG
            print("数据库队列不存在，不能创建消息数据库")
            #endif
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
            #if DEBUG
            print("消息表创建成功")
            #endif
        } catch {
            #if DEBUG
            print("消息表创建失败: \(error.localizedDescription)")
            #endif
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
    public func sendMessage(conversationID: String?,
                            messageType: GLDatingMessageType,
                            messageContent: String?,
                            isSender: Bool,
                            isRead: Bool,
                            userInfo: GLDatingMessageUserInfo?) -> GLDatingMessage? {
        guard let conversationID = conversationID else {
            #if DEBUG
            print("[发送消息] conversationID = nil")
            #endif
            return nil
        }
        guard let ownerID = self.ownerID else {
            #if DEBUG
            print("[发送消息] ownerID = nil")
            #endif
            return nil
        }
        guard let dbQueue = self.dbQueue else {
            #if DEBUG
            print("[发送消息] 数据库队列不存在")
            #endif
            return nil
        }
        
        let message = GLDatingMessage()
        message.conversation_id = conversationID
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
            #if DEBUG
            print("[发送消息] [消息发送成功]")
            #endif
            return message
        } catch {
            #if DEBUG
            print("[发送消息] [消息发送失败] \(error.localizedDescription)")
            #endif
            return nil
        }
    }
    
    /// 监控消息未读数量
    func startListeningMessageUnreadCount() {
        guard let dbQueue = self.dbQueue else {
            #if DEBUG
            print("[监控未读消息数量] 数据库队列不存在")
            #endif
            self.unreadCount.accept(0)
            return
        }
        
        guard let ownerID = self.ownerID else {
            #if DEBUG
            print("[监控未读消息数量] ownerID = nil")
            #endif
            self.unreadCount.accept(0)
            return
        }
        
        self.unreadCountCancellable = ValueObservation.tracking({ (db) -> Int in
            let predicate: GRDB.SQLSpecificExpressible =
                Column(GLDatingMessage.CodingKeys.owner_id.rawValue) == ownerID &&
                Column(GLDatingMessage.CodingKeys.is_read.rawValue) == false
            return try GLDatingMessage.filter(predicate).fetchCount(db)
        }).start(in: dbQueue, onError: { [weak self] (error) in
            guard let self = self else { return }
            #if DEBUG
            print("[监控未读消息数量发生错误] \(error.localizedDescription)")
            #endif
            self.unreadCount.accept(0)
        }, onChange: { [weak self] (count) in
            guard let self = self else { return }
            #if DEBUG
            print("[监控未读消息数量成功] \(count)")
            #endif
            self.unreadCount.accept(count)
        })
    }
    
    /// 监控会话列表
    public func startListeningConversationList() {
        guard let dbQueue = self.dbQueue else {
            #if DEBUG
            print("[监控会话列表] 数据库队列不存在")
            #endif
            self.unreadCount.accept(0)
            return
        }
        
        guard let ownerID = self.ownerID else {
            #if DEBUG
            print("[监控会话列表] ownerID = nil")
            #endif
            self.unreadCount.accept(0)
            return
        }
        self.conversationListCancellable = ValueObservation.tracking({ (db) -> [GLDatingMessage] in
            let predicate: GRDB.SQLSpecificExpressible =
                Column(GLDatingMessage.CodingKeys.owner_id.rawValue) == ownerID
            return try GLDatingMessage
                .filter(predicate)
                .order(Column(GLDatingMessage.CodingKeys.time_stmp).desc)
                .group(Column(GLDatingMessage.CodingKeys.conversation_id))
                .fetchAll(db)
        }).start(in: dbQueue, onError: { (error) in
            #if DEBUG
            print("[监控会话列表失败] \(error.localizedDescription)")
            #endif
        }, onChange: { [weak self] (messages) in
            guard let self = self else { return }
            #if DEBUG
            print("[监控会话列表成功] \(messages)")
            #endif
            do {
                let conversationList = try dbQueue.write { (db) -> [GLDatingConversation] in
                    var conversationList: [GLDatingConversation] = []
                    for (_, message) in messages.enumerated() {
                        let conversation = GLDatingConversation()
                        conversation.conversationID = message.conversation_id
                        conversation.messageType = message.message_type
                        conversation.latestMessage = message.content
                        conversation.timeStmp = message.time_stmp
                        if message.is_sender {
                            conversation.avatar = message.user_info?.receiver_avatar
                            conversation.nickName = message.user_info?.receiver_name
                        } else {
                            conversation.avatar = message.user_info?.sender_avatar
                            conversation.nickName = message.user_info?.sender_name
                        }
                        //
                        let predicate: GRDB.SQLSpecificExpressible =
                            Column(GLDatingMessage.CodingKeys.owner_id.rawValue) == ownerID &&
                            Column(GLDatingMessage.CodingKeys.is_read.rawValue) == false &&
                            Column(GLDatingMessage.CodingKeys.conversation_id.rawValue) == message.conversation_id
                        let count = try GLDatingMessage.filter(predicate).fetchCount(db)
                        //
                        conversation.unReadCount = count
                        //
                        conversationList.append(conversation)
                    }
                    return conversationList
                }
                self.conversationList.accept(conversationList)
            } catch {
                var conversationList: [GLDatingConversation] = []
                for (_, message) in messages.enumerated() {
                    let conversation = GLDatingConversation()
                    conversation.conversationID = message.conversation_id
                    conversation.messageType = message.message_type
                    conversation.latestMessage = message.content
                    conversation.timeStmp = message.time_stmp
                    if message.is_sender {
                        conversation.avatar = message.user_info?.receiver_avatar
                        conversation.nickName = message.user_info?.receiver_name
                    } else {
                        conversation.avatar = message.user_info?.sender_avatar
                        conversation.nickName = message.user_info?.sender_name
                    }
                    conversation.unReadCount = 0
                    //
                    conversationList.append(conversation)
                }
                self.conversationList.accept(conversationList)
            }
        })
    }
    
    /// 开始监听某个会话的所有消息
    public func startListeningAllMessages(conversationID: String?) {
        guard let conversationID = conversationID else {
            #if DEBUG
            print("[监控会话消息失败] conversationID = nil")
            #endif
            return
        }
        guard let dbQueue = self.dbQueue else {
            #if DEBUG
            print("[监控会话`\(conversationID)`消息失败] 数据库队列不存在")
            #endif
            return
        }
        guard let ownerID = self.ownerID else {
            #if DEBUG
            print("[监控会话`\(conversationID)`消息失败] ownerID = nil")
            #endif
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
            #if DEBUG
            print("[已经监控会话`\(conversationID)`] 不能再次监控")
            #endif
            return
        }
        
        let cancellable = ValueObservation.tracking { (db) -> [GLDatingMessage] in
            let predicate: GRDB.SQLSpecificExpressible =
                Column(GLDatingMessage.CodingKeys.owner_id.rawValue) == ownerID &&
                Column(GLDatingMessage.CodingKeys.conversation_id.rawValue) == conversationID
            return try GLDatingMessage.filter(predicate).fetchAll(db)
        }.start(in: dbQueue) { (error) in
            #if DEBUG
            print("[监控会话`\(conversationID)`失败] \(error.localizedDescription)")
            #endif
        } onChange: { [weak self] (tmpMessages) in
            guard let self = self else { return }
            #if DEBUG
            print("[收到会话`\(conversationID)`改变]")
            #endif
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
}
