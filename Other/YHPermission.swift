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



// Types of request permissions.
enum YHPermissionType {
    case camera
    case microphone
    case photo
    case contacts
    case reminder
    case calendar
}

// Current authorization status.
enum YHPermissionStatus {
    case notDetermined
    case restricted
    case denied
    case authorized
}

// The result of requesting authorization.
enum YHPermissionResult {
    case denied
    case authorized
    case restricted
}

extension YHPermissionResult: CustomDebugStringConvertible, CustomStringConvertible {
    var debugDescription: String {
        switch self {
        case .denied:
            return "授权被拒绝"
        case .authorized:
            return "同意授权"
        case .restricted:
            return "权限访问受限制"
        }
    }
    
    var description: String {
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

// Callback of request authorization result.
typealias YHPermissionHanlder = (YHPermissionResult) -> ()


// Protocol.
protocol YHPermissionProtocol {
    var status: YHPermissionStatus { get }
    func requestAuthorization(hanlder: @escaping YHPermissionHanlder)
}



/*
  👉👉👉👉👉Please add these keys in info. plist.👈👈👈👈👈
 
 <key>NSRemindersUsageDescription</key>
 <string>将要访问Reminder</string>
 <key>NSCalendarsUsageDescription</key>
 <string>将要访问Calendar</string>
 <key>NSMicrophoneUsageDescription</key>
 <string>将要访问麦克风</string>
 <key>NSContactsUsageDescription</key>
 <string>将要访问通讯录</string>
 <key>NSPhotoLibraryUsageDescription</key>
 <string>将要访问相册</string>
 <key>NSPhotoLibraryAddUsageDescription</key>
 <string>将要访问相册</string>
 <key>NSCameraUsageDescription</key>
 <string>将要访问相机</string>
 
 */


struct YHPermission {
    
    static func isAuthorized(for type: YHPermissionType) -> Bool {
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
    
    static func requestAuthorization(for type: YHPermissionType, handler: @escaping YHPermissionHanlder) {
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

extension YHPermission {
    static func isAuthorized(for type: YHPermissionProtocol) -> Bool {
        return type.status == .authorized
    }
    static func requestAuthorization(for type: YHPermissionProtocol, handler: @escaping YHPermissionHanlder) {
        type.requestAuthorization(hanlder: handler)
    }
}


struct YHMicrophonePermission: YHPermissionProtocol {
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
    
    func requestAuthorization(hanlder: @escaping YHPermissionHanlder) {
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



struct YHCameraPermission: YHPermissionProtocol {
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
    
    
    func requestAuthorization(hanlder: @escaping YHPermissionHanlder) {
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

struct YHPhotoPermission: YHPermissionProtocol {
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
    
    func requestAuthorization(hanlder: @escaping YHPermissionHanlder) {
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


struct YHContactsPermission: YHPermissionProtocol {
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
    
    func requestAuthorization(hanlder: @escaping YHPermissionHanlder) {
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

struct YHReminderPerssion: YHPermissionProtocol {
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
    
    func requestAuthorization(hanlder: @escaping YHPermissionHanlder) {
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

struct YHCalendarPerssion: YHPermissionProtocol {
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
    
    func requestAuthorization(hanlder: @escaping YHPermissionHanlder) {
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
