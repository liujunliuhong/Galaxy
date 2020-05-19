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

@objc public class YHGenerated: NSObject {
    
    
    // Get local JSON file content.
    @objc public static func getLocalJSONFile(file fileName: String) -> Data? {
        let path = Bundle.main.path(forResource: fileName, ofType: "json") ?? ""
        // 将错误转换为可选值
        return try? Data(contentsOf: URL(fileURLWithPath: path))
    }
    
    // Get local Plist file content.
    @objc public static func getLocalPlistFile(file fileName: String) -> Data? {
        let path = Bundle.main.path(forResource: fileName, ofType: "plist") ?? ""
        // 将错误转换为可选值
        return try? Data(contentsOf: URL(fileURLWithPath: path))
    }
}


public extension YHGenerated {
    enum bundleType: String {
        case appVersion          = "CFBundleShortVersionString"
        case buildID             = "CFBundleVersion"
        case bundleID            = "CFBundleIdentifier"
        case appName             = "CFBundleDisplayName"
        case statusBarStyle      = "UIStatusBarStyle"
    }
    static func getBundleInfo(with type: bundleType) -> String {
        let bundleDic = Bundle.main.infoDictionary
        return bundleDic?[type.rawValue] as? String ?? ""
    }
}

public extension YHGenerated {
    @objc static func fileSize(length: Int) -> String {
        if (length < 1024) {
            return "\(length)B"
        }else if (length >= 1024 && length < (1024 * 1024)){
            return "\(CGFloat(length) / 1024.0)KB"
        } else if (length > (1024 * 1024) && length < (1024 * 1024 * 1024)) {
            return "\(CGFloat(length) / (1024.0 * 1024.0))MB"
        } else {
            return "\(CGFloat(length) / (1024.0 * 1024.0 * 1024.0))GB"
        }
    }
}
