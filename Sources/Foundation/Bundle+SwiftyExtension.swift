//
//  Bundle+SwiftyExtension.swift
//  SwiftTool
//
//  Created by apple on 2020/5/20.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation

extension Bundle {
    public enum YHBundleType: String {
        case appVersion          = "CFBundleShortVersionString"
        case buildID             = "CFBundleVersion"
        case bundleID            = "CFBundleIdentifier"
        case appName             = "CFBundleDisplayName"
        case statusBarStyle      = "UIStatusBarStyle"
    }
    
    /// Get Bundle Info
    /// - Parameter type: type
    /// - Returns: String
    public static func YH_BundleInfo(type: YHBundleType) -> String? {
        return Bundle.main.infoDictionary?[type.rawValue] as? String
    }
}
