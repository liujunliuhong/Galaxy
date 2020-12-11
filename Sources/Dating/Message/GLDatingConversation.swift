//
//  GLDatingConversation.swift
//  SwiftTool
//
//  Created by Yule on 2020/12/11.
//  Copyright © 2020 yinhe. All rights reserved.
//

import UIKit

public class GLDatingConversation: NSObject {
    /// 会话ID
    public var conversationID: String?
    /// 头像
    public var avatar: String?
    /// 昵称
    public var nickName: String?
    /// 消息类型
    public var messageType: GLDatingMessageType = .text
    /// 最新消息
    public var latestMessage: String?
    /// 发送时间戳
    public var timeStmp: Int = 0
    /// 未读数量
    public var unReadCount: Int = 0
}

/*
 机器人自动给我消息
 机器人自动`like`我
 机器人自动`visited`我
 机器人自动`attention`我
 
 传入一组时间，然后依次收到回调
 */
