//
//  SwiftyBMKLocationTestViewController.swift
//  SwiftTool
//
//  Created by apple on 2020/6/2.
//  Copyright © 2020 yinhe. All rights reserved.
//

import UIKit

public class SwiftyBMKLocationTestViewController: UIViewController {

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
        registerButton.setTitle("Register", for: .normal)
        registerButton.setTitleColor(.white, for: .normal)
        registerButton.backgroundColor = .gray
        registerButton.addTarget(self, action: #selector(registerAction), for: .touchUpInside)
        return registerButton
    }()
    
    private lazy var singleLocationButton: UIButton = {
        let singleLocationButton = UIButton(type: .system)
        singleLocationButton.setTitle("Single Location", for: .normal)
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
                print("BMKLocationAuthErrorUnknown")
            case .success:
                print("BMKLocationAuthErrorSuccess")
            case .networkFailed:
                print("BMKLocationAuthErrorNetworkFailed")
            case .failed:
                print("BMKLocationAuthErrorFailed")
            @unknown default:
                break
            }
        }
    }
    
    
    @objc func singleLocationAction() {
        SwiftyBMKLocation.singleLocation(configuration: { (locationManager) in
            locationManager.coordinateType = .WGS84
        }) { (location, error) in
            if let error = error {
                print("\(error.localizedDescription)")
            } else if let location = location {
                print("========================================")
                print("latitude:\(location.location?.coordinate.latitude ?? 0)")
                print("longitude:\(location.location?.coordinate.longitude ?? 0)")
                print("provider:\(location.provider == .IOS ? "BMKLocationProviderIOS" : "BMKLocationProviderOther")")
                print("locationID:\(location.locationID ?? "")")
                print("floorString:\(location.floorString ?? "")")
                print("buildingID:\(location.buildingID ?? "")")
                print("buildingName:\(location.buildingName ?? "")")
                print("extraInfo:\(location.extraInfo ?? [:])")
                
                print("rgcData.country:\(location.rgcData?.country ?? "")")
                print("rgcData.countryCode:\(location.rgcData?.countryCode ?? "")")
                print("rgcData.province:\(location.rgcData?.province ?? "")")
                print("rgcData.city:\(location.rgcData?.city ?? "")")
                print("rgcData.district:\(location.rgcData?.district ?? "")")
                print("rgcData.town:\(location.rgcData?.town ?? "")")
                print("rgcData.street:\(location.rgcData?.street ?? "")")
                print("rgcData.streetNumber:\(location.rgcData?.streetNumber ?? "")")
                print("rgcData.cityCode:\(location.rgcData?.cityCode ?? "")")
                print("rgcData.adCode:\(location.rgcData?.adCode ?? "")")
                print("rgcData.locationDescribe:\(location.rgcData?.locationDescribe ?? "")")
                
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
                print("poiList:\(poiList as NSArray)")
                
                print("========================================")
            }
        }
    }
}
