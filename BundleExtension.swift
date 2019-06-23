//
//  BundleExtension.swift
//  SwiftTool
//
//  Created by apple on 2019/4/25.
//  Copyright © 2019 yinhe. All rights reserved.
//

import Foundation

extension Bundle {
    public static func YH_AppVersion() -> String {
        let bundleDic = Bundle.main.infoDictionary;
        var version = ""
        if let result = bundleDic?["CFBundleShortVersionString"] {
            version = result as! String
        }
        return version
    }
    
    public static func YH_AppBuild() -> String {
        let bundleDic = Bundle.main.infoDictionary;
        var version = ""
        if let result = bundleDic?["CFBundleVersion"] {
            version = result as! String
        }
        return version
    }
    
    public static func YH_AppBundleID() -> String {
        let bundleDic = Bundle.main.infoDictionary;
        var version = ""
        if let result = bundleDic?["CFBundleIdentifier"] {
            version = result as! String
        }
        return version
    }
    
    public static func YH_AppName() -> String {
        let bundleDic = Bundle.main.infoDictionary;
        var version = ""
        if let result = bundleDic?["CFBundleDisplayName"] {
            version = result as! String
        }
        return version
    }
    
    public static func YH_AppDefaultStatusBarStyle() -> String {
        let bundleDic = Bundle.main.infoDictionary;
        var version = ""
        if let result = bundleDic?["UIStatusBarStyle"] {
            version = result as! String
        }
        return version
    }
}
