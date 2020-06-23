//
//  SwiftyNativeLocationTestViewController.swift
//  SwiftTool
//
//  Created by liujun on 2020/6/1.
//  Copyright © 2020 yinhe. All rights reserved.
//

import UIKit

public class SwiftyNativeLocationTestViewController: UIViewController {
    
    deinit {
        print("\(NSStringFromClass(self.classForCoder)) deinit")
    }
    
    private lazy var currentAuthorizationStatusButton: UIButton = {
        let currentAuthorizationStatusButton = UIButton(type: .system)
        currentAuthorizationStatusButton.setTitle("Native Current Authorization Status", for: .normal)
        currentAuthorizationStatusButton.setTitleColor(.white, for: .normal)
        currentAuthorizationStatusButton.backgroundColor = .gray
        currentAuthorizationStatusButton.addTarget(self, action: #selector(currentAuthorizationStatusAction), for: .touchUpInside)
        return currentAuthorizationStatusButton
    }()
    
    private lazy var requestLocationAuthorizationStatusButton: UIButton = {
        let requestLocationAuthorizationStatusButton = UIButton(type: .system)
        requestLocationAuthorizationStatusButton.setTitle("Native Request Location Authorization Status", for: .normal)
        requestLocationAuthorizationStatusButton.setTitleColor(.white, for: .normal)
        requestLocationAuthorizationStatusButton.backgroundColor = .gray
        requestLocationAuthorizationStatusButton.addTarget(self, action: #selector(requestLocationAuthorizationStatusAction), for: .touchUpInside)
        return requestLocationAuthorizationStatusButton
    }()
    
    private lazy var singleLocationButton: UIButton = {
        let singleLocationButton = UIButton(type: .system)
        singleLocationButton.setTitle("Native Single Location", for: .normal)
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
            self.showAlert(message: "notDetermined")
        case .restricted:
            self.showAlert(message: "restricted")
        case .denied:
            self.showAlert(message: "denied")
        case .authorizedAlways:
            self.showAlert(message: "authorizedAlways")
        case .authorizedWhenInUse:
            self.showAlert(message: "authorizedWhenInUse")
        default:
            break
        }
    }
    
    @objc func requestLocationAuthorizationStatusAction() {
        SwiftyNativeLocation.requestAuthorizationStatusWhenInUse(target: self) { (isGranted, error) in
            if isGranted {
                self.showAlert(message: "granted")
            } else if let error = error {
                self.showAlert(message: "\(error.localizedDescription)")
            }
        }
    }
    
    @objc func singleLocationAction() {
        SwiftyNativeLocation.singleLocation(target: self) { [weak self] (placemarks, error) in
            guard let self = self else { return }
            if let error = error {
                self.showAlert(message: error.localizedDescription)
            } else {
                var info: [Any] = []
                placemarks.forEach { (p) in
                    var dic: [String: Any] = [:]
                    dic["latitude"] = p.location?.coordinate.latitude ?? 0
                    dic["longitude"] = p.location?.coordinate.longitude ?? 0
                    dic["name"] = p.name ?? ""
                    dic["thoroughfare"] = p.thoroughfare ?? ""
                    dic["subThoroughfare"] = p.subThoroughfare ?? ""
                    dic["locality"] = p.locality ?? ""
                    dic["subLocality"] = p.subLocality ?? ""
                    dic["administrativeArea"] = p.administrativeArea ?? ""
                    dic["subAdministrativeArea"] = p.subAdministrativeArea ?? ""
                    dic["postalCode"] = p.postalCode ?? ""
                    dic["isoCountryCode"] = p.isoCountryCode ?? ""
                    dic["country"] = p.country ?? ""
                    dic["inlandWater"] = p.inlandWater ?? ""
                    dic["ocean"] = p.ocean ?? ""
                    dic["areasOfInterest"] = p.areasOfInterest ?? []
                    info.append(dic)
                }
                let vc = SwiftyNativeLocationTestInfoViewController()
                vc.textView.text = self.formatString(value: info)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

extension SwiftyNativeLocationTestViewController {
    func formatString<T>(value: T) -> String? {
        guard let data = String(format: "%@", value as! CVarArg).data(using: .utf8) else { return nil }
        guard let utf8 = String(data: data, encoding: .nonLossyASCII)?.utf8 else { return nil }
        return "\(utf8)"
    }
    
    private func showAlert(message: String?) {
        let alert = UIAlertController(title: "Infomation", message: message, preferredStyle: .alert)
        let sureAction = UIAlertAction(title: "Sure", style: .default, handler: nil)
        alert.addAction(sureAction)
        self.present(alert, animated: true, completion: nil)
    }
}


fileprivate class SwiftyNativeLocationTestInfoViewController: UIViewController {
    deinit {
        print("\(self.classForCoder) deinit")
    }
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        return textView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(self.textView)
        self.textView.frame = CGRect(x: 0, y: UIApplication.shared.statusBarFrame.height + 44, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - (UIApplication.shared.statusBarFrame.height + 44))
    }
}
