//
//  SwiftyPermission.swift
//  SwiftTool
//
//  Created by 刘军 on 2020/5/13.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import AVFoundation
import Photos
import Contacts
import AddressBook
import EventKit


// Protocol.
fileprivate protocol SwiftyPermissionProtocol {
    var status: SwiftyPermissionStatus { get }
    func requestAuthorization(hanlder: @escaping SwiftyPermissionHandler)
}

// Types of request permissions.
public enum SwiftyPermissionType {
    case camera
    case microphone
    case photo
    case contacts
    case reminder
    case calendar
}

// Current authorization status.
public enum SwiftyPermissionStatus {
    case notDetermined
    case restricted
    case denied
    case authorized
}

// The result of requesting authorization.
public enum SwiftyPermissionResult {
    case denied
    case authorized
    case restricted
}



// Callback of request authorization result.
public typealias SwiftyPermissionHandler = (SwiftyPermissionResult) -> ()



/*
 👉👉👉👉👉Please add these keys in `info.plist`.👈👈👈👈👈
 
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
public struct SwiftyPermission {
    
    /// is authorized
    /// - Parameter type: type
    public static func isAuthorized(for type: SwiftyPermissionType) -> Bool {
        switch type {
        case .microphone:
            return SwiftyPermission.isAuthorized(for: YHMicrophonePermission())
        case .camera:
            return SwiftyPermission.isAuthorized(for: YHCameraPermission())
        case .photo:
            return SwiftyPermission.isAuthorized(for: YHPhotoPermission())
        case .contacts:
            return SwiftyPermission.isAuthorized(for: YHContactsPermission())
        case .reminder:
            return SwiftyPermission.isAuthorized(for: YHReminderPerssion())
        case .calendar:
            return SwiftyPermission.isAuthorized(for: YHCalendarPerssion())
        }
    }
    
    /// request authorization
    /// - Parameters:
    ///   - type: type
    ///   - handler: handler
    public static func requestAuthorization(for type: SwiftyPermissionType, handler: @escaping SwiftyPermissionHandler) {
        switch type {
        case .microphone:
            SwiftyPermission.requestAuthorization(for: YHMicrophonePermission(), handler: handler)
        case .camera:
            SwiftyPermission.requestAuthorization(for: YHCameraPermission(), handler: handler)
        case .photo:
            SwiftyPermission.requestAuthorization(for: YHPhotoPermission(), handler: handler)
        case .contacts:
            SwiftyPermission.requestAuthorization(for: YHContactsPermission(), handler: handler)
        case .reminder:
            SwiftyPermission.requestAuthorization(for: YHReminderPerssion(), handler: handler)
        case .calendar:
            SwiftyPermission.requestAuthorization(for: YHCalendarPerssion(), handler: handler)
        }
    }
}




fileprivate extension SwiftyPermission {
    static func isAuthorized(for type: SwiftyPermissionProtocol) -> Bool {
        return type.status == .authorized
    }
    
    static func requestAuthorization(for type: SwiftyPermissionProtocol, handler: @escaping SwiftyPermissionHandler) {
        type.requestAuthorization(hanlder: handler)
    }
}


// MARK: - Microphone
fileprivate struct YHMicrophonePermission: SwiftyPermissionProtocol {
    var status: SwiftyPermissionStatus {
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
    
    func requestAuthorization(hanlder: @escaping SwiftyPermissionHandler) {
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
fileprivate struct YHCameraPermission: SwiftyPermissionProtocol {
    var status: SwiftyPermissionStatus {
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
    
    
    func requestAuthorization(hanlder: @escaping SwiftyPermissionHandler) {
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
fileprivate struct YHPhotoPermission: SwiftyPermissionProtocol {
    var status: SwiftyPermissionStatus {
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
    
    func requestAuthorization(hanlder: @escaping SwiftyPermissionHandler) {
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
fileprivate struct YHContactsPermission: SwiftyPermissionProtocol {
    var status: SwiftyPermissionStatus {
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
    
    func requestAuthorization(hanlder: @escaping SwiftyPermissionHandler) {
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
fileprivate struct YHReminderPerssion: SwiftyPermissionProtocol {
    var status: SwiftyPermissionStatus {
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
    
    func requestAuthorization(hanlder: @escaping SwiftyPermissionHandler) {
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
fileprivate struct YHCalendarPerssion: SwiftyPermissionProtocol {
    var status: SwiftyPermissionStatus {
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
    
    func requestAuthorization(hanlder: @escaping SwiftyPermissionHandler) {
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




extension SwiftyPermissionResult: CustomDebugStringConvertible, CustomStringConvertible {
    public var debugDescription: String {
        switch self {
        case .denied:
            return "Authorization denied."
        case .authorized:
            return "Agree to authorize."
        case .restricted:
            return "Limited access."
        }
    }
    
    public var description: String {
        switch self {
        case .denied:
            return "Authorization denied."
        case .authorized:
            return "Agree to authorize."
        case .restricted:
            return "Limited access."
        }
    }
}
