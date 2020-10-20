//
//  GLPhotoPermission.swift
//  SwiftTool
//
//  Created by galaxy on 2020/10/19.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import Photos

public struct GLPhotoPermission {}

extension GLPhotoPermission: GLPermissionProtocol {
    public typealias Status = PHAuthorizationStatus
    
    public static var authorizationStatus: PHAuthorizationStatus {
        return PHPhotoLibrary.authorizationStatus()
    }
    
    public static func requestAuthorization(hanlder: @escaping (PHAuthorizationStatus) -> ()) {
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
                        case .limited:
                            DispatchQueue.main.async {
                                if #available(iOS 14, *) {
                                    hanlder(.limited)
                                }
                            }
                        default:
                            DispatchQueue.main.async {
                                hanlder(.denied)
                            }
                    }
                }
            case .limited:
                DispatchQueue.main.async {
                    if #available(iOS 14, *) {
                        hanlder(.limited)
                    }
                }
            @unknown default:
                DispatchQueue.main.async {
                    hanlder(.denied)
                }
        }
    }
}
