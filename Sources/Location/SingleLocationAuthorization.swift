//
//  SingleLocationAuthorization.swift
//  SwiftTool
//
//  Created by liujun on 2021/5/24.
//  Copyright © 2021 yinhe. All rights reserved.
//

import Foundation
import CoreLocation

/// 单次定位授权
public final class SingleLocationAuthorization: NSObject {
    /// 单例
    public static let `default` = SingleLocationAuthorization()
    
    private var locationManager: CLLocationManager?
    private var completion: ((Bool) -> Void)?
    
    private override init() {
        super.init()
    }
}

extension SingleLocationAuthorization {
    
    /// 请求定位授权状态（使用中）
    /// - Parameter completion: 授权状态回调
    public func requestAuthorizationStatusWhenInUse(completion: ((Bool) -> Void)? = nil) {
        if !CLLocationManager.locationServicesEnabled() {
            completion?(false)
            return
        }
        let status = CLLocationManager.authorizationStatus()
        if status == .notDetermined {
            self.completion = nil
            self.locationManager = nil
            self.completion = completion
            self.locationManager = CLLocationManager()
            self.locationManager?.delegate = self
            self.locationManager?.requestWhenInUseAuthorization()
        } else if status == .denied || status == .restricted {
            completion?(false)
            self.locationManager = nil
            self.completion = nil
        } else {
            completion?(true)
            self.locationManager = nil
            self.completion = nil
        }
    }
}

extension SingleLocationAuthorization: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .notDetermined {
            return
        }
        if status == .denied || status == .restricted {
            self.completion?(false)
            self.locationManager = nil
            self.completion = nil
        } else {
            self.completion?(true)
            self.locationManager = nil
            self.completion = nil
        }
    }
}
