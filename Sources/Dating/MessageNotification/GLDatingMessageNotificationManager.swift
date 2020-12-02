//
//  GLDatingMessageNotificationManager.swift
//  SwiftTool
//
//  Created by galaxy on 2020/12/2.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import UIKit
import AudioToolbox

public class GLDatingMessageNotificationManager {
    public static let `default` = GLDatingMessageNotificationManager()
    
    /// 是否可以显示
    public var enableShowNotification: Bool = true
    
    /// 点击的通知(当点击通知的时候，会收到此通知) ["userID": "xxx"]
    public let tapMessageNotification = Notification.Name(rawValue: "GLDatingMessageNotificationTapMessageNotification")
}

extension GLDatingMessageNotificationManager {
    public func show(options: GLDatingMessageNotificationOptions,
                     from: GLAlertFromPosition,
                     to: GLAlertDestinationPostion) {
        
        if !self.enableShowNotification {
            return
        }
        
        let notification = GLDatingMessageNotification(options: options)
        notification.addTimer()
        let result = GLAlert.default.show(view: notification, from: from, to: to, dismissTo: from, duration: 0.25, enableMask: false)
        notification.autoDismissClosure = { (view) in
            GLAlert.default.dismiss()
        }
        notification.tapDismissClosure = { (view) in
            GLAlert.default.dismiss()
            if let userID = view.options.userID {
                NotificationCenter.default.post(name: GLDatingMessageNotificationManager.default.tapMessageNotification, object: nil, userInfo: ["userID": userID])
            }
        }
        
        if result {
            // 振动和声音反馈
            self.impact()
        }
    }
    
    public func dismiss() {
        GLAlert.default.dismiss()
    }
}

extension GLDatingMessageNotificationManager {
    private func impact() {
        AudioServicesPlayAlertSound(1007)
        if #available(iOS 10.0, *) {
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        }
    }
}
