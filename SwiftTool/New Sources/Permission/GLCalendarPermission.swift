//
//  GLCalendarPermission.swift
//  SwiftTool
//
//  Created by galaxy on 2020/10/19.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import EventKit


public struct GLCalendarPermission {
    public static func status() -> EKAuthorizationStatus {
        return GLCalendarPermission().status
    }
    
    public static func requestAuthorization(hanlder: @escaping (EKAuthorizationStatus) -> ()) {
        GLCalendarPermission().requestAuthorization(hanlder: hanlder)
    }
}

extension GLCalendarPermission: GLPermissionProtocol {
    public typealias Status = EKAuthorizationStatus
    
    public var status: EKAuthorizationStatus {
        return EKEventStore.authorizationStatus(for: .event)
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
                EKEventStore().requestAccess(to: .event) { (granted, _) in
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
