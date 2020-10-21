//
//  GLFileManager.swift
//  SwiftTool
//
//  Created by galaxy on 2020/10/21.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import UIKit

/// Document文件夹路径
public let GLDocumentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last
/// Library文件夹路径
public let GLLibraryDirectory = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).last
/// Caches文件夹路径
public let GLCachesDirectory = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last


public enum GLFileType: String {
    case json = "json"
    case plist = "plist"
}

public class GLFileManager {
    public static let `default` = GLFileManager()
}

extension GLFileManager {
    
    /// 创建文件夹。path是文件夹的路径
     public func creatDirectory(path: String?) throws {
        guard let path = path else { return }
        var isDirectory: ObjCBool = true
        if FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory) {
            return
        }
        try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
    }
    
    /// 计算尺寸。length单位是B
    public func caculateFileSize(length: Int) -> String {
        if (length < 1024) {
            return "\(length)B"
        } else if (length >= 1024 && length < (1024 * 1024)) {
            return "\(CGFloat(length) / 1024.0)KB"
        } else if (length > (1024 * 1024) && length < (1024 * 1024 * 1024)) {
            return "\(CGFloat(length) / (1024.0 * 1024.0))MB"
        } else {
            return "\(CGFloat(length) / (1024.0 * 1024.0 * 1024.0))GB"
        }
    }
}

extension GLFileManager {
    
    /// 获取本地文件。支持json文件或者plist文件
    public func getLocalFile(bundle: Bundle, fileName: String, type: GLFileType, options: JSONSerialization.ReadingOptions = [.mutableContainers]) -> Any? {
        guard let path = bundle.path(forResource: fileName, ofType: type.rawValue) else { return nil }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else { return nil }
        let resultData = try? JSONSerialization.jsonObject(with: data, options: options)
        return resultData
    }
}
