//
//  GLDatingMessage.swift
//  SwiftTool
//
//  Created by Yule on 2020/12/11.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import GRDB

/// 表名
internal let GLDatingMessageTableName = "Message"

public class GLDatingMessageUserInfo: Codable {
    public var sender_id: String?
    public var sender_avatar: String?
    public var sender_name: String?
    public var receiver_id: String?
    public var receiver_name: String?
    public var receiver_avatar: String?
}


public class GLDatingMessage: Codable {
    /// 消息ID
    public var message_id: String = UUID().uuidString
    /// 会话ID(其实就是虚拟用户ID)
    public var conversation_id: String = ""
    /// 消息的拥有者ID,该条消息属于谁拥有。用于切换用户登录的时候
    public var owner_id: String = ""
    /// 消息类型
    public var message_type: GLDatingMessageType = .text
    /// 消息内容(可能是图片，也可能是文字，要根据`message_type`来区分)
    public var content: String = ""
    /// 发送消息时的时间戳
    public var time_stmp: Int = Int(Date().timeIntervalSince1970)
    /// 是否是发送者
    public var is_sender: Bool = false
    /// 是否已读
    public var is_read: Bool = false
    ///
    public var user_info: GLDatingMessageUserInfo?
    
    
    
    
    public enum CodingKeys: String, CodingKey, ColumnExpression {
        case message_id
        case conversation_id
        case owner_id
        case message_type
        case content
        case time_stmp
        case is_sender
        case is_read
        case user_info
    }
}

extension GLDatingMessage: MutablePersistableRecord, FetchableRecord, TableRecord, PersistableRecord {
    public static var databaseTableName: String {
        return GLDatingMessageTableName
    }
}

