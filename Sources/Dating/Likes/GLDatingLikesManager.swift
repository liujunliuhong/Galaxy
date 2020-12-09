//
//  GLDatingLikesManager.swift
//  SwiftTool
//
//  Created by Yule on 2020/12/9.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import UIKit
import WCDBSwift

public class GLDatingLikesManager: NSObject {
    public static let `default` = GLDatingLikesManager()
    
    private let tableName = String(describing: GLDatingLikes.self)
    private var database: Database?
    
    private override init() {
        super.init()
        initDatabase()
    }
}

extension GLDatingLikesManager {
    /// 初始化数据库
    private func initDatabase() {
        guard let basePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last else { return }
        let directory = "GLDatingMyFavoritesDatabase"
        let path = URL(fileURLWithPath: "\(basePath)/\(directory)").appendingPathComponent(tableName).path
        #if DEBUG
        print("用户喜欢数据库路径:\(path)")
        #endif
        let database = Database(withPath: path)
        database.close()
        do {
            try database.create(table: tableName, of: GLDatingLikes.self)
            #if DEBUG
            print("[创建数据用户喜欢数据库成功]")
            #endif
        } catch {
            #if DEBUG
            print("[创建数据用户喜欢数据库失败] \(error)")
            #endif
        }
        self.database = database
    }
}

extension GLDatingLikesManager {
    /// 添加喜欢
    public func addLikes(ownerID: String?, userID: String?, avatar: String?, name: String?) throws {
        guard let ownerID = ownerID else {
            throw GLDatingError.error("ownerID is nil")
        }
        guard let database = self.database else {
            throw GLDatingError.error("database is nil")
        }
        guard let userID = userID else {
            throw GLDatingError.error("userID is nil")
        }
        
        // 先查询
        let results:[GLDatingLikes] = (try? database.getObjects(on: GLDatingLikes.Properties.all,
                                                                fromTable: self.tableName,
                                                                where: GLDatingLikes.Properties.ownerID == ownerID && GLDatingLikes.Properties.userID == userID)) ?? []
        if results.count > 0 {
            throw GLDatingError.error("You already like this user")
        }
        
        let likes = GLDatingLikes()
        likes.ownerID = ownerID
        likes.userID = userID
        likes.avatar = avatar
        likes.name = name
        
        // 插入数据库
        try? database.insert(objects: likes, intoTable: self.tableName)
    }
    
    /// 移除喜欢
    public func deleteLikes(ownerID: String?, userID: String?) throws {
        guard let ownerID = ownerID else {
            throw GLDatingError.error("ownerID is nil")
        }
        guard let database = self.database else {
            throw GLDatingError.error("database is nil")
        }
        guard let userID = userID else {
            throw GLDatingError.error("userID is nil")
        }
        
        // 先查询
        let results:[GLDatingLikes] = (try? database.getObjects(on: GLDatingLikes.Properties.all,
                                                                fromTable: self.tableName,
                                                                where: GLDatingLikes.Properties.ownerID == ownerID && GLDatingLikes.Properties.userID == userID)) ?? []
        if results.count <= 0 {
            throw GLDatingError.error("You have not liked this user")
        }
        try? database.delete(fromTable: self.tableName, where: GLDatingLikes.Properties.userID == userID && GLDatingLikes.Properties.ownerID == ownerID)
    }
    
    /// 查询是否喜欢了某个人
    public func queryIsLikes(ownerID: String?, userID: String?) throws -> Bool {
        guard let ownerID = ownerID else {
            throw GLDatingError.error("ownerID is nil")
        }
        guard let database = self.database else {
            throw GLDatingError.error("database is nil")
        }
        guard let userID = userID else {
            throw GLDatingError.error("userID is nil")
        }
        // 查询
        let results:[GLDatingLikes] = (try? database.getObjects(on: GLDatingLikes.Properties.all,
                                                                fromTable: tableName,
                                                                where: GLDatingLikes.Properties.ownerID == ownerID && GLDatingLikes.Properties.userID == userID)) ?? []
        return results.count > 0
    }
    
    /// 获取所有喜欢
    public func queryAllLikes(ownerID: String?) throws -> [GLDatingLikes] {
        guard let ownerID = ownerID else {
            throw GLDatingError.error("ownerID is nil")
        }
        guard let database = self.database else {
            throw GLDatingError.error("database is nil")
        }
        
        // 查询
        let results:[GLDatingLikes] = (try? database.getObjects(on: GLDatingLikes.Properties.all,
                                                                fromTable: tableName,
                                                                where: GLDatingLikes.Properties.ownerID == ownerID)) ?? []
        return results
    }
    
    /// 删除所有喜欢
    public func deleteAllLikes(ownerID: String?) throws {
        guard let ownerID = ownerID else {
            throw GLDatingError.error("ownerID is nil")
        }
        guard let database = self.database else {
            throw GLDatingError.error("database is nil")
        }
        try? database.delete(fromTable: self.tableName, where: GLDatingLikes.Properties.ownerID == ownerID)
    }
}
