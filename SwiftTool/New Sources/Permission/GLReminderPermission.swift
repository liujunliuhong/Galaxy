//
//  GLReminderPermission.swift
//  SwiftTool
//
//  Created by galaxy on 2020/10/19.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import EventKit


public struct GLReminderPermission {
    public static func status() -> EKAuthorizationStatus {
        return GLReminderPermission().status
    }
    
    public static func requestAuthorization(hanlder: @escaping (EKAuthorizationStatus) -> ()) {
        GLReminderPermission().requestAuthorization(hanlder: hanlder)
    }
}

extension GLReminderPermission: GLPermissionProtocol {
    public typealias Status = EKAuthorizationStatus
    
    public var status: EKAuthorizationStatus {
        return EKEventStore.authorizationStatus(for: .reminder)
    }
    
    public func requestAuthorization(hanlder: @escaping (EKAuthorizationStatus) -> ()) {
        switch self.status {
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
