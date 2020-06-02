//
//  UIApplication+SwiftyExtensionForURL.swift
//  SwiftTool
//
//  Created by apple on 2020/5/19.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import UIKit

fileprivate func SwiftyExtensionOpen(url: String?, completionHandler: ((Bool) -> ())?) {
    guard let url = url else {
        completionHandler?(false)
        return
    }
    DispatchQueue.main.async {
        if #available(iOS 10.0, *) {
            if let url = URL(string: url) {
                UIApplication.shared.open(url, options: [:], completionHandler: completionHandler)
            } else {
                completionHandler?(false)
            }
        } else {
            if let url = URL(string: url) {
                let result = UIApplication.shared.openURL(url)
                completionHandler?(result)
            } else {
                completionHandler?(false)
            }
        }
    }
}

extension UIApplication {
    /// Open iphone setting.
    @objc public static func YH_OpenIphoneSettings() {
        SwiftyExtensionOpen(url: UIApplication.openSettingsURLString, completionHandler: nil)
    }
    
    /// Open App Store.
    @objc public static func YH_OpenAppStore(with appID: String?) {
        guard let appID = appID else { return }
        let urlString = "https://itunes.apple.com/app/id\(appID)"
        SwiftyExtensionOpen(url: urlString, completionHandler: nil)
    }
    
    /// Open App Store Review.
    @objc public static func YH_OpenAppStoreReview(appID: String?) {
        guard let appID = appID else { return }
        let urlString = "https://itunes.apple.com/cn/app/id\(appID)?action=write-review"
        SwiftyExtensionOpen(url: urlString, completionHandler: nil)
    }
    
    /// Make call.
    @objc public static func YH_MakeCall(tel: String?) {
        guard let tel = tel else { return }
        let urlString = "tel://\(tel)"
        SwiftyExtensionOpen(url: urlString, completionHandler: nil)
    }
    
    /// Open Safari
    /// - Parameters:
    ///   - url: url
    ///   - useHttpsWhenFail: When using the original address to open fails, do you use https to correct the original link and try to open again?
    @objc public static func YH_OpenSafari(with url: String?, useHttpsWhenFail: Bool = true) {
        guard var url = url else { return }
        SwiftyExtensionOpen(url: url) { (isSuccess) in
            if !isSuccess {
                if !useHttpsWhenFail {
                    if !url.hasPrefix("http") {
                        url = "http://" + url
                        SwiftyExtensionOpen(url: url, completionHandler: nil)
                    }
                } else {
                    if !url.hasPrefix("https") {
                        url = "https://" + url
                        SwiftyExtensionOpen(url: url, completionHandler: nil)
                    }
                }
            }
        }
    }
}
