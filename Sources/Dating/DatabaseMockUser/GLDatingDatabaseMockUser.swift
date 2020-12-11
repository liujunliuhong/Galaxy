//
//  GLDatingDatabaseMockUser.swift
//  SwiftTool
//
//  Created by Yule on 2020/12/11.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import GRDB

/// 表名
internal let GLDatingDatabaseMockUserTableName = "DatabaseMockUser"


public enum GLDatingDatabaseMockUserType: Int, Codable {
    /// 我最喜欢的
    case my_favorites = 0
    /// 我喜欢的
    case you_like = 1
    /// 喜欢我的
    case like_you = 2
    /// 我噶关注的
    case my_attention = 3
}

extension GLDatingDatabaseMockUserType: DatabaseValueConvertible {}


public class GLDatingDatabaseMockUser: Codable {
    public var ID: String = UUID().uuidString
    /// 用户ID
    public var userID: String?
    /// 拥有者ID
    public var ownerID: String?
    /// 头像
    public var avatar: String?
    /// 昵称
    public var name: String?
    /// 类型
    public var type: GLDatingDatabaseMockUserType = .my_favorites
    /// 额外信息
    public var ext: String?
    /// 创建时间
    public var timeStmp: Int = Int(Date().timeIntervalSince1970)
    
    
    public enum CodingKeys: String, CodingKey, ColumnExpression {
        case ID
        case userID
        case ownerID
        case avatar
        case name
        case type
        case ext
        case timeStmp
    }
}

extension GLDatingDatabaseMockUser: MutablePersistableRecord, FetchableRecord, TableRecord, PersistableRecord {
    public static var databaseTableName: String {
        return GLDatingDatabaseMockUserTableName
    }
}

