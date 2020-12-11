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

private let tableDirectory = "GLDatingUserDatabase"
private let tablePath = "user.db"

public class GLDatingDatabaseMockUserManager {
    public static let `default` = GLDatingDatabaseMockUserManager()
    
    private var dbQueue: DatabaseQueue?
    
    private init() {
        self.initDatabase()
        self.creatDatabase()
    }
}

extension GLDatingDatabaseMockUserManager {
    /// 初始化数据库
    private func initDatabase() {
        guard let basePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last else { return }
        let dirPath = basePath + "/" + tableDirectory
        var isDirectory: ObjCBool = true
        if !FileManager.default.fileExists(atPath: dirPath, isDirectory: &isDirectory) {
            try? FileManager.default.createDirectory(atPath: dirPath, withIntermediateDirectories: true, attributes: nil)
        }
        let path = dirPath + "/" + tablePath
        #if DEBUG
        print("`[DatingDatabaseMockUser] 数据库路径:\(path)")
        #endif
        var configuration = GRDB.Configuration()
        configuration.busyMode = .timeout(10)
        configuration.readonly = false
        do {
            let dbQueue = try DatabaseQueue(path: path, configuration: configuration)
            self.dbQueue = dbQueue
            #if DEBUG
            print("[DatingDatabaseMockUser] 初始化数据库成功")
            #endif
        } catch {
            #if DEBUG
            print("[DatingDatabaseMockUser] 初始化数据库失败: \(error.localizedDescription)")
            #endif
        }
    }
    
    /// 创建数据库
    private func creatDatabase() {
        guard let dbQueue = self.dbQueue else {
            #if DEBUG
            print("[DatingDatabaseMockUser] 数据库队列不存在")
            #endif
            return
        }
        do {
            try dbQueue.write({ (db) in
                if try db.tableExists(GLDatingDatabaseMockUserTableName) {
                    throw GLDatingError.error("`Likes`表已存在，不能再创建")
                }
                try db.create(table: GLDatingDatabaseMockUserTableName, temporary: false, ifNotExists: true, body: { (t) in
                    t.column(GLDatingDatabaseMockUser.CodingKeys.ID.rawValue, .text).primaryKey().indexed()
                    t.column(GLDatingDatabaseMockUser.CodingKeys.userID.rawValue, .text)
                    t.column(GLDatingDatabaseMockUser.CodingKeys.ownerID.rawValue, .text)
                    t.column(GLDatingDatabaseMockUser.CodingKeys.avatar.rawValue, .integer)
                    t.column(GLDatingDatabaseMockUser.CodingKeys.name.rawValue, .integer)
                    t.column(GLDatingDatabaseMockUser.CodingKeys.timeStmp.rawValue, .integer)
                    t.column(GLDatingDatabaseMockUser.CodingKeys.type.rawValue, .integer)
                    t.column(GLDatingDatabaseMockUser.CodingKeys.ext.rawValue, .text)
                })
            })
            #if DEBUG
            print("[DatingDatabaseMockUser] 表创建成功")
            #endif
        } catch {
            #if DEBUG
            print("[DatingDatabaseMockUser] 表创建失败: \(error.localizedDescription)")
            #endif
        }
    }
}

extension GLDatingDatabaseMockUserManager {
    /// 添加
    public func addObject(ownerID: String?,
                          userID: String?,
                          avatar: String?,
                          name: String?,
                          type: GLDatingDatabaseMockUserType,
                          ext: String? = nil) throws {
        guard let ownerID = ownerID else {
            #if DEBUG
            print("[DatingDatabaseMockUser] [ownerID is nil]")
            #endif
            throw GLDatingError.error("ownerID is nil")
        }
        guard let userID = userID else {
            #if DEBUG
            print("[DatingDatabaseMockUser] [userID is nil]")
            #endif
            throw GLDatingError.error("userID is nil")
        }
        guard let dbQueue = self.dbQueue else {
            #if DEBUG
            print("[DatingDatabaseMockUser] 数据库队列不存在")
            #endif
            throw GLDatingError.error("数据库队列不存在")
        }
        
        // 先查询
        let count = (try? dbQueue.write({ (db) -> Int in
            let predicate: GRDB.SQLSpecificExpressible =
                Column(GLDatingDatabaseMockUser.CodingKeys.ownerID.rawValue) == ownerID &&
                Column(GLDatingDatabaseMockUser.CodingKeys.userID.rawValue) == userID &&
                Column(GLDatingDatabaseMockUser.CodingKeys.type.rawValue) == type
            
            return try GLDatingDatabaseMockUser.filter(predicate).fetchCount(db)
        })) ?? 0
        
        if count > 0 {
            throw GLDatingError.error("You already like this user")
        }
        
        let databaseMockUser = GLDatingDatabaseMockUser()
        databaseMockUser.ownerID = ownerID
        databaseMockUser.userID = userID
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
            #if DEBUG
            print("[DatingDatabaseMockUser] [添加成功]")
            #endif
        } catch {
            #if DEBUG
            print("[DatingDatabaseMockUser] [添加失败] \(error.localizedDescription)")
            #endif
            throw error
        }
    }
    
    /// 移除
    public func deleteObject(ownerID: String?,
                             userID: String?,
                             type: GLDatingDatabaseMockUserType) throws {
        guard let ownerID = ownerID else {
            #if DEBUG
            print("[DatingDatabaseMockUser] [ownerID is nil]")
            #endif
            throw GLDatingError.error("ownerID is nil")
        }
        guard let userID = userID else {
            #if DEBUG
            print("[DatingDatabaseMockUser] [userID is nil]")
            #endif
            throw GLDatingError.error("userID is nil")
        }
        guard let dbQueue = self.dbQueue else {
            #if DEBUG
            print("[DatingDatabaseMockUser] 数据库队列不存在")
            #endif
            throw GLDatingError.error("数据库队列不存在")
        }
        
        do {
            try dbQueue.write({ (db) -> Void in
                let keys: [[String: DatabaseValueConvertible?]] = [
                    [GLDatingDatabaseMockUser.CodingKeys.ownerID.rawValue: ownerID],
                    [GLDatingDatabaseMockUser.CodingKeys.userID.rawValue: userID],
                    [GLDatingDatabaseMockUser.CodingKeys.type.rawValue: type],
                ]
                try GLDatingDatabaseMockUser.deleteAll(db, keys: keys)
            })
            #if DEBUG
            print("[DatingDatabaseMockUser] [删除成功]")
            #endif
        } catch {
            #if DEBUG
            print("[DatingDatabaseMockUser] [删除失败] \(error.localizedDescription)")
            #endif
            throw error
        }
    }
    
    /// 查询是否添加
    public func queryIsAdd(ownerID: String?,
                           userID: String?,
                           type: GLDatingDatabaseMockUserType) -> Bool {
        guard let ownerID = ownerID else {
            #if DEBUG
            print("[DatingDatabaseMockUser] [ownerID is nil]")
            #endif
            return false
        }
        guard let userID = userID else {
            #if DEBUG
            print("[DatingDatabaseMockUser] [userID is nil]")
            #endif
            return false
        }
        guard let dbQueue = self.dbQueue else {
            #if DEBUG
            print("[DatingDatabaseMockUser] 数据库队列不存在")
            #endif
            return false
        }
        // 查询
        let count = (try? dbQueue.write({ (db) -> Int in
            let predicate: GRDB.SQLSpecificExpressible =
                Column(GLDatingDatabaseMockUser.CodingKeys.ownerID.rawValue) == ownerID &&
                Column(GLDatingDatabaseMockUser.CodingKeys.userID.rawValue) == userID &&
                Column(GLDatingDatabaseMockUser.CodingKeys.type.rawValue) == type
            
            return try GLDatingDatabaseMockUser.filter(predicate).fetchCount(db)
        })) ?? 0
        #if DEBUG
        print("[DatingDatabaseMockUser] [查询是否Add成功] \(count > 0)")
        #endif
        return count > 0
    }
    
    /// 获取所有数据
    public func queryAllAdds(ownerID: String?,
                             type: GLDatingDatabaseMockUserType) -> [GLDatingDatabaseMockUser] {
        guard let ownerID = ownerID else {
            #if DEBUG
            print("[DatingDatabaseMockUser] [ownerID is nil]")
            #endif
            return []
        }
        guard let dbQueue = self.dbQueue else {
            #if DEBUG
            print("[DatingDatabaseMockUser] 数据库队列不存在")
            #endif
            return []
        }
        
        let results = try? dbQueue.write({ (db) -> [GLDatingDatabaseMockUser] in
            let predicate: GRDB.SQLSpecificExpressible =
                Column(GLDatingDatabaseMockUser.CodingKeys.ownerID.rawValue) == ownerID &&
                Column(GLDatingDatabaseMockUser.CodingKeys.type.rawValue) == type
            
            return try GLDatingDatabaseMockUser.filter(predicate).fetchAll(db)
        })
        #if DEBUG
        print("[DatingDatabaseMockUser] [获取所有数据成功]")
        #endif
        return results ?? []
    }
    
    /// 删除所有数据
    public func deleteAllObjects(ownerID: String?,
                                 type: GLDatingDatabaseMockUserType) throws {
        guard let ownerID = ownerID else {
            #if DEBUG
            print("[DatingDatabaseMockUser] [ownerID is nil]")
            #endif
            throw GLDatingError.error("ownerID is nil")
        }
        guard let dbQueue = self.dbQueue else {
            #if DEBUG
            print("[DatingDatabaseMockUser] 数据库队列不存在")
            #endif
            throw GLDatingError.error("数据库队列不存在")
        }
        do {
            try dbQueue.write({ (db) -> Void in
                let keys: [[String: DatabaseValueConvertible?]] = [
                    [GLDatingDatabaseMockUser.CodingKeys.ownerID.rawValue: ownerID],
                    [GLDatingDatabaseMockUser.CodingKeys.type.rawValue: type]
                ]
                try GLDatingDatabaseMockUser.deleteAll(db, keys: keys)
            })
            #if DEBUG
            print("[DatingDatabaseMockUser] [删除所有数据成功]")
            #endif
        } catch {
            #if DEBUG
            print("[DatingDatabaseMockUser] [删除所有数据失败] \(error.localizedDescription)")
            #endif
            throw error
        }
    }
}
