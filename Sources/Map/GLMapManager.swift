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
 */

public enum GLBaiDuMapCoordinateType: String {
    case bd09ll = "bd09ll" // 百度经纬度坐标
    case bd09mc = "bd09mc" // 百度墨卡托坐标
    case gcj02 = "gcj02"   // 经国测局加密的坐标
    case wgs84 = "wgs84"   // gps获取的原始坐标
}

public enum GLBaiDuNavigationType: String {
    case transit = "transit"       // 公交
    case driving = "driving"       // 驾车
    case navigation = "navigation" // 导航
    case walking = "walking"       // 步行
    case riding = "riding"         // 骑行
}

public enum GLGaoDeNavigationType: Int {
    case driving = 0   // 驾车
    case transit = 1   // 公交
    case walking = 2   // 步行
    case riding = 3    // 骑行
}

public class GLMapManager {
    public static let `default` = GLMapManager()
}

extension GLMapManager {
    /// 是否可以打开百度地图app
    public func canOpenBaiDuMapApp() -> Bool {
        guard let url = URL(string: "baidumap://") else { return false }
        return UIApplication.shared.canOpenURL(url)
    }
    
    /// 是否可以打开高德地图app
    public func canOpenGaoDeMapApp() -> Bool {
        guard let url = URL(string: "iosamap://") else { return false }
        return UIApplication.shared.canOpenURL(url)
    }
    
    /// 打开系统地图的导航
    /// - Parameters:
    ///   - currentPlace: 当前位置，可以为空。如果为空，将使用系统的当前位置
    ///   - currentPlaceName: 当前位置名字，可以为空
    ///   - destination: 目的地，可以为空。如果为空，拉不起导航
    ///   - destinationName: 目的地名称，可以为空
    ///   - directionsMode: 导航模式
    ///   - mapType: 地图类型
    ///   - showsTrafficKey: 是否显示交通情况
    public func openSystemMap(currentPlace: CLLocationCoordinate2D?,
                              currentPlaceName: String?,
                              destination: CLLocationCoordinate2D?,
                              destinationName: String?,
                              directionsMode: String,
                              mapType: MKMapType,
                              showsTrafficKey: Bool) {
        guard let destination = destination else { return }
        //
        var currentPlaceItem: MKMapItem?
        if let currentPlace = currentPlace, let currentPlaceName = currentPlaceName, currentPlaceName.count > 0 {
            let _currentPlaceItem = MKMapItem(placemark: MKPlacemark(coordinate: currentPlace, addressDictionary: nil))
            _currentPlaceItem.name = currentPlaceName
            currentPlaceItem = _currentPlaceItem
        } else if let currentPlace = currentPlace {
            let _currentPlaceItem = MKMapItem(placemark: MKPlacemark(coordinate: currentPlace, addressDictionary: nil))
            currentPlaceItem = _currentPlaceItem
        } else if let currentPlaceName = currentPlaceName, currentPlaceName.count > 0 {
            let _currentPlaceItem = MKMapItem.forCurrentLocation()
            _currentPlaceItem.name = currentPlaceName
            currentPlaceItem = _currentPlaceItem
        } else {
            let _currentPlaceItem = MKMapItem.forCurrentLocation()
            currentPlaceItem = _currentPlaceItem
        }
        if currentPlaceItem == nil {
            return
        }
        //
        let destinationItem = MKMapItem(placemark: MKPlacemark(coordinate: destination, addressDictionary: nil))
        destinationItem.name = destinationName
        /*
         MKLaunchOptionsDirectionsModeKey:
         MKLaunchOptionsDirectionsModeDefault、
         MKLaunchOptionsDirectionsModeDriving、
         MKLaunchOptionsDirectionsModeWalking、
         MKLaunchOptionsDirectionsModeTransit
         */
        let options: [String: Any] = [MKLaunchOptionsDirectionsModeKey: directionsMode,
                                      MKLaunchOptionsMapTypeKey: NSNumber(value: mapType.rawValue),
                                      MKLaunchOptionsShowsTrafficKey: NSNumber(value: showsTrafficKey)]
        MKMapItem.openMaps(with: [currentPlaceItem!, destinationItem], launchOptions: options)
    }
    
    
    /// 打开百度地图的导航(http://lbsyun.baidu.com/index.php?title=uri/api/ios)
    /// - Parameters:
    ///   - currentPlace: 当前位置，可以为空。起点经纬度参数为空，且起点名称为空，则以“我的位置”发起路线规划
    ///   - currentPlaceName: 当前位置名称，可以为空
    ///   - destination: 目的地，可以为空。如果为空，拉不起导航
    ///   - destinationName: 目的地名称，可以为空
    ///   - coordinateType: 坐标类型
    ///   - navigationType: 导航模式
    public func openBaiDuMap(currentPlace: CLLocationCoordinate2D?,
                             currentPlaceName: String?,
                             destination: CLLocationCoordinate2D?,
                             destinationName: String?,
                             coordinateType: GLBaiDuMapCoordinateType,
                             navigationType: GLBaiDuNavigationType) {
        guard let destination = destination else { return }
        guard let bundleID = Bundle.gl_appBundleID else { return }
        //
        var origin: String = "origin={{我的位置}}"
        if let currentPlace = currentPlace, let currentPlaceName = currentPlaceName, currentPlaceName.count > 0 {
            origin = "origin=name:\(currentPlaceName)|latlng:\(currentPlace.latitude),\(currentPlace.longitude)"
        } else if let currentPlace = currentPlace {
            origin = "origin=\(currentPlace.latitude),\(currentPlace.longitude)"
        } else if let currentPlaceName = currentPlaceName, currentPlaceName.count > 0 {
            origin = "origin=\(currentPlaceName)"
        }
        //
        var d: String = ""
        if let destinationName = destinationName, destinationName.count > 0 {
            d = "&destination=name:\(destinationName)|latlng:\(destination.latitude),\(destination.longitude)"
        } else {
            d = "&destination=\(destination.latitude),\(destination.longitude)"
        }
        var url = "baidumap://map/direction" + "?" + origin + d + "&coord_type=\(coordinateType.rawValue)" + "&mode=\(navigationType.rawValue)" + "&src=\(bundleID)"
        #if DEBUG
        print("map url: \(url)")
        #endif
        url = (url as NSString).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
        UIApplication.shared.gl_openSafari(with: url)
    }
    
    
    /// 打开高德地图导航(https://lbs.amap.com/api/amap-mobile/guide/ios/route)
    /// - Parameters:
    ///   - currentPlace: 当前位置，可以为空。起点经纬度参数为空，且起点名称为空，则以“我的位置”发起路线规划
    ///   - currentPlaceName: 当前位置名称，可以为空
    ///   - destination: 目的地，可以为空。如果为空，拉不起导航
    ///   - destinationName: 目的地名称，可以为空
    ///   - navigationType: 导航类型
    public func openGaoDeMap(currentPlace: CLLocationCoordinate2D?,
                             currentPlaceName: String?,
                             destination: CLLocationCoordinate2D?,
                             destinationName: String?,
                             navigationType: GLGaoDeNavigationType) {
        guard let destination = destination else { return }
        guard let appName = Bundle.main.infoDictionary?["CFBundleName"] as? String else { return }
        //
        var origin: String = ""
        if let currentPlace = currentPlace, let currentPlaceName = currentPlaceName, currentPlaceName.count > 0 {
            origin = "&slat=\(currentPlace.latitude)&slon=\(currentPlace.longitude)&sname=\(currentPlaceName)"
        } else if let currentPlace = currentPlace {
            origin = "&slat=\(currentPlace.latitude)&slon=\(currentPlace.longitude)"
        } else if let currentPlaceName = currentPlaceName, currentPlaceName.count > 0 {
            origin = "&sname=\(currentPlaceName)"
        }
        //
        var d: String = ""
        if let destinationName = destinationName, destinationName.count > 0 {
            d = "&dlat=\(destination.latitude)&dlon=\(destination.longitude)&dname=\(destinationName)"
        } else {
            d = "&dlat=\(destination.latitude)&dlon=\(destination.longitude)"
        }
        //
        var url = "iosamap://path" + "?sourceApplication=\(appName)" + origin + d + "&dev=0" + "&t=\(navigationType.rawValue)"
        #if DEBUG
        print("map url: \(url)")
        #endif
        url = (url as NSString).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
        UIApplication.shared.gl_openSafari(with: url)
    }
}



