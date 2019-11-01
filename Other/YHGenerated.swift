//
//  YHGenerated.swift
//  FNDating
//
//  Created by apple on 2019/8/27.
//  Copyright © 2019 yinhe. All rights reserved.
//

import Foundation
import UIKit
import SafariServices

@objc
public class YHGenerated: NSObject {
    // Open iphone setting.
    @objc
    public static func openIphoneSettings() {
        DispatchQueue.main.async {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
            }
        }
    }
    
    // Open App Store.
    @objc
    public static func openAppStore(with appID: String) {
        DispatchQueue.main.async {
            let urlString = "https://itunes.apple.com/app/id\(appID)"
            let url = URL(string: urlString)!
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    // Open App Store Review.
    @objc
    public static func openAppStoreReview(with appID: String) {
        DispatchQueue.main.async {
            let urlString = "https://itunes.apple.com/cn/app/id\(appID)?action=write-review"
            let url = URL(string: urlString)!
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    // Make call.
    @objc
    public static func makeCall(with tel: String) {
        DispatchQueue.main.async {
            let urlString = "tel://\(tel)"
            let url = URL(string: urlString)!
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    
    /// Open Safari
    ///
    /// - Parameters:
    ///   - url: url
    ///   - autoCorrect: Whether to automatically correct the url, such as adding http://
    @objc
    public static func openSafari(with url: String, autoCorrect: Bool = true) {
        
    }
    
    // Get local JSON file content.
    @objc
    public static func getLocalJSONFile(file fileName: String) -> Data? {
        let path = Bundle.main.path(forResource: fileName, ofType: "json") ?? ""
        // 将错误转换为可选值
        return try? Data(contentsOf: URL(fileURLWithPath: path))
    }
    
    // Get local Plist file content.
    @objc
    public static func getLocalPlistFile(file fileName: String) -> Data? {
        let path = Bundle.main.path(forResource: fileName, ofType: "plist") ?? ""
        // 将错误转换为可选值
        return try? Data(contentsOf: URL(fileURLWithPath: path))
    }
}


extension YHGenerated {
    public enum bundleType: String {
        case appVersion          = "CFBundleShortVersionString"
        case buildID             = "CFBundleVersion"
        case bundleID            = "CFBundleIdentifier"
        case appName             = "CFBundleDisplayName"
        case statusBarStyle      = "UIStatusBarStyle"
    }
    public static func getBundleInfo(with type: bundleType) -> String {
        let bundleDic = Bundle.main.infoDictionary
        return bundleDic?[type.rawValue] as? String ?? ""
    }
}

