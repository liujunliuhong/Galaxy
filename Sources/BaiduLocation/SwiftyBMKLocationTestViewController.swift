//
//  SwiftyBMKLocationTestViewController.swift
//  SwiftTool
//
//  Created by apple on 2020/6/2.
//  Copyright © 2020 yinhe. All rights reserved.
//

import UIKit

public class SwiftyBMKLocationTestViewController: UIViewController {

    deinit {
        print("\(self.classForCoder) deinit")
    }
    
    private let bmk_key: String
    public init(bmk_key: String) {
        self.bmk_key = bmk_key
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var registerButton: UIButton = {
        let registerButton = UIButton(type: .system)
        registerButton.setTitle("BMK Register", for: .normal)
        registerButton.setTitleColor(.white, for: .normal)
        registerButton.backgroundColor = .gray
        registerButton.addTarget(self, action: #selector(registerAction), for: .touchUpInside)
        return registerButton
    }()
    
    private lazy var singleLocationButton: UIButton = {
        let singleLocationButton = UIButton(type: .system)
        singleLocationButton.setTitle("BMK Single Location", for: .normal)
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
    

    
    @objc func registerAction() {
        /*
         BMKLocationAuthErrorUnknown
         BMKLocationAuthErrorSuccess
         BMKLocationAuthErrorNetworkFailed
         BMKLocationAuthErrorFailed
         */
        SwiftyBMKLocation.register(withTarget: self, key: self.bmk_key) { (code) in
            switch code {
            case .unknown:
                self.showAlert(message: "BMKLocationAuthErrorUnknown")
            case .success:
                self.showAlert(message: "BMKLocationAuthErrorSuccess")
            case .networkFailed:
                self.showAlert(message: "BMKLocationAuthErrorNetworkFailed")
            case .failed:
                self.showAlert(message: "BMKLocationAuthErrorFailed")
            @unknown default:
                break
            }
        }
    }
    
    
    @objc func singleLocationAction() {
        SwiftyBMKLocation.singleLocation(configuration: { (locationManager) in
            locationManager.coordinateType = .WGS84
        }) { [weak self] (location, error) in
            guard let self = self else { return }
            if let error = error {
                self.showAlert(message: "\(error.localizedDescription)")
            } else if let location = location {
                var dic: [String: Any] = [:]
                dic["location.latitude"] = location.location?.coordinate.latitude ?? 0
                dic["location.longitude"] = location.location?.coordinate.longitude ?? 0
                dic["location.provider"] = location.provider == .IOS ? "BMKLocationProviderIOS" : "BMKLocationProviderOther"
                dic["location.locationID"] = location.locationID ?? ""
                dic["location.floorString"] = location.floorString ?? ""
                dic["location.buildingID"] = location.buildingID ?? ""
                dic["location.buildingName"] = location.buildingName ?? ""
                dic["location.extraInfo"] = location.extraInfo ?? [:]
                dic["location.rgcData.country"] = location.rgcData?.country ?? ""
                dic["location.rgcData.countryCode"] = location.rgcData?.countryCode ?? ""
                dic["location.rgcData.province"] = location.rgcData?.province ?? ""
                dic["location.rgcData.city"] = location.rgcData?.city ?? ""
                dic["location.rgcData.district"] = location.rgcData?.district ?? ""
                dic["location.rgcData.town"] = location.rgcData?.town ?? ""
                dic["location.rgcData.street"] = location.rgcData?.street ?? ""
                dic["location.rgcData.streetNumber"] = location.rgcData?.streetNumber ?? ""
                dic["location.rgcData.cityCode"] = location.rgcData?.cityCode ?? ""
                dic["location.rgcData.adCode"] = location.rgcData?.adCode ?? ""
                dic["location.rgcData.locationDescribe"] = location.rgcData?.locationDescribe ?? ""
                var poiList: [Any] = []
                for poi in (location.rgcData?.poiList ?? []) {
                    var poiDic: [String: Any] = [:]
                    poiDic["poi.uid"] = poi.uid ?? ""
                    poiDic["poi.name"] = poi.name ?? ""
                    poiDic["poi.tags"] = poi.tags ?? ""
                    poiDic["poi.addr"] = poi.addr ?? ""
                    poiDic["poi.relaiability"] = poi.relaiability
                    poiList.append(poiDic)
                }
                dic["location.rgcData.poiList"] = poiList
                
                let vc = SwiftyBMKLocationTestInfoViewController()
                vc.textView.text = self.formatString(value: dic)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

extension SwiftyBMKLocationTestViewController {
    func formatString<T>(value: T) -> String? {
        guard let data = (NSString(format: "%@", value as! CVarArg) as String).data(using: .utf8) else { return nil }
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



fileprivate class SwiftyBMKLocationTestInfoViewController: UIViewController {
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
