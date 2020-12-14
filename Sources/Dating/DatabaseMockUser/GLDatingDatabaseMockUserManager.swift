//
//  GLDatingDatabaseMockUserManager.swift
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

public class GLDatingDatabaseMockUserObject {
    public let type: GLDatingDatabaseMockUserType
    public var dataSource: [GLDatingDatabaseMockUser] = []
    public var cancellable: DatabaseCancellable?
    public init(type: GLDatingDatabaseMockUserType) {
        self.type = type
    }
}

public class GLDatingDatabaseMockUserManager {
    public static let `default` = GLDatingDatabaseMockUserManager()
    
    private var dbQueue: DatabaseQueue?
    private var ownerID: String?
    private var dataSourceCancellable: DatabaseCancellable?
    
    /// 数据源（实时回调）只有监听了的才会回调
    public let dataSource = BehaviorRelay<[GLDatingDatabaseMockUserObject]>(value: [])
    
    
    private init() {
        
    }
}

extension GLDatingDatabaseMockUserManager {
    /// 初始化数据库
    private func _initDatabase() {
        guard let basePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last else { return }
        let dirPath = basePath + "/" + tableDirectory
        var isDirectory: ObjCBool = true
        if !FileManager.default.fileExists(atPath: dirPath, isDirectory: &isDirectory) {
            try? FileManager.default.createDirectory(atPath: dirPath, withIntermediateDirectories: true, attributes: nil)
        }
        let path = dirPath + "/" + tablePath
        
        GLDatingLog("[DatingDatabaseMockUser] 数据库路径:\(path)")
        
        var configuration = GRDB.Configuration()
        configuration.busyMode = .timeout(10)
        configuration.readonly = false
        do {
            let dbQueue = try DatabaseQueue(path: path, configuration: configuration)
            self.dbQueue = dbQueue
            GLDatingLog("[DatingDatabaseMockUser] 初始化数据库成功")
        } catch {
            GLDatingLog("[DatingDatabaseMockUser] 初始化数据库失败: \(error.localizedDescription)")
        }
    }
    
    /// 创建数据库
    private func _creatDatabase() {
        guard let dbQueue = self.dbQueue else {
            GLDatingLog("[DatingDatabaseMockUser] 数据库队列不存在")
            return
        }
        do {
            try dbQueue.write({ (db) in
                if try db.tableExists(GLDatingDatabaseMockUserTableName) {
                    throw GLDatingError.error("表已存在，不能再创建")
                }
                try db.create(table: GLDatingDatabaseMockUserTableName, temporary: false, ifNotExists: true, body: { (t) in
                    t.column(GLDatingDatabaseMockUser.CodingKeys.ID.rawValue, .text).primaryKey().indexed()
                    t.column(GLDatingDatabaseMockUser.CodingKeys.user_id.rawValue, .text)
                    t.column(GLDatingDatabaseMockUser.CodingKeys.owner_id.rawValue, .text)
                    t.column(GLDatingDatabaseMockUser.CodingKeys.avatar.rawValue, .integer)
                    t.column(GLDatingDatabaseMockUser.CodingKeys.name.rawValue, .integer)
                    t.column(GLDatingDatabaseMockUser.CodingKeys.time_stmp.rawValue, .integer)
                    t.column(GLDatingDatabaseMockUser.CodingKeys.type.rawValue, .integer)
                    t.column(GLDatingDatabaseMockUser.CodingKeys.ext.rawValue, .text)
                })
            })
            GLDatingLog("[DatingDatabaseMockUser] 表创建成功")
        } catch {
            GLDatingLog("[DatingDatabaseMockUser] 表创建失败: \(error.localizedDescription)")
        }
    }
}

extension GLDatingDatabaseMockUserManager {
    
    /// 注册`ownerID`(第一步)
    public func register(ownerID: String?) {
        self.ownerID = ownerID
    }
    
    /// 创建`DatabaseMockUser`数据库(第二步)
    public func creatDataBase() {
        self._initDatabase()
        self._creatDatabase()
    }
    
    /// 注销（退出登录的时候调用）
    public func unRegister() {
        self.dataSourceCancellable?.cancel()
        self.dataSourceCancellable = nil
        var dataSource = self.dataSource.value
        for (_, obejct) in dataSource.enumerated() {
            obejct.cancellable?.cancel()
            obejct.dataSource = []
        }
        dataSource.removeAll()
        self.dataSource.accept([])
        self.ownerID = nil
        self.dbQueue = nil
    }
    
    /// 添加
    public func addObject(userID: String?,
                          avatar: String?,
                          name: String?,
                          type: GLDatingDatabaseMockUserType,
                          ext: String? = nil) throws {
        let avatar = avatar
        let name = name
        let type = type
        let ext = ext
        guard let ownerID = self.ownerID else {
            GLDatingLog("[DatingDatabaseMockUser] [ownerID is nil]")
            throw GLDatingError.error("ownerID is nil")
        }
        guard let userID = userID else {
            GLDatingLog("[DatingDatabaseMockUser] [userID is nil]")
            throw GLDatingError.error("userID is nil")
        }
        guard let dbQueue = self.dbQueue else {
            GLDatingLog("[DatingDatabaseMockUser] 数据库队列不存在")
            throw GLDatingError.error("数据库队列不存在")
        }
        
        // 先查询
        let count = (try? dbQueue.write({ (db) -> Int in
            let predicate: GRDB.SQLSpecificExpressible =
                Column(GLDatingDatabaseMockUser.CodingKeys.owner_id.rawValue) == ownerID &&
                Column(GLDatingDatabaseMockUser.CodingKeys.user_id.rawValue) == userID &&
                Column(GLDatingDatabaseMockUser.CodingKeys.type.rawValue) == type
            
            return try GLDatingDatabaseMockUser.filter(predicate).fetchCount(db)
        })) ?? 0
        
        if count > 0 {
            throw GLDatingError.error("You already like this user")
        }
        
        let databaseMockUser = GLDatingDatabaseMockUser()
        databaseMockUser.owner_id = ownerID
        databaseMockUser.user_id = userID
        databaseMockUser.avatar = avatar
        databaseMockUser.name = name
        databaseMockUser.type = type
        databaseMockUser.ext = ext
        
        do {
            try dbQueue.write({ (db) in
                do {
                    try databaseMockUser.insert(db)
                } catch {
                    throw error
                }
            })
            GLDatingLog("[DatingDatabaseMockUser] [添加成功]")
        } catch {
            GLDatingLog("[DatingDatabaseMockUser] [添加失败] \(error.localizedDescription)")
            throw error
        }
    }
    
    /// 移除
    public func deleteObject(userID: String?,
                             type: GLDatingDatabaseMockUserType) throws {
        let type = type
        guard let ownerID = self.ownerID else {
            GLDatingLog("[DatingDatabaseMockUser] [ownerID is nil]")
            throw GLDatingError.error("ownerID is nil")
        }
        guard let userID = userID else {
            GLDatingLog("[DatingDatabaseMockUser] [userID is nil]")
            throw GLDatingError.error("userID is nil")
        }
        guard let dbQueue = self.dbQueue else {
            GLDatingLog("[DatingDatabaseMockUser] 数据库队列不存在")
            throw GLDatingError.error("数据库队列不存在")
        }
        
        do {
            try dbQueue.write({ (db) -> Void in
                let predicate: GRDB.SQLSpecificExpressible =
                    Column(GLDatingDatabaseMockUser.CodingKeys.owner_id.rawValue) == ownerID &&
                    Column(GLDatingDatabaseMockUser.CodingKeys.user_id.rawValue) == userID &&
                    Column(GLDatingDatabaseMockUser.CodingKeys.type.rawValue) == type
                
                try GLDatingDatabaseMockUser.filter(predicate).deleteAll(db)
            })
            GLDatingLog("[DatingDatabaseMockUser] [删除成功]")
        } catch {
            GLDatingLog("[DatingDatabaseMockUser] [删除失败] \(error.localizedDescription)")
            throw error
        }
    }
    
    /// 查询是否添加
    public func queryIsAdd(userID: String?,
                           type: GLDatingDatabaseMockUserType) -> Bool {
        let type = type
        guard let ownerID = self.ownerID else {
            GLDatingLog("[DatingDatabaseMockUser] [ownerID is nil]")
            return false
        }
        guard let userID = userID else {
            GLDatingLog("[DatingDatabaseMockUser] [userID is nil]")
            return false
        }
        guard let dbQueue = self.dbQueue else {
            GLDatingLog("[DatingDatabaseMockUser] 数据库队列不存在")
            return false
        }
        // 查询
        let count = (try? dbQueue.write({ (db) -> Int in
            let predicate: GRDB.SQLSpecificExpressible =
                Column(GLDatingDatabaseMockUser.CodingKeys.owner_id.rawValue) == ownerID &&
                Column(GLDatingDatabaseMockUser.CodingKeys.user_id.rawValue) == userID &&
                Column(GLDatingDatabaseMockUser.CodingKeys.type.rawValue) == type
            return try GLDatingDatabaseMockUser.filter(predicate).fetchCount(db)
        })) ?? 0
        GLDatingLog("[DatingDatabaseMockUser] [查询是否Add成功] \(count > 0)")
        return count > 0
    }
    
    /// 获取所有数据
    public func queryAllAdds(type: GLDatingDatabaseMockUserType) -> [GLDatingDatabaseMockUser] {
        let type = type
        guard let ownerID = self.ownerID else {
            GLDatingLog("[DatingDatabaseMockUser] [ownerID is nil]")
            return []
        }
        guard let dbQueue = self.dbQueue else {
            GLDatingLog("[DatingDatabaseMockUser] 数据库队列不存在")
            return []
        }
        
        let results = try? dbQueue.write({ (db) -> [GLDatingDatabaseMockUser] in
            let predicate: GRDB.SQLSpecificExpressible =
                Column(GLDatingDatabaseMockUser.CodingKeys.owner_id.rawValue) == ownerID &&
                Column(GLDatingDatabaseMockUser.CodingKeys.type.rawValue) == type
            
            return try GLDatingDatabaseMockUser
                .order(Column(GLDatingDatabaseMockUser.CodingKeys.time_stmp).desc)
                .filter(predicate)
                .fetchAll(db)
        })
        GLDatingLog("[DatingDatabaseMockUser] [获取`\(type.rawValue)`所有数据成功]")
        return results ?? []
    }
    
    /// 删除所有数据
    public func deleteAllObjects(type: GLDatingDatabaseMockUserType) throws {
        let type = type
        guard let ownerID = ownerID else {
            GLDatingLog("[DatingDatabaseMockUser] [ownerID is nil]")
            throw GLDatingError.error("ownerID is nil")
        }
        guard let dbQueue = self.dbQueue else {
            GLDatingLog("[DatingDatabaseMockUser] 数据库队列不存在")
            throw GLDatingError.error("数据库队列不存在")
        }
        do {
            try dbQueue.write({ (db) -> Void in
                let predicate: GRDB.SQLSpecificExpressible = Column(GLDatingDatabaseMockUser.CodingKeys.owner_id.rawValue) == ownerID &&
                    Column(GLDatingDatabaseMockUser.CodingKeys.type.rawValue) == type
                
                try GLDatingDatabaseMockUser.filter(predicate).deleteAll(db)
            })
            GLDatingLog("[DatingDatabaseMockUser] [删除所有数据成功]")
        } catch {
            GLDatingLog("[DatingDatabaseMockUser] [删除所有数据失败] \(error.localizedDescription)")
            throw error
        }
    }
    
    /// 开始监听
    public func startListeningDataSource(type: GLDatingDatabaseMockUserType) {
        let type = type
        guard let dbQueue = self.dbQueue else {
            GLDatingLog("[监控`DatabaseMockUser`失败] 数据库队列不存在")
            return
        }
        guard let ownerID = self.ownerID else {
            GLDatingLog("[监控`DatabaseMockUser`失败] ownerID = nil")
            return
        }
        var dataSource = self.dataSource.value
        var contain: Bool = false
        for (_, object) in dataSource.enumerated() {
            if object.type == type {
                contain = true
                break
            }
        }
        if contain {
            GLDatingLog("[监控`DatabaseMockUser`失败] [已经监控`\(type.rawValue)`] 不能再次监控")
            return
        }
        
        let cancellable = ValueObservation.tracking { (db) -> [GLDatingDatabaseMockUser] in
            let predicate: GRDB.SQLSpecificExpressible =
                Column(GLDatingDatabaseMockUser.CodingKeys.owner_id.rawValue) == ownerID &&
                Column(GLDatingDatabaseMockUser.CodingKeys.type.rawValue) == type
            return try GLDatingDatabaseMockUser
                .order(Column(GLDatingDatabaseMockUser.CodingKeys.time_stmp).desc)
                .filter(predicate)
                .fetchAll(db)
        }.start(in: dbQueue) { (error) in
            GLDatingLog("[监控`DatabaseMockUser`失败] \(error.localizedDescription)")
        } onChange: { [weak self] (tmpDataSource) in
            guard let self = self else { return }
            GLDatingLog("[监控`DatabaseMockUser`成功] [type = `\(type.rawValue)`]")
            
            let dataSource = self.dataSource.value
            var isChange: Bool = false
            for (_, object) in dataSource.enumerated() {
                if object.type == type {
                    object.dataSource = tmpDataSource
                    isChange = true
                    break
                }
            }
            if isChange {
                self.dataSource.accept(dataSource)
            }
        }
        let object = GLDatingDatabaseMockUserObject(type: type)
        object.cancellable = cancellable
        object.dataSource = []
        dataSource.append(object)
        self.dataSource.accept(dataSource)
    }
}


