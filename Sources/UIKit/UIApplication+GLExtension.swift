//
//  UIApplication+GLExtension.swift
//  SwiftTool
//
//  Created by galaxy on 2020/10/19.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import UIKit


fileprivate func _open(url: String?, completionHandler: ((Bool) -> ())?) {
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
    /// 打开手机设置页面
    public func gl_openIphoneSettings() {
        _open(url: UIApplication.openSettingsURLString, completionHandler: nil)
    }
    
    /// 打开App Store
    public func gl_openAppStore(with appID: String?) {
        guard let appID = appID else { return }
        let urlString = "https://itunes.apple.com/app/id\(appID)"
        _open(url: urlString, completionHandler: nil)
    }
    
    /// 打开App Store的评论页面
    public func gl_openAppStoreReview(appID: String?) {
        guard let appID = appID else { return }
        let urlString = "https://itunes.apple.com/cn/app/id\(appID)?action=write-review"
        _open(url: urlString, completionHandler: nil)
    }
    
    /// 打电话
    public func gl_makeCall(tel: String?) {
        guard let tel = tel else { return }
        let urlString = "tel://\(tel)"
        _open(url: urlString, completionHandler: nil)
    }
    
    /// 用系统Safari浏览器打开链接
    /// - Parameters:
    ///   - url: url
    ///   - useHttpsWhenFail: 当打开失败时，是否使用https
    public func gl_openSafari(with url: String?, useHttpsWhenFail: Bool = true) {
        guard var url = url else { return }
        _open(url: url) { (isSuccess) in
            if isSuccess { return }
            if !useHttpsWhenFail {
                if url.hasPrefix("http") { return }
                url = "http://" + url
                _open(url: url, completionHandler: nil)
            } else {
                if url.hasPrefix("https") { return }
                url = "https://" + url
                _open(url: url, completionHandler: nil)
                
            }
        }
    }
}
