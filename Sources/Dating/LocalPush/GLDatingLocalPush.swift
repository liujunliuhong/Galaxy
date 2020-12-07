//
//  GLDatingLocalPush.swift
//  SwiftTool
//
//  Created by Yule on 2020/12/7.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import UIKit

public struct GLDatingLocalPush {
    public static let `default` = GLDatingLocalPush()
    private init() {}
}

extension GLDatingLocalPush {
    /// 添加本地推送
    public func openLocalPushForEveryDay(message: String?,
                                         dateString: String = "22:00:00",
                                         withCompletionHandler completionHandler: ((Error?) -> Void)? = nil) {
        guard let message = message else { return }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        guard let date = formatter.date(from: dateString) else { return }
        
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.removeAllPendingNotificationRequests() // remove all
            
            let content = UNMutableNotificationContent()
            content.badge = NSNumber(value: 1)
            content.title = ""
            content.subtitle = ""
            content.body = message
            content.sound = .default
            
            let dateComponents = Calendar.current.dateComponents([.hour, .minute, .second]/* 时、分、秒 */, from: date)
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let request = UNNotificationRequest(identifier: "local_push", content: content, trigger: trigger)
            
            center.add(request) { (error) in
                #if DEBUG
                if let error = error {
                    print("[Dating] 添加本地推送失败: \(error)")
                } else {
                    print("[Dating] 添加本地推送成功")
                }
                #endif
                completionHandler?(error)
            }
        } else {
            UIApplication.shared.cancelAllLocalNotifications() // remove all
            let localNotification = UILocalNotification()
            localNotification.alertBody = message
            localNotification.applicationIconBadgeNumber = 1
            localNotification.fireDate = date
            localNotification.repeatInterval = .day
            UIApplication.shared.scheduleLocalNotification(localNotification)
            #if DEBUG
            print("[Dating] 添加本地推送成功")
            #endif
            completionHandler?(nil)
        }
    }
}
