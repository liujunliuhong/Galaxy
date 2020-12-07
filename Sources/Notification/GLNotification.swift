//
//  GLNotification.swift
//  SwiftTool
//
//  Created by Yule on 2020/12/7.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import UIKit

public struct GLNotification {
    public static let `default` = GLNotification()
    private init() {}
}

extension GLNotification {
    /// 注册推送（本地推送和远程推送）
    public func registerNotification(completion: (() -> Void)? = nil) {
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
    
    public func clearBadgeNumber() {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
}
