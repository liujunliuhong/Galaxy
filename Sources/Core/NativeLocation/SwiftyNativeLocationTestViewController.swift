//
//  SwiftyNativeLocationTestViewController.swift
//  SwiftTool
//
//  Created by 刘军 on 2020/6/1.
//  Copyright © 2020 yinhe. All rights reserved.
//

import UIKit

public class SwiftyNativeLocationTestViewController: UIViewController {
    
    deinit {
        print("\(NSStringFromClass(self.classForCoder)) deinit")
    }
    
    private lazy var currentAuthorizationStatusButton: UIButton = {
        let currentAuthorizationStatusButton = UIButton(type: .system)
        currentAuthorizationStatusButton.setTitle("Current Authorization Status", for: .normal)
        currentAuthorizationStatusButton.setTitleColor(.white, for: .normal)
        currentAuthorizationStatusButton.backgroundColor = .gray
        currentAuthorizationStatusButton.addTarget(self, action: #selector(currentAuthorizationStatusAction), for: .touchUpInside)
        return currentAuthorizationStatusButton
    }()
    
    private lazy var requestLocationAuthorizationStatusButton: UIButton = {
        let requestLocationAuthorizationStatusButton = UIButton(type: .system)
        requestLocationAuthorizationStatusButton.setTitle("Request Location Authorization Status", for: .normal)
        requestLocationAuthorizationStatusButton.setTitleColor(.white, for: .normal)
        requestLocationAuthorizationStatusButton.backgroundColor = .gray
        requestLocationAuthorizationStatusButton.addTarget(self, action: #selector(requestLocationAuthorizationStatusAction), for: .touchUpInside)
        return requestLocationAuthorizationStatusButton
    }()
    
    private lazy var singleLocationButton: UIButton = {
        let singleLocationButton = UIButton(type: .system)
        singleLocationButton.setTitle("Single Location", for: .normal)
        singleLocationButton.setTitleColor(.white, for: .normal)
        singleLocationButton.backgroundColor = .gray
        singleLocationButton.addTarget(self, action: #selector(singleLocationAction), for: .touchUpInside)
        return singleLocationButton
    }()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        let leftMargin: CGFloat = 20.0
        let width: CGFloat = UIScreen.main.bounds.width - leftMargin - leftMargin
        let height: CGFloat = 50.0
        
        
        self.currentAuthorizationStatusButton.frame = CGRect(x: leftMargin, y: 200.0, width: width, height: height)
        self.requestLocationAuthorizationStatusButton.frame = CGRect(x: leftMargin, y: self.currentAuthorizationStatusButton.frame.maxY + 50.0, width: width, height: height)
        self.singleLocationButton.frame = CGRect(x: leftMargin, y: self.requestLocationAuthorizationStatusButton.frame.maxY + 50.0, width: width, height: height)
        self.view.addSubview(self.currentAuthorizationStatusButton)
        self.view.addSubview(self.requestLocationAuthorizationStatusButton)
        self.view.addSubview(self.singleLocationButton)
    }
}
/*
 case notDetermined = 0
 case restricted = 1
 case denied = 2
 case authorizedAlways = 3
 case authorizedWhenInUse = 4
 */
extension SwiftyNativeLocationTestViewController {
    @objc func currentAuthorizationStatusAction() {
        let status = SwiftyNativeLocation.currentLocationAuthorizationStatus()
        switch status {
        case .notDetermined:
            print("notDetermined")
        case .restricted:
            print("restricted")
        case .denied:
            print("denied")
        case .authorizedAlways:
            print("authorizedAlways")
        case .authorizedWhenInUse:
            print("authorizedWhenInUse")
        default:
            break
        }
    }
    
    @objc func requestLocationAuthorizationStatusAction() {
        SwiftyNativeLocation.requestAuthorizationStatusWhenInUse(target: self) { (isGranted, error) in
            if isGranted {
                print("granted")
            } else if let error = error {
                print("not granted")
                print("\(error.localizedDescription)")
            }
        }
    }
    
    @objc func singleLocationAction() {
        SwiftyNativeLocation.singleLocation(target: self) { (placemarks, error) in
            if let error = error {
                print("\(error.localizedDescription)")
            } else {
                placemarks.forEach { (p) in
                    print("=============================")
                    print("latitude:\(p.location?.coordinate.latitude ?? 0)")
                    print("longitude:\(p.location?.coordinate.longitude ?? 0)")
                    print("name:\(p.name ?? "")")
                    print("thoroughfare:\(p.thoroughfare ?? "")")
                    print("subThoroughfare:\(p.subThoroughfare ?? "")")
                    print("locality:\(p.locality ?? "")")
                    print("subLocality:\(p.subLocality ?? "")")
                    print("administrativeArea:\(p.administrativeArea ?? "")")
                    print("subAdministrativeArea:\(p.subAdministrativeArea ?? "")")
                    print("postalCode:\(p.postalCode ?? "")")
                    print("isoCountryCode:\(p.isoCountryCode ?? "")")
                    print("country:\(p.country ?? "")")
                    print("inlandWater:\(p.inlandWater ?? "")")
                    print("ocean:\(p.ocean ?? "")")
                    print("areasOfInterest:\(p.areasOfInterest ?? [])")
                    print("=============================")
                }
            }
        }
    }
}
