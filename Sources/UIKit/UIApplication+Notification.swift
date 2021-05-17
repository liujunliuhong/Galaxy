//
//  UIApplication+Notification.swift
//  SwiftTool
//
//  Created by liujun on 2021/5/17.
//  Copyright © 2021 yinhe. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

extension UIApplication {
    /// 注册推送（支持本地推送和远程推送）
    public func gl_registerNotification(completion: (() -> Void)? = nil) {
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            let options: UNAuthorizationOptions = [.badge, .alert, .sound]
            center.requestAuthorization(options: options) { (granted, error) in
                DispatchQueue.main.async {
                    completion?()
                }
            }
        } else {
            let types: UIUserNotificationType = [.alert, .sound, .badge]
            let settings = UIUserNotificationSettings(types: types, categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
            DispatchQueue.main.async {
                completion?()
            }
        }
    }
    
    /// 清除角标
    public func gl_clearBadgeNumber() {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
}
