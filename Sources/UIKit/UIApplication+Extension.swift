//
//  UIApplication+Extension.swift
//  SwiftTool
//
//  Created by galaxy on 2021/5/16.
//  Copyright © 2021 yinhe. All rights reserved.
//

import Foundation
import UIKit

@available(iOSApplicationExtension, unavailable, message: "This method is NS_EXTENSION_UNAVAILABLE.")
extension GL where Base: UIApplication {
    /// 打开手机设置页面
    public func openIphoneSettings() {
        _open(urlString: UIApplication.openSettingsURLString, completionHandler: nil)
    }
    
    /// 打开`App Store`
    public func openAppStore(with appID: String?) {
        guard let appID = appID else { return }
        let urlString = "https://itunes.apple.com/app/id\(appID)"
        _open(urlString: urlString, completionHandler: nil)
    }
    
    /// 打开`App Store`的评论页面
    public func openAppStoreReview(appID: String?) {
        guard let appID = appID else { return }
        let urlString = "https://itunes.apple.com/cn/app/id\(appID)?action=write-review"
        _open(urlString: urlString, completionHandler: nil)
    }
    
    /// 打电话
    public func makeCall(tel: String?) {
        guard let tel = tel else { return }
        let urlString = "tel://\(tel)"
        _open(urlString: urlString, completionHandler: nil)
    }
    
    /// 用系统`Safari`浏览器打开指定链接
    /// - Parameters:
    ///   - urlString: 给定的连接
    ///   - schemeType: schemeType
    ///
    /// 先尝试用浏览器打开给定的链接，如果打开失败，会用给定的`schemeType`对链接进行改造，再尝试打开
    public func openSafari(urlString: String?, schemeType: SchemeType) {
        var urlString = urlString
        _open(urlString: urlString) { (isSuccess) in
            if isSuccess { return }
            urlString = urlString?.gl.toURL(schemeType: schemeType)
            _open(urlString: urlString, completionHandler: nil)
        }
    }
    
    
    /// 获取最顶层的控制器
    /// - Parameter base: base
    /// - Returns: 最顶层的控制器
    public func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
            
        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return topViewController(base: selected)
            
        } else if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}

@available(iOSApplicationExtension, unavailable, message: "This method is NS_EXTENSION_UNAVAILABLE.")
fileprivate func _open(urlString: String?, completionHandler: ((Bool) -> ())?) {
    DispatchQueue.main.async {
        guard let urlString = urlString else {
            completionHandler?(false)
            return
        }
        guard let url = URL(string: urlString) else {
            completionHandler?(false)
            return
        }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: completionHandler)
        } else {
            let result = UIApplication.shared.openURL(url)
            completionHandler?(result)
        }
    }
}
