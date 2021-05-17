//
//  Bundle+Extension.swift
//  SwiftTool
//
//  Created by galaxy on 2021/5/14.
//  Copyright © 2021 yinhe. All rights reserved.
//

import Foundation
import UIKit

/// 文件类型
public enum GLFileType: String {
    case json = "json"    /// json
    case plist = "plist"  /// plist
}

extension Bundle {
    /// 获取APP名称
    public static var gl_appName: String? {
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
    
    /// 获取APP BundleID
    public static var gl_appBundleID: String? {
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist"), let info = NSDictionary(contentsOfFile: path) as? [String: Any] {
            return info["CFBundleIdentifier"] as? String
        }
        return nil
    }
    
    /// 获取APP BuildID
    public static var gl_appBuildID: String? {
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist"), let info = NSDictionary(contentsOfFile: path) as? [String: Any] {
            return info["CFBundleVersion"] as? String
        }
        return nil
    }
    
    /// 获取APP Version
    public static var gl_appVersion: String? {
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist"), let info = NSDictionary(contentsOfFile: path) as? [String: Any] {
            return info["CFBundleShortVersionString"] as? String
        }
        return nil
    }
}

extension Bundle {
    /// 获取某个`Bundle`下的图片(支持`png`、`jpg`、`jpeg`)
    ///
    /// 会自动去查找对应分辨率的图片，支持`Asset`文件夹和直接拖进工程的图片
    public func gl_image(name: String?) -> UIImage? {
        guard let name = name else { return nil }
        var scale = Int(UIScreen.main.scale)
        if scale < 2 {
            scale = 2
        } else if scale > 3 {
            scale = 3
        }
        let newName = "\(name)@\(scale)x"
        var image: UIImage?
        if let path = path(forResource: newName, ofType: "png") { /* test@2x.png */
            image = UIImage(contentsOfFile: path)
        } else if let path = path(forResource: newName, ofType: "jpg") { /* test@2x.jpg */
            image = UIImage(contentsOfFile: path)
        } else if let path = path(forResource: newName, ofType: "jpeg") { /* test@2x.jpeg */
            image = UIImage(contentsOfFile: path)
        } else if let path = path(forResource: name, ofType: "png") { /* test.png */
            image = UIImage(contentsOfFile: path)
        } else if let path = path(forResource: name, ofType: "jpg") { /* test.jpg */
            image = UIImage(contentsOfFile: path)
        } else if let path = path(forResource: name, ofType: "jpeg") { /* test.jpeg */
            image = UIImage(contentsOfFile: path)
        } else if let path = path(forResource: name, ofType: nil) {
            image = UIImage(contentsOfFile: path)
        } else {
            image = UIImage(named: name)
        }
        return image
    }
}

extension Bundle {
    /// 获取本地文件
    public func gl_getFile(fileName: String, type: GLFileType, options: JSONSerialization.ReadingOptions = [.mutableContainers]) -> Any? {
        guard let path = path(forResource: fileName, ofType: type.rawValue) else { return nil }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else { return nil }
        let resultData = try? JSONSerialization.jsonObject(with: data, options: options)
        return resultData
    }
}
