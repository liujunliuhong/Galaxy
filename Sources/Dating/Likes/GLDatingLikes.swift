//
//  GLDatingLikes.swift
//  SwiftTool
//
//  Created by Yule on 2020/12/9.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import GRDB

/// 表名
internal let GLDatingLikesTableName = "Likes"

// 喜欢
public class GLDatingLikes: Codable {
    public var ID: String = UUID().uuidString
    /// 用户ID
    public var userID: String?
    /// 拥有者ID
    public var ownerID: String?
    /// 头像
    public var avatar: String?
    /// 昵称
    public var name: String?
    /// 创建时间
    public var timeStmp: Int = Int(Date().timeIntervalSince1970)
    
    
    public enum CodingKeys: String, CodingKey, ColumnExpression {
        case ID
        case userID
        case ownerID
        case avatar
        case name
        case timeStmp
    }
}

extension GLDatingLikes: MutablePersistableRecord, FetchableRecord, TableRecord, PersistableRecord {
    public static var databaseTableName: String {
        return GLDatingLikesTableName
    }
}
