//
//  GLDatingRobotMessage.swift
//  SwiftTool
//
//  Created by Yule on 2020/12/7.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import UIKit

public struct GLDatingRobotMessage {
    public static let `default` = GLDatingRobotMessage()
    private init() {}
    
    public let messages: [String] = [
        " hi my dear husband👄 i have three girls please call me👌we will make your good doll🔥come here baby👻",
        "hey, handsome man? call me",
        "Hey, there? i like your photo, may be you will like me too. Call me dear.",
        "Where do you come from? I thought i met you before",
        "Emmmm, see you again. where do you come from?",
        "Hey, i just met you and i like you. so call me baby",
        "Handsome man, are you there?",
        "Maybe let's see each other? call me",
        "Where you think you're goin', dear?why not call me and let's talk.",
        "Hey, i just met you and i like you. so call me baby",
        "Can i see your face in video chatting? i wanna talk with you",
        "still there?Answer my call, you will get surprise.",
        "Wanna get surprise? Answer my call,bb",
        "I don't want to see others, but only you. Call me now!",
        "Hey i'm so charming, i know you want to know me.",
        "Emmmm, see you again. where do you come from?",
        "call me bb i'll make u happy",
        "i am not happy, would you like to know why?",
        "Words cannot express my thoughts on you, call me dear!!",
        "hello dear, how are you? I'm very happly, call me dear.",
        "helo there. it's a pleasure to meet you",
        "Hi, baby how are you?",
        "I am missing someone……but I don't know who.……Is that you?"
    ]
    
    public var randomMessage: String {
        let index: Int = Int(arc4random() % UInt32(self.messages.count))
        return self.messages[index]
    }
}

extension GLDatingRobotMessage {
    
}
