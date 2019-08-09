//
//  YHBundleExtension.swift
//  SwiftTool
//
//  Created by apple on 2019/6/26.
//  Copyright © 2019 yinhe. All rights reserved.
//

import Foundation

extension Bundle {
    enum YHBundleType: String {
        case appVersion          = "CFBundleShortVersionString"
        case buildID             = "CFBundleVersion"
        case bundleID            = "CFBundleIdentifier"
        case appName             = "CFBundleDisplayName"
        case statusBarStyle      = "UIStatusBarStyle"
    }
    
    static func YHGetBundleInfo(with type: YHBundleType) -> String {
        let bundleDic = Bundle.main.infoDictionary
        return bundleDic?[type.rawValue] as? String ?? ""
    }
}
