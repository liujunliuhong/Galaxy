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


public enum GLDatingDatabaseMockUserType: String, Codable {
    /// 我最喜欢的
    case me_favorites
    /// 最喜欢我的
    case favorites_me
    /// 我喜欢的
    case me_like
    /// 喜欢我的
    case like_me
    /// 我关注的
    case me_attention
    /// 关注我的
    case attention_me
    /// 我浏览过的
    case me_visited
    /// 浏览过我的
    case visited_me
    /// 我收藏的
    case me_collection
    /// 我`Wike`的
    case me_wike
}

extension GLDatingDatabaseMockUserType: DatabaseValueConvertible {}


public class GLDatingDatabaseMockUser: Codable {
    public var ID: String = UUID().uuidString
    /// 用户ID
    public var user_id: String?
    /// 拥有者ID
    public var owner_id: String?
    /// 头像
    public var avatar: String?
    /// 昵称
    public var name: String?
    /// 类型
    public var type: GLDatingDatabaseMockUserType = .me_favorites
    /// 额外信息
    public var ext: String?
    /// 创建时间
    public var time_stmp: Int = Int(Date().timeIntervalSince1970)
    
    public init() {}
    
    public enum CodingKeys: String, CodingKey, ColumnExpression {
        case ID
        case user_id
        case owner_id
        case avatar
        case name
        case type
        case ext
        case time_stmp
    }
}

extension GLDatingDatabaseMockUser: MutablePersistableRecord, FetchableRecord, TableRecord, PersistableRecord {
    public static var databaseTableName: String {
        return GLDatingDatabaseMockUserTableName
    }
}

