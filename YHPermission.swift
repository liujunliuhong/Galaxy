//
//  YHPermission.swift
//  SwiftTool
//
//  Created by 银河 on 2019/6/25.
//  Copyright © 2019 yinhe. All rights reserved.
//

import Foundation
import AVFoundation


// 请求权限的类型
enum YHPermissionType {
    case camera
    case alblum
    case microphone
    
}

// 当前授权状态
enum YHPermissionStatus {
    case notDetermined
    case restricted
    case denied
    case authorized
}

// 请求授权的结果
enum YHPermissionResult {
    case denied
    case authorized
    case restricted
}

// 请求授权结果回调
typealias YHPermissionHanlder = (YHPermissionResult) -> ()


// 协议
protocol YHPermissionProtocol {
    var status: YHPermissionStatus { get }
    func requestAuthorization(hanlder: @escaping YHPermissionHanlder)
}




struct YHPermission {
    static func isAuthorized(for type: YHPermissionType) -> Bool {
        switch type {
        case .microphone:
            return YHPermission.isAuthorized(for: YHMicrophonePermission())
        case .camera:
            return YHPermission.isAuthorized(for: YHCameraPermission())
        default:
            return false
        }
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
    
    func requestAuthorization(hanlder: @escaping (YHPermissionResult) -> ()) {
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
    
    func requestAuthorization(hanlder: @escaping (YHPermissionResult) -> ()) {
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



extension YHPermission {
    static func isAuthorized(for type: YHPermissionProtocol) -> Bool {
        return type.status == .authorized
    }
}
