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

fileprivate func myPrint(_ items: Any...) {
    #if DEBUG
    print(items)
    #endif
}


/// Native positioning package
public class YHNativeLocation: NSObject {
    private var target: AnyObject?
    private var locationManager: CLLocationManager?
    
    public typealias requestAuthorizationStatusWhenInUseClosure = ((Bool, YHNativeLocationError?)->())
    public typealias singleLocationClosure = (([CLPlacemark], YHNativeLocationError?)->())
    
    private struct AssociatedKeys {
        static var requestAuthorizationStatusWhenInUseLocationKey = "com.yinhe.yhlocation.requestAuthorizationStatusWhenInUseLocationKey"
        static var requestAuthorizationStatusWhenInUseClosureKey = "com.yinhe.yhlocation.requestAuthorizationStatusWhenInUseClosureKey"
        
        static var singleLocationKey = "com.yinhe.yhlocation.singleLocationKey"
        static var singleLocationClosureKey = "com.yinhe.yhlocation.singleLocationClosureKey"
    }
    
    private override init() {
        super.init()
    }
}


public extension YHNativeLocation {
    
    /// current location authorization status
    /// - Returns: CLAuthorizationStatus
    static func currentLocationAuthorizationStatus() -> CLAuthorizationStatus {
        return CLLocationManager.authorizationStatus()
    }
    
    /// Use native methods to get location permissions(when in use)
    /// - Parameters:
    ///   - target: target
    ///   - closure: closure
    static func requestAuthorizationStatusWhenInUse(target: AnyObject, closure: requestAuthorizationStatusWhenInUseClosure?) {
        if !CLLocationManager.locationServicesEnabled() {
            myPrint("location services not enabled")
            let error = YHNativeLocationError.message("location services not enabled")
            closure?(false, error)
            return
        }
        myPrint("location services enabled")
        let currentLocationState: CLAuthorizationStatus = CLLocationManager.authorizationStatus()
        switch currentLocationState {
        case .notDetermined:
            myPrint("location not determined")
            let location = YHNativeLocation()
            location.target = target
            location.locationManager = CLLocationManager()
            location.locationManager?.delegate = location
            location.locationManager?.requestWhenInUseAuthorization()
            objc_setAssociatedObject(target, &YHNativeLocation.AssociatedKeys.requestAuthorizationStatusWhenInUseLocationKey, location, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            objc_setAssociatedObject(location, &YHNativeLocation.AssociatedKeys.requestAuthorizationStatusWhenInUseClosureKey, closure, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        case .restricted:
            myPrint("location restricted")
            let error = YHNativeLocationError.message("location restricted")
            closure?(false, error)
        case .denied:
            myPrint("location denied")
            let error = YHNativeLocationError.message("location denied")
            closure?(false, error)
        default:
            myPrint("location ok")
            closure?(true, nil)
        }
    }
    
    static func singleLocation(target: AnyObject, closure: singleLocationClosure?) {
        let location = YHNativeLocation()
        location.target = target
        location.locationManager = CLLocationManager()
        location.locationManager?.delegate = location
        location.locationManager?.startUpdatingLocation()
        objc_setAssociatedObject(target, &YHNativeLocation.AssociatedKeys.singleLocationKey, location, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        objc_setAssociatedObject(location, &YHNativeLocation.AssociatedKeys.singleLocationClosureKey, closure, .OBJC_ASSOCIATION_COPY_NONATOMIC)
    }
}


extension YHNativeLocation: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if let closure = objc_getAssociatedObject(self, &YHNativeLocation.AssociatedKeys.requestAuthorizationStatusWhenInUseClosureKey) as? requestAuthorizationStatusWhenInUseClosure {
            switch status {
            case .notDetermined:
                myPrint("[CLLocationManagerDelegate] location not determined")
                return
            case .restricted:
                myPrint("[CLLocationManagerDelegate] location restricted")
                let error = YHNativeLocationError.message("location restricted")
                closure(false, error)
                if let target = self.target {
                    objc_setAssociatedObject(target, &YHNativeLocation.AssociatedKeys.requestAuthorizationStatusWhenInUseLocationKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                }
                objc_setAssociatedObject(self, &YHNativeLocation.AssociatedKeys.requestAuthorizationStatusWhenInUseClosureKey, nil, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            case .denied:
                myPrint("[CLLocationManagerDelegate] location denied")
                let error = YHNativeLocationError.message("location denied")
                closure(false, error)
                if let target = self.target {
                    objc_setAssociatedObject(target, &YHNativeLocation.AssociatedKeys.requestAuthorizationStatusWhenInUseLocationKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                }
                objc_setAssociatedObject(self, &YHNativeLocation.AssociatedKeys.requestAuthorizationStatusWhenInUseClosureKey, nil, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            default:
                myPrint("[CLLocationManagerDelegate] location ok")
                closure(true, nil)
            }
        }
        self.locationManager = nil
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        if locations.count <= 0 {
            return
        }
        let currentLocation = locations.last!
        
        let geoCoder = CLGeocoder()
        
        
        geoCoder.reverseGeocodeLocation(currentLocation) { (placemarks, error) in
            
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let closure = objc_getAssociatedObject(self, &YHNativeLocation.AssociatedKeys.singleLocationClosureKey) as? singleLocationClosure {
            closure([], YHNativeLocationError.message(error.localizedDescription))
            if let target = self.target {
                objc_setAssociatedObject(target, &YHNativeLocation.AssociatedKeys.singleLocationKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            objc_setAssociatedObject(self, &YHNativeLocation.AssociatedKeys.singleLocationClosureKey, nil, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        self.locationManager = nil
    }
}
