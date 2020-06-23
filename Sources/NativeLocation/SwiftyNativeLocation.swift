//
//  SwiftyNativeLocation.swift
//  SwiftTool
//
//  Created by liujun on 2020/6/1.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import CoreLocation

public enum SwiftyNativeLocationError: LocalizedError {
    case message(String)
    
    var localizedDescription: String {
        switch self {
        case .message(let message):
            return message
        }
    }
}

fileprivate func myPrint<T>(_ items: T) {
    #if DEBUG
    print(items)
    #endif
}


/// Native positioning package
public class SwiftyNativeLocation: NSObject {
    deinit {
        myPrint("\(self.classForCoder) deinit")
    }
    
    private weak var target: AnyObject?
    private var locationManager: CLLocationManager?
    
    public typealias requestAuthorizationStatusWhenInUseClosure = ((Bool, SwiftyNativeLocationError?)->())
    public typealias singleLocationClosure = (([CLPlacemark], SwiftyNativeLocationError?)->())
    
    private struct AssociatedKeys {
        static var requestAuthorizationStatusWhenInUseLocationKey = "com.yinhe.Swiftylocation.requestAuthorizationStatusWhenInUseLocationKey"
        static var requestAuthorizationStatusWhenInUseClosureKey = "com.yinhe.Swiftylocation.requestAuthorizationStatusWhenInUseClosureKey"
        
        static var singleLocationKey = "com.yinhe.Swiftylocation.singleLocationKey"
        static var singleLocationClosureKey = "com.yinhe.Swiftylocation.singleLocationClosureKey"
    }
    
    private override init() {
        super.init()
    }
}


public extension SwiftyNativeLocation {
    
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
        guard let closure = closure else { return }
        if !CLLocationManager.locationServicesEnabled() {
            myPrint("location services not enabled.")
            DispatchQueue.main.async {
                let error = SwiftyNativeLocationError.message("location services not enabled")
                closure(false, error)
            }
            return
        }
        myPrint("location services enabled.")
        let currentLocationState: CLAuthorizationStatus = SwiftyNativeLocation.currentLocationAuthorizationStatus()
        switch currentLocationState {
        case .notDetermined:
            myPrint("location not determined.")
            let location = SwiftyNativeLocation()
            location.target = target
            location.locationManager = CLLocationManager()
            location.locationManager?.delegate = location
            location.locationManager?.requestWhenInUseAuthorization()
            objc_setAssociatedObject(target, &SwiftyNativeLocation.AssociatedKeys.requestAuthorizationStatusWhenInUseLocationKey, location, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            objc_setAssociatedObject(location, &SwiftyNativeLocation.AssociatedKeys.requestAuthorizationStatusWhenInUseClosureKey, closure, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        case .restricted:
            myPrint("location restricted.")
            DispatchQueue.main.async {
                let error = SwiftyNativeLocationError.message("location restricted")
                closure(false, error)
            }
        case .denied:
            myPrint("location denied.")
            DispatchQueue.main.async {
                let error = SwiftyNativeLocationError.message("location denied")
                closure(false, error)
            }
        default:
            myPrint("request location authorization status ok.")
            DispatchQueue.main.async {
                closure(true, nil)
            }
        }
    }
    
    /// Single positioning
    /// - Parameters:
    ///   - target: target
    ///   - closure: closure
    static func singleLocation(target: AnyObject, closure: singleLocationClosure?) {
        guard let closure = closure else { return }
        if SwiftyNativeLocation.currentLocationAuthorizationStatus() == .notDetermined {
            DispatchQueue.main.async {
                closure([], SwiftyNativeLocationError.message("Please get location permission first"))
            }
            return
        }
        let location = SwiftyNativeLocation()
        location.target = target
        location.locationManager = CLLocationManager()
        location.locationManager?.delegate = location
        location.locationManager?.startUpdatingLocation()
        myPrint("start single location...")
        objc_setAssociatedObject(target, &SwiftyNativeLocation.AssociatedKeys.singleLocationKey, location, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        objc_setAssociatedObject(location, &SwiftyNativeLocation.AssociatedKeys.singleLocationClosureKey, closure, .OBJC_ASSOCIATION_COPY_NONATOMIC)
    }
}


extension SwiftyNativeLocation: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard let closure = objc_getAssociatedObject(self, &SwiftyNativeLocation.AssociatedKeys.requestAuthorizationStatusWhenInUseClosureKey) as? requestAuthorizationStatusWhenInUseClosure else { return }
        myPrint("request authorization status end.")
        switch status {
        case .notDetermined:
            myPrint("location not determined.")
            return
        case .restricted:
            myPrint("location restricted.")
            let error = SwiftyNativeLocationError.message("location restricted")
            DispatchQueue.main.async {
                closure(false, error)
            }
            self.releaseAuthorizationStatus()
        case .denied:
            myPrint("location denied.")
            let error = SwiftyNativeLocationError.message("location denied")
            DispatchQueue.main.async {
                closure(false, error)
            }
            self.releaseAuthorizationStatus()
        default:
            myPrint("request location authorization status ok.")
            DispatchQueue.main.async {
                closure(true, nil)
            }
            self.releaseAuthorizationStatus()
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let closure = objc_getAssociatedObject(self, &SwiftyNativeLocation.AssociatedKeys.singleLocationClosureKey) as? singleLocationClosure else {
            return
        }
        myPrint("single location success.")
        //
        manager.stopUpdatingLocation() // stop
        //
        if locations.count <= 0 {
            DispatchQueue.main.async {
                closure([], SwiftyNativeLocationError.message("Can't get current location"))
            }
            self.releaseLocation()
            return
        }
        let currentLocation = locations.last!
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(currentLocation) { [weak self] (placemarks, error) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if error != nil {
                    closure([], SwiftyNativeLocationError.message(error!.localizedDescription))
                    self.releaseLocation()
                } else {
                    closure(placemarks ?? [], nil)
                    self.releaseLocation()
                }
            }
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        guard let closure = objc_getAssociatedObject(self, &SwiftyNativeLocation.AssociatedKeys.singleLocationClosureKey) as? singleLocationClosure else { return }
        myPrint("single location fail: \(error)")
        DispatchQueue.main.async {
            closure([], SwiftyNativeLocationError.message(error.localizedDescription))
        }
        self.releaseLocation()
    }
}

extension SwiftyNativeLocation {
    private func releaseAuthorizationStatus() {
        if let target = self.target {
            objc_setAssociatedObject(target, &SwiftyNativeLocation.AssociatedKeys.requestAuthorizationStatusWhenInUseLocationKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        objc_setAssociatedObject(self, &SwiftyNativeLocation.AssociatedKeys.requestAuthorizationStatusWhenInUseClosureKey, nil, .OBJC_ASSOCIATION_COPY_NONATOMIC)
    }
    
    private func releaseLocation() {
        if let target = self.target {
            objc_setAssociatedObject(target, &SwiftyNativeLocation.AssociatedKeys.singleLocationKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        objc_setAssociatedObject(self, &SwiftyNativeLocation.AssociatedKeys.singleLocationClosureKey, nil, .OBJC_ASSOCIATION_COPY_NONATOMIC)
    }
}
