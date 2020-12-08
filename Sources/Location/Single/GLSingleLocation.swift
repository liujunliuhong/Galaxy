//
//  GLSingleLocation.swift
//  SwiftTool
//
//  Created by galaxy on 2020/12/8.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import CoreLocation

public class GLSingleLocation: NSObject {
    public static let `default` = GLSingleLocation()
    
    private var locationManager: CLLocationManager?
        
    private var completion: ((CLPlacemark?, Error?) -> Void)?
    
    private override init() {
        super.init()
    }
}

extension GLSingleLocation {
    public func startSingleLocation(completion: ((CLPlacemark?, Error?) -> Void)?) {
        if !CLLocationManager.locationServicesEnabled() {
            self.completion?(nil, GLSingleLocationError.error("location services not enabled"))
            return
        }
        self.completion = nil
        self.locationManager = nil
        self.completion = completion
        self.locationManager = CLLocationManager()
        self.locationManager?.delegate = self
        self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager?.startUpdatingLocation()
    }
}

extension GLSingleLocation: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.locationManager = nil
        self.completion?(nil, error)
        self.completion = nil
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locationManager?.stopUpdatingLocation()
        guard let location = locations.first else {
            self.locationManager = nil
            self.completion?(nil, GLSingleLocationError.error("no location"))
            self.completion = nil
            return
        }
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
            guard let self = self else { return }
            if let error = error {
                self.locationManager = nil
                self.completion?(nil, error)
                self.completion = nil
                return
            }
            guard let placemark = placemarks?.first else {
                self.locationManager = nil
                self.completion?(nil, GLSingleLocationError.error("no placemarks"))
                self.completion = nil
                return
            }
            self.locationManager = nil
            self.completion?(placemark, error)
            self.completion = nil
        }
    }
}
