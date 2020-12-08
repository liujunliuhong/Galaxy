//
//  GLSingleLocationAuthorization.swift
//  SwiftTool
//
//  Created by galaxy on 2020/12/8.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import CoreLocation

public class GLSingleLocationAuthorization: NSObject {
    public static let `default` = GLSingleLocationAuthorization()
    
    private var locationManager: CLLocationManager?
    private var completion: ((Bool) -> Void)?
    
    private override init() {
        super.init()
    }
}

extension GLSingleLocationAuthorization {
    public func requestWhenInUseAuthorizationStatus(completion: ((Bool) -> Void)? = nil) {
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

extension GLSingleLocationAuthorization: CLLocationManagerDelegate {
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
