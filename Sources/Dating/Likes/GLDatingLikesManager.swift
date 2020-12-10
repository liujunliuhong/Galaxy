//
//  GLDatingLikesManager.swift
//  SwiftTool
//
//  Created by Yule on 2020/12/9.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import UIKit
import GRDB

private let tableDirectory = "GLDatingUserDatabase"
private let tablePath = "user.db"

public class GLDatingLikesManager {
    public static let `default` = GLDatingLikesManager()
    
    private var dbQueue: DatabaseQueue?
    
    private init() {
        self.initDatabase()
        self.creatDatabase()
    }
}

extension GLDatingLikesManager {
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
        print("`Likes`数据库路径:\(path)")
        #endif
        var configuration = GRDB.Configuration()
        configuration.busyMode = .timeout(10)
        configuration.readonly = false
        do {
            let dbQueue = try DatabaseQueue(path: path, configuration: configuration)
            self.dbQueue = dbQueue
            #if DEBUG
            print("初始化`Likes`数据库成功")
            #endif
        } catch {
            #if DEBUG
            print("初始化`Likes`数据库失败: \(error.localizedDescription)")
            #endif
        }
    }
    
    /// 创建数据库
    private func creatDatabase() {
        do {
            try self.dbQueue?.write({ (db) in
                if try db.tableExists(GLDatingLikesTableName) {
                    throw GLDatingError.error("`Likes`表已存在，不能再创建")
                }
                try db.create(table: GLDatingLikesTableName, temporary: false, ifNotExists: true, body: { (t) in
                    t.column(GLDatingLikes.CodingKeys.ID.rawValue, .text).primaryKey().indexed()
                    t.column(GLDatingLikes.CodingKeys.userID.rawValue, .text)
                    t.column(GLDatingLikes.CodingKeys.ownerID.rawValue, .text)
                    t.column(GLDatingLikes.CodingKeys.avatar.rawValue, .integer)
                    t.column(GLDatingLikes.CodingKeys.name.rawValue, .integer)
                    t.column(GLDatingLikes.CodingKeys.timeStmp.rawValue, .integer)
                })
            })
            #if DEBUG
            print("`Likes`表创建成功")
            #endif
        } catch {
            #if DEBUG
            print("`Likes`表创建失败: \(error.localizedDescription)")
            #endif
        }
    }
}

extension GLDatingLikesManager {
    /// 添加喜欢
    public func addLikes(ownerID: String?, userID: String?, avatar: String?, name: String?) throws {
        guard let ownerID = ownerID else {
            throw GLDatingError.error("ownerID is nil")
        }
        guard let userID = userID else {
            throw GLDatingError.error("userID is nil")
        }
        
        // 先查询
        let count = (try? self.dbQueue?.write({ (db) -> Int in
            return try GLDatingLikes.filter(Column(GLDatingLikes.CodingKeys.ownerID.rawValue) == ownerID && Column(GLDatingLikes.CodingKeys.userID.rawValue) == userID).fetchCount(db)
        })) ?? 0
        
        if count > 0 {
            throw GLDatingError.error("You already like this user")
        }
        
        let likes = GLDatingLikes()
        likes.ownerID = ownerID
        likes.userID = userID
        likes.avatar = avatar
        likes.name = name
        
        do {
            try self.dbQueue?.write({ (db) in
                do {
                    try likes.insert(db)
                } catch {
                    throw error
                }
            })
            
            #if DEBUG
            print("[添加`Likes`成功]")
            #endif
        } catch {
            #if DEBUG
            print("[添加`Likes`失败] \(error.localizedDescription)")
            #endif
            throw error
        }
    }
    
    /// 移除喜欢
    public func deleteLikes(ownerID: String?, userID: String?) throws {
        guard let ownerID = ownerID else {
            throw GLDatingError.error("ownerID is nil")
        }
        guard let userID = userID else {
            throw GLDatingError.error("userID is nil")
        }
        
        do {
            try self.dbQueue?.write({ (db) -> Void in
                try GLDatingLikes.deleteAll(db, keys: [[GLDatingLikes.CodingKeys.ownerID.rawValue: ownerID], [GLDatingLikes.CodingKeys.userID.rawValue: userID]])
            })
            #if DEBUG
            print("[`Likes`删除成功]")
            #endif
        } catch {
            #if DEBUG
            print("[`Likes`删除失败] \(error)")
            #endif
            throw error
        }
    }
    
    /// 查询是否喜欢了某个人
    public func queryIsLikes(ownerID: String?, userID: String?) throws -> Bool {
        guard let ownerID = ownerID else {
            throw GLDatingError.error("ownerID is nil")
        }
        guard let userID = userID else {
            throw GLDatingError.error("userID is nil")
        }
        // 查询
        let count = (try? self.dbQueue?.write({ (db) -> Int in
            return try GLDatingLikes.filter(Column(GLDatingLikes.CodingKeys.ownerID.rawValue) == ownerID && Column(GLDatingLikes.CodingKeys.userID.rawValue) == userID).fetchCount(db)
        })) ?? 0
        #if DEBUG
        print("[查询是否`Likes`成功] \(count > 0)")
        #endif
        return count > 0
    }
    
    /// 获取所有喜欢
    public func queryAllLikes(ownerID: String?) throws -> [GLDatingLikes] {
        guard let ownerID = ownerID else {
            throw GLDatingError.error("ownerID is nil")
        }
        
        do {
            let results = try self.dbQueue?.write({ (db) -> [GLDatingLikes] in
                return try GLDatingLikes.filter(Column(GLDatingLikes.CodingKeys.ownerID.rawValue) == ownerID).fetchAll(db)
            })
            #if DEBUG
            print("[获取所有`Likes`成功]")
            #endif
            return results ?? []
        } catch {
            #if DEBUG
            print("[获取所有`Likes`失败] \(error)")
            #endif
            throw error
        }
    }
    
    /// 删除所有喜欢
    public func deleteAllLikes(ownerID: String?) throws {
        guard let ownerID = ownerID else {
            throw GLDatingError.error("ownerID is nil")
        }
        do {
            try self.dbQueue?.write({ (db) -> Void in
                try GLDatingLikes.deleteAll(db, keys: [[GLDatingLikes.CodingKeys.ownerID.rawValue: ownerID]])
            })
            #if DEBUG
            print("[删除所有`Likes`成功]")
            #endif
        } catch {
            #if DEBUG
            print("[删除所有`Likes`失败] \(error)")
            #endif
            throw error
        }
    }
}
