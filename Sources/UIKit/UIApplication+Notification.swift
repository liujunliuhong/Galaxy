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

@available(iOSApplicationExtension, unavailable, message: "This method is NS_EXTENSION_UNAVAILABLE.")
extension GL where Base: UIApplication {
    /// 注册推送（支持本地推送和远程推送）
    public func registerNotification(completion: ((_ granted: Bool) -> Void)? = nil) {
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            let options: UNAuthorizationOptions = [.badge, .alert, .sound]
            center.requestAuthorization(options: options) { (granted, error) in
                DispatchQueue.main.async {
                    completion?(granted)
                }
            }
        } else {
            let types: UIUserNotificationType = [.alert, .sound, .badge]
            let settings = UIUserNotificationSettings(types: types, categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
            DispatchQueue.main.async {
                completion?(UIApplication.shared.currentUserNotificationSettings != nil)
            }
        }
    }
    
    /// 清除角标
    public func clearBadgeNumber() {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
}
