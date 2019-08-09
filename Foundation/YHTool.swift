//
//  YHTool.swift
//  SwiftTool
//
//  Created by 银河 on 2019/6/26.
//  Copyright © 2019 yinhe. All rights reserved.
//

import Foundation
import UIKit

// Open iphone setting.
func YHOpenIphoneSettings() {
    DispatchQueue.main.async {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
        }
    }
}

// Open App Store.
func YHOpenAppStore(with appID: String) {
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
func YHOpenAppStoreReview(with appID: String) {
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
func YHMakeCall(with tel: String) {
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
func YHOpenSafari(with url: String, autoCorrect: Bool) {
    
}

// Get local JSON file content.
func YHGetLocalJSONFile(file fileName: String) -> Data? {
    let path = Bundle.main.path(forResource: fileName, ofType: "json") ?? ""
    // 将错误转换为可选值
    return try? Data(contentsOf: URL(fileURLWithPath: path))
}

// Get local Plist file content.
func YHGetLocalPlistFile(file fileName: String) -> Data? {
    let path = Bundle.main.path(forResource: fileName, ofType: "plist") ?? ""
    // 将错误转换为可选值
    return try? Data(contentsOf: URL(fileURLWithPath: path))
}
