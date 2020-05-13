//
//  YHPermission.swift
//  SwiftTool
//
//  Created by 银河 on 2019/6/25.
//  Copyright © 2019 yinhe. All rights reserved.
//

import Foundation
import AVFoundation
import Photos
import Contacts
import AddressBook
import EventKit


// Protocol.
fileprivate protocol YHPermissionProtocol {
    var status: YHPermissionStatus { get }
    func requestAuthorization(hanlder: @escaping YHPermissionHandler)
}

// Types of request permissions.
public enum YHPermissionType {
    case camera
    case microphone
    case photo
    case contacts
    case reminder
    case calendar
}

// Current authorization status.
public enum YHPermissionStatus {
    case notDetermined
    case restricted
    case denied
    case authorized
}

// The result of requesting authorization.
public enum YHPermissionResult {
    case denied
    case authorized
    case restricted
}



// Callback of request authorization result.
public typealias YHPermissionHandler = (YHPermissionResult) -> ()



/*
 👉👉👉👉👉Please add these keys in info. plist.👈👈👈👈👈
 
 <key>NSRemindersUsageDescription</key>
 <string>xxxxx</string>
 <key>NSCalendarsUsageDescription</key>
 <string>xxxxx</string>
 <key>NSMicrophoneUsageDescription</key>
 <string>xxxxx</string>
 <key>NSContactsUsageDescription</key>
 <string>xxxxx</string>
 <key>NSPhotoLibraryUsageDescription</key>
 <string>xxxxx</string>
 <key>NSPhotoLibraryAddUsageDescription</key>
 <string>xxxxx</string>
 <key>NSCameraUsageDescription</key>
 <string>xxxxx</string>
 */

// MARK: - Public
public struct YHPermission {
    
    /// is authorized
    /// - Parameter type: type
    public static func isAuthorized(for type: YHPermissionType) -> Bool {
        switch type {
        case .microphone:
            return YHPermission.isAuthorized(for: YHMicrophonePermission())
        case .camera:
            return YHPermission.isAuthorized(for: YHCameraPermission())
        case .photo:
            return YHPermission.isAuthorized(for: YHPhotoPermission())
        case .contacts:
            return YHPermission.isAuthorized(for: YHContactsPermission())
        case .reminder:
            return YHPermission.isAuthorized(for: YHReminderPerssion())
        case .calendar:
            return YHPermission.isAuthorized(for: YHCalendarPerssion())
        }
    }
    
    /// request authorization
    /// - Parameters:
    ///   - type: type
    ///   - handler: handler
    public static func requestAuthorization(for type: YHPermissionType, handler: @escaping YHPermissionHandler) {
        switch type {
        case .microphone:
            YHPermission.requestAuthorization(for: YHMicrophonePermission(), handler: handler)
        case .camera:
            YHPermission.requestAuthorization(for: YHCameraPermission(), handler: handler)
        case .photo:
            YHPermission.requestAuthorization(for: YHPhotoPermission(), handler: handler)
        case .contacts:
            YHPermission.requestAuthorization(for: YHContactsPermission(), handler: handler)
        case .reminder:
            YHPermission.requestAuthorization(for: YHReminderPerssion(), handler: handler)
        case .calendar:
            YHPermission.requestAuthorization(for: YHCalendarPerssion(), handler: handler)
        }
    }
}




fileprivate extension YHPermission {
    static func isAuthorized(for type: YHPermissionProtocol) -> Bool {
        return type.status == .authorized
    }
    
    static func requestAuthorization(for type: YHPermissionProtocol, handler: @escaping YHPermissionHandler) {
        type.requestAuthorization(hanlder: handler)
    }
}


// MARK: - Microphone
fileprivate struct YHMicrophonePermission: YHPermissionProtocol {
    var status: YHPermissionStatus {
        let status = AVCaptureDevice.authorizationStatus(for: .audio)
        switch status {
        case .authorized:
            return .authorized
        case .restricted:
            return .restricted
        case .notDetermined:
            return .notDetermined
        case .denied:
            return .denied
        default:
            return .denied
        }
    }
    
    func requestAuthorization(hanlder: @escaping YHPermissionHandler) {
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
            AVCaptureDevice.requestAccess(for: .audio) { (granted) in
                DispatchQueue.main.async {
                    hanlder(granted ? .authorized : .denied)
                }
            }
        }
    }
}


// MARK: - Camera
fileprivate struct YHCameraPermission: YHPermissionProtocol {
    var status: YHPermissionStatus {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .authorized:
            return .authorized
        case .restricted:
            return .restricted
        case .notDetermined:
            return .notDetermined
        case .denied:
            return .denied
        default:
            return .denied
        }
    }
    
    
    func requestAuthorization(hanlder: @escaping YHPermissionHandler) {
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
            AVCaptureDevice.requestAccess(for: .video) { (granted) in
                DispatchQueue.main.async {
                    hanlder(granted ? .authorized : .denied)
                }
            }
        }
    }
}

// MARK: - Photo
fileprivate struct YHPhotoPermission: YHPermissionProtocol {
    var status: YHPermissionStatus {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            return .authorized
        case .notDetermined:
            return .notDetermined
        case .denied:
            return .denied
        case .restricted:
            return .restricted
        default:
            return .denied
        }
    }
    
    func requestAuthorization(hanlder: @escaping YHPermissionHandler) {
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
            PHPhotoLibrary.requestAuthorization { (status) in
                switch status {
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
                    DispatchQueue.main.async {
                        hanlder(.denied)
                    }
                default:
                    DispatchQueue.main.async {
                        hanlder(.denied)
                    }
                }
            }
        }
    }
}

// MARK: - Contacts
fileprivate struct YHContactsPermission: YHPermissionProtocol {
    var status: YHPermissionStatus {
        if #available(iOS 9.0, *) {
            let status = CNContactStore.authorizationStatus(for: .contacts)
            switch status {
            case .authorized:
                return .authorized
            case .notDetermined:
                return .notDetermined
            case .denied:
                return .denied
            case .restricted:
                return .restricted
            default:
                return .denied
            }
        } else {
            let status = ABAddressBookGetAuthorizationStatus()
            switch status {
            case .authorized:
                return .authorized
            case .notDetermined:
                return .notDetermined
            case .denied:
                return .denied
            case .restricted:
                return .restricted
            default:
                return .denied
            }
        }
    }
    
    func requestAuthorization(hanlder: @escaping YHPermissionHandler) {
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
            if #available(iOS 9.0, *) {
                CNContactStore().requestAccess(for: .contacts) { (granted, _) in
                    DispatchQueue.main.async {
                        hanlder(granted ? .authorized : .denied)
                    }
                }
            } else {
                let adressBook = ABAddressBookCreateWithOptions(nil, nil)
                ABAddressBookRequestAccessWithCompletion(adressBook as ABAddressBook?) { (granted, _) in
                    DispatchQueue.main.async {
                        hanlder(granted ? .authorized : .denied)
                    }
                }
            }
        }
    }
}

// MARK: - Reminder
fileprivate struct YHReminderPerssion: YHPermissionProtocol {
    var status: YHPermissionStatus {
        let status = EKEventStore.authorizationStatus(for: .reminder)
        switch status {
        case .authorized:
            return .authorized
        case .denied:
            return .denied
        case .restricted:
            return .restricted
        case .notDetermined:
            return .notDetermined
        default:
            return .denied
        }
    }
    
    func requestAuthorization(hanlder: @escaping YHPermissionHandler) {
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
        }
    }
}

// MARK: - Calendar
fileprivate struct YHCalendarPerssion: YHPermissionProtocol {
    var status: YHPermissionStatus {
        let status = EKEventStore.authorizationStatus(for: .event)
        switch status {
        case .authorized:
            return .authorized
        case .denied:
            return .denied
        case .restricted:
            return .restricted
        case .notDetermined:
            return .notDetermined
        default:
            return .denied
        }
    }
    
    func requestAuthorization(hanlder: @escaping YHPermissionHandler) {
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
        }
    }
}




extension YHPermissionResult: CustomDebugStringConvertible, CustomStringConvertible {
    public var debugDescription: String {
        switch self {
        case .denied:
            return "授权被拒绝"
        case .authorized:
            return "同意授权"
        case .restricted:
            return "权限访问受限制"
        }
    }
    
    public var description: String {
        switch self {
        case .denied:
            return "授权被拒绝"
        case .authorized:
            return "同意授权"
        case .restricted:
            return "权限访问受限制"
        }
    }
}
