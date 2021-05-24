//
//  UIApplication+Extension.swift
//  SwiftTool
//
//  Created by galaxy on 2021/5/16.
//  Copyright © 2021 yinhe. All rights reserved.
//

import Foundation
import UIKit

extension GL where Base == UIApplication {
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
}


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
