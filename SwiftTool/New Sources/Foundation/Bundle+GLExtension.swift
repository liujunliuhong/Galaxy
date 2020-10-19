//
//  Bundle+GLExtension.swift
//  SwiftTool
//
//  Created by galaxy on 2020/10/19.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation

extension Bundle {
    
    /// app名字
    public static func gl_appName() -> String? {
        func getAppName(info: [String: Any]) -> String? {
            var result: String?
            if let name = info["CFBundleDisplayName"] as? String {
                result = name
            } else if let name = info["CFBundleName"] as? String {
                result = name
            } else if let name = info["CFBundleExecutable"] as? String {
                result = name
            }
            return result
        }
        if let localizedInfoDictionary = Bundle.main.localizedInfoDictionary, localizedInfoDictionary.count > 0 {
            return getAppName(info: localizedInfoDictionary)
        } else if let path = Bundle.main.path(forResource: "Info", ofType: "plist"), let info = NSDictionary(contentsOfFile: path) as? [String: Any] {
            return getAppName(info: info)
        }
        return nil
    }
    
    /// app bundleID
    public static func gl_appBundleID() -> String? {
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist"), let info = NSDictionary(contentsOfFile: path) as? [String: Any] {
            return info["CFBundleIdentifier"] as? String
        }
        return nil
    }
    
    /// app buildID
    public static func gl_appBuildID() -> String? {
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist"), let info = NSDictionary(contentsOfFile: path) as? [String: Any] {
            return info["CFBundleVersion"] as? String
        }
        return nil
    }
    
    /// app版本
    public static func gl_appVersion() -> String? {
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist"), let info = NSDictionary(contentsOfFile: path) as? [String: Any] {
            return info["CFBundleShortVersionString"] as? String
        }
        return nil
    }
}
