//
//  GLMicrophonePermission.swift
//  SwiftTool
//
//  Created by galaxy on 2020/10/19.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import AVFoundation

public struct GLMicrophonePermission {}

extension GLMicrophonePermission: GLPermissionProtocol {
    public typealias Status = AVAuthorizationStatus
    
    public static var authorizationStatus: AVAuthorizationStatus {
        return AVCaptureDevice.authorizationStatus(for: .audio)
    }
    
    public static func requestAuthorization(hanlder: @escaping (AVAuthorizationStatus) -> ()) {
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
                AVCaptureDevice.requestAccess(for: .audio) { (granted) in
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
