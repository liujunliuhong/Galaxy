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
            _printPlacemarkInfo(placemark: placemark)
            self.locationManager = nil
            self.completion?(placemark, error)
            self.completion = nil
        }
    }
}


private func _printPlacemarkInfo(placemark: CLPlacemark) {
    #if DEBUG
    // 四大直辖市的城市信息无法通过CLPlacemark的locality属性获得，
    // 只能通过访问administrativeArea属性来获得（如果locality为空，则可知为直辖市）
    
    var addressDictionary: [String: Any] = [:]
    (placemark.addressDictionary ?? [:]).forEach { (value) in
        addressDictionary["\(value.key)"] = value.value
    }
    
    let message: String =
        "\n"
        + "***************************************************************"
        + "\n"
        + "name(具体位置) = \((placemark.name ?? "nil"))"
        + "\n"
        + "thoroughfare(街道) = \((placemark.thoroughfare ?? "nil"))"
        + "\n"
        + "subThoroughfare(子街道) = \((placemark.subThoroughfare ?? "nil"))"
        + "\n"
        + "locality(市) = \((placemark.locality ?? "nil"))"
        + "\n"
        + "subLocality(区) = \((placemark.subLocality ?? "nil"))"
        + "\n"
        + "administrativeArea(省或者州) = \((placemark.administrativeArea ?? "nil"))"
        + "\n"
        + "subAdministrativeArea(其他行政信息，可能是县镇乡等) = \((placemark.subAdministrativeArea ?? "nil"))"
        + "\n"
        + "postalCode(邮政编码) = \((placemark.postalCode ?? "nil"))"
        + "\n"
        + "isoCountryCode(国家代码) = \((placemark.isoCountryCode ?? "nil"))"
        + "\n"
        + "country(国家) = \((placemark.country ?? "nil"))"
        + "\n"
        + "inlandWater(水源、湖泊) = \((placemark.inlandWater ?? "nil"))"
        + "\n"
        + "ocean(海洋) = \((placemark.ocean ?? "nil"))"
        + "\n"
        + "areasOfInterest(获取关联的或利益相关的地标) = \((placemark.areasOfInterest ?? []))"
        + "\n"
        + "addressDictionary = \(addressDictionary as NSDictionary)"
        + "\n"
        + "***************************************************************"
        + "\n"
    print(message)
    #endif
}
