//
//  SwiftyPermissionTestViewController.swift
//  SwiftTool
//
//  Created by 刘军 on 2020/5/13.
//  Copyright © 2020 yinhe. All rights reserved.
//

import UIKit

class SwiftyPermissionTestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

// MARK: - Camera
extension SwiftyPermissionTestViewController {
    func getCameraAuthorizationStatus() {
        let isAuthorized = SwiftyPermission.isAuthorized(for: .camera)
        print("camera authorized status: \(isAuthorized)")
    }
    func requestCameraAuthorization() {
        SwiftyPermission.requestAuthorization(for: .camera) { (result) in
            print("camera: \(result.debugDescription)")
        }
    }
}

// MARK: - Microphone
extension SwiftyPermissionTestViewController {
    func getMicrophoneAuthorizationStatus() {
        let isAuthorized = SwiftyPermission.isAuthorized(for: .microphone)
        print("microphone authorized status: \(isAuthorized)")
    }
    func requestMicrophoneAuthorization() {
        SwiftyPermission.requestAuthorization(for: .microphone) { (result) in
            print("microphone: \(result.debugDescription)")
        }
    }
}

// MARK: - Photo
extension SwiftyPermissionTestViewController {
    func getPhotoAuthorizationStatus() {
        let isAuthorized = SwiftyPermission.isAuthorized(for: .photo)
        print("photo authorized status: \(isAuthorized)")
    }
    func requestPhotoAuthorization() {
        SwiftyPermission.requestAuthorization(for: .photo) { (result) in
            print("photo: \(result.debugDescription)")
        }
    }
}
