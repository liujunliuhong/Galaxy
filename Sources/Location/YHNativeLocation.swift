//
//  YHNativeLocation.swift
//  FNDating
//
//  Created by apple on 2020/3/24.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import CoreLocation

public enum YHNativeLocationError: LocalizedError {
    case message(String)
    
    var localizedDescription: String {
        switch self {
        case .message(let message):
            return message
        }
    }
}


/// 苹果原生定位封装
public class YHNativeLocation: NSObject {
    private var target: AnyObject?
    private var locationManager: CLLocationManager?
    
    public typealias requestAuthorizationStatusWhenInUseClosure = ((Bool, YHNativeLocationError?)->())
    
    private struct AssociatedKeys {
        static var requestAuthorizationStatusWhenInUseLocationKey = "com.yinhe.yhlocation.requestAuthorizationStatusWhenInUseLocationKey"
        static var requestAuthorizationStatusWhenInUseclosureKey = "com.yinhe.yhlocation.requestAuthorizationStatusWhenInUseclosureKey"
    }
    
    private override init() {
        super.init()
    }
}


public extension YHNativeLocation {
    
    /// 苹果原生获取定位权限(when in use)
    /// - Parameters:
    ///   - target: target
    ///   - closure: 回调
    static func requestAuthorizationStatusWhenInUse(target: AnyObject, closure: requestAuthorizationStatusWhenInUseClosure?) {
        if !CLLocationManager.locationServicesEnabled() {
            print("location services not enabled")
            let error = YHNativeLocationError.message("location services not enabled")
            closure?(false, error)
            return
        }
        print("location services enabled")
        let currentLocationState: CLAuthorizationStatus = CLLocationManager.authorizationStatus()
        switch currentLocationState {
        case .notDetermined:
            print("location not determined")
            let location = YHNativeLocation()
            location.target = target
            location.locationManager = CLLocationManager()
            location.locationManager?.delegate = location
            location.locationManager?.requestWhenInUseAuthorization()
            objc_setAssociatedObject(target, &YHNativeLocation.AssociatedKeys.requestAuthorizationStatusWhenInUseLocationKey, location, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            objc_setAssociatedObject(location, &YHNativeLocation.AssociatedKeys.requestAuthorizationStatusWhenInUseclosureKey, closure, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        case .restricted:
            print("location restricted")
            let error = YHNativeLocationError.message("location restricted")
            closure?(false, error)
        case .denied:
            print("location denied")
            let error = YHNativeLocationError.message("location denied")
            closure?(false, error)
        default:
            print("location ok")
            closure?(true, nil)
        }
    }
}


extension YHNativeLocation: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if let closure = objc_getAssociatedObject(self, &YHNativeLocation.AssociatedKeys.requestAuthorizationStatusWhenInUseclosureKey) as? requestAuthorizationStatusWhenInUseClosure {
            switch status {
            case .notDetermined:
                print("[CLLocationManagerDelegate] location not determined")
                return
            case .restricted:
                print("[CLLocationManagerDelegate] location restricted")
                let error = YHNativeLocationError.message("location restricted")
                closure(false, error)
                if let target = self.target {
                    objc_setAssociatedObject(target, &YHNativeLocation.AssociatedKeys.requestAuthorizationStatusWhenInUseLocationKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                }
                objc_setAssociatedObject(self, &YHNativeLocation.AssociatedKeys.requestAuthorizationStatusWhenInUseclosureKey, nil, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            case .denied:
                print("[CLLocationManagerDelegate] location denied")
                let error = YHNativeLocationError.message("location denied")
                closure(false, error)
                if let target = self.target {
                    objc_setAssociatedObject(target, &YHNativeLocation.AssociatedKeys.requestAuthorizationStatusWhenInUseLocationKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                }
                objc_setAssociatedObject(self, &YHNativeLocation.AssociatedKeys.requestAuthorizationStatusWhenInUseclosureKey, nil, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            default:
                print("[CLLocationManagerDelegate] location ok")
                closure(true, nil)
            }
        }
        self.locationManager = nil
    }
}
