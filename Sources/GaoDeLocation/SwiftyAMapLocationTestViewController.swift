//
//  SwiftyAMapLocationTestViewController.swift
//  SwiftTool
//
//  Created by apple on 2020/6/3.
//  Copyright © 2020 yinhe. All rights reserved.
//

import UIKit

public class SwiftyAMapLocationTestViewController: UIViewController {
    
    deinit {
        print("\(self.classForCoder) deinit")
    }
    
    private let amap_key: String
    public init(amap_key: String) {
        self.amap_key = amap_key
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var registerButton: UIButton = {
        let registerButton = UIButton(type: .system)
        registerButton.setTitle("Amap Register", for: .normal)
        registerButton.setTitleColor(.white, for: .normal)
        registerButton.backgroundColor = .gray
        registerButton.addTarget(self, action: #selector(registerAction), for: .touchUpInside)
        return registerButton
    }()
    
    private lazy var singleLocationButton: UIButton = {
        let singleLocationButton = UIButton(type: .system)
        singleLocationButton.setTitle("Amap Single Location", for: .normal)
        singleLocationButton.setTitleColor(.white, for: .normal)
        singleLocationButton.backgroundColor = .gray
        singleLocationButton.addTarget(self, action: #selector(singleLocationAction), for: .touchUpInside)
        return singleLocationButton
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        let leftMargin: CGFloat = 20.0
        let width: CGFloat = UIScreen.main.bounds.width - leftMargin - leftMargin
        let height: CGFloat = 50.0
        
        
        self.registerButton.frame = CGRect(x: leftMargin, y: 200.0, width: width, height: height)
        self.singleLocationButton.frame = CGRect(x: leftMargin, y: self.registerButton.frame.maxY + 50.0, width: width, height: height)
        self.view.addSubview(self.registerButton)
        self.view.addSubview(self.singleLocationButton)
        
    }
}

extension SwiftyAMapLocationTestViewController {
    @objc func registerAction() {
        /*
        SwiftyAMapLocation.register(withKey: self.amap_key)
 */
    }
    
    
    @objc func singleLocationAction() {
        /*
        SwiftyAMapLocation.singleLocation(withTarget: self, configuration: { (locationManager) in
            // configuration
            guard let locationManager = locationManager as? AMapLocationManager else { return }
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        }) { [weak self] (location, regeocode, error) in
            guard let self = self else { return }
            if let error = error {
                self.showAlert(message: error.localizedDescription)
            } else {
                var dic: [String: Any] = [:]
                if let location = location {
                    dic["location.latitude"] = location.coordinate.latitude
                    dic["location.longitude"] = location.coordinate.longitude
                }
                if let regeocode = regeocode as? AMapLocationReGeocode {
                    dic["regeocode.formattedAddress"] = regeocode.formattedAddress
                    dic["regeocode.country"] = regeocode.country
                    dic["regeocode.province"] = regeocode.province
                    dic["regeocode.city"] = regeocode.city
                    dic["regeocode.district"] = regeocode.district
                    dic["regeocode.citycode"] = regeocode.citycode
                    dic["regeocode.adcode"] = regeocode.adcode
                    dic["regeocode.street"] = regeocode.street
                    dic["regeocode.number"] = regeocode.number
                    dic["regeocode.POIName"] = regeocode.poiName
                    dic["regeocode.AOIName"] = regeocode.aoiName
                }
                let vc = SwiftyAMapLocationTestInfoViewController()
                vc.textView.text = self.formatString(value: dic)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        */
    }
}
extension SwiftyAMapLocationTestViewController {
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



fileprivate class SwiftyAMapLocationTestInfoViewController: UIViewController {
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
