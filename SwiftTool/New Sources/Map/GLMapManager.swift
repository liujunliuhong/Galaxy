//
//  GLMapManager.swift
//  SwiftTool
//
//  Created by galaxy on 2020/10/21.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import MapKit

/*
 Info.plist
 <key>LSApplicationQueriesSchemes</key>
 <array>
 <string>iosamap</string>
 <string>baidumap</string>
 </array>
 
 http://lbsyun.baidu.com/index.php?title=uri/api/ios
 https://lbs.amap.com/api/amap-mobile/guide/ios/route
 */


public enum GLMapCoordinateType: String {
    case bd09ll = "bd09ll"
    case bd09mc = "bd09mc"
    case gcj02 = "gcj02"
    case wgs84 = "wgs84"
}

public enum GLBaiDuNavigationType: String {
    case transit = "transit"
    case driving = "driving"
    case navigation = "navigation"
    case walking = "walking"
    case riding = "riding"
}

public enum GLGaoDeNavigationType: Int {
    case driving = 0
    case transit = 1
    case walking = 2
    case riding = 3
}

public enum GLMapNavigationType {
    case baidu(coordinateType: GLMapCoordinateType, navigationType: GLBaiDuNavigationType)
    case gaode(navigationType: GLGaoDeNavigationType)
    case `self`(directionsMode: String, mapType: MKMapType, showsTrafficKey: Bool)
}

public class GLMapManager {
    public static let `default` = GLMapManager()
}

extension GLMapManager {
    public func canOpenBaiDu() -> Bool {
        guard let url = URL(string: "baidumap://") else { return false }
        return UIApplication.shared.canOpenURL(url)
    }

    public func canOpenGaoDe() -> Bool {
        guard let url = URL(string: "iosamap://") else { return false }
        return UIApplication.shared.canOpenURL(url)
    }
    
    public func open(type: GLMapNavigationType, destination: CLLocationCoordinate2D?, destinationName: String?) {
        guard let destination = destination else { return }
        switch type {
        case .baidu(let coordinateType, let navigationType):
            guard let bundleID = Bundle.gl_appBundleID() else { return }
            var d: String = ""
            if let destinationName = destinationName, destinationName.count > 0 {
                d = "&destination=latlng:\(destination.latitude),\(destination.longitude)|name=\(destinationName)"
            } else {
                d = "&destination=\(destination.latitude),\(destination.longitude)"
            }
            var url = "baidumap://map/direction" + "?origin={{我的位置}}" + d + "&coord_type=\(coordinateType.rawValue)" + "&mode=\(navigationType.rawValue)" + "&src=\(bundleID)"
            #if DEBUG
            print("map url: \(url)")
            #endif
            url = (url as NSString).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
            UIApplication.YH_OpenSafari(with: url)
        case .gaode(let navigationType):
            guard let appName = Bundle.main.infoDictionary?["CFBundleName"] as? String else { return }
            var d: String = ""
            if let destinationName = destinationName, destinationName.count > 0 {
                d = "&dlat=\(destination.latitude)&dlon=\(destination.longitude)&dname=\(destinationName)"
            } else {
                d = "&dlat=\(destination.latitude)&dlon=\(destination.longitude)"
            }
            var url = "iosamap://path" + "?sourceApplication=\(appName)" + d + "&dev=0" + "&t=\(navigationType.rawValue)"
            #if DEBUG
            print("map url: \(url)")
            #endif
            url = (url as NSString).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
            UIApplication.YH_OpenSafari(with: url)
        case .`self`(let directionsMode, let mapType, let showsTrafficKey):
            let destinationItem = MKMapItem(placemark: MKPlacemark(coordinate: destination, addressDictionary: nil))
            destinationItem.name = destinationName
            let currentItem = MKMapItem.forCurrentLocation()
            let options: [String: Any] = [MKLaunchOptionsDirectionsModeKey: directionsMode,
                                          MKLaunchOptionsMapTypeKey: NSNumber(value: mapType.rawValue),
                                          MKLaunchOptionsShowsTrafficKey: NSNumber(value: showsTrafficKey)]
            MKMapItem.openMaps(with: [currentItem, destinationItem], launchOptions: options)
        }
    }

}



