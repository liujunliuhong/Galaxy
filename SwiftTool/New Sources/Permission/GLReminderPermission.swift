//
//  GLReminderPermission.swift
//  SwiftTool
//
//  Created by galaxy on 2020/10/19.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import EventKit


public struct GLReminderPermission {}

extension GLReminderPermission: GLPermissionProtocol {
    public typealias Status = EKAuthorizationStatus
    
    public static var authorizationStatus: EKAuthorizationStatus {
        return EKEventStore.authorizationStatus(for: .reminder)
    }
    
    public static func requestAuthorization(hanlder: @escaping (EKAuthorizationStatus) -> ()) {
        switch self.authorizationStatus {
            case .authorized:
                DispatchQueue.main.async {
                    hanlder(.authorized)
                }
            case .denied:
                DispatchQueue.main.async {
                    hanlder(.denied)
                }
            case .restricted:
                DispatchQueue.main.async {
                    hanlder(.restricted)
                }
            case .notDetermined:
                EKEventStore().requestAccess(to: .reminder) { (granted, _) in
                    DispatchQueue.main.async {
                        hanlder(granted ? .authorized : .denied)
                    }
                }
            @unknown default:
                DispatchQueue.main.async {
                    hanlder(.denied)
                }
        }
    }
}
