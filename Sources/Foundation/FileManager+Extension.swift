//
//  FileManager+Extension.swift
//  SwiftTool
//
//  Created by galaxy on 2021/5/16.
//  Copyright © 2021 yinhe. All rights reserved.
//

import Foundation

extension FileManager {
    /// 获取`Document`文件夹路径
    public static var gl_documentDirectory: String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last ?? ""
    }
    
    /// 获取`Library`文件夹路径
    public static var gl_libraryDirectory: String {
        return NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).last ?? ""
    }
    
    /// 获取`Caches`文件夹路径
    public static var gl_cachesDirectory: String {
        return NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last ?? ""
    }
    
    /// 创建文件夹
    ///
    /// `path`是文件夹的路径
    public func gl_creatDirectory(path: String?) {
        guard let path = path else { return }
        var isDirectory: ObjCBool = true
        if FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory) {
            return
        }
        try? FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
    }
    
    /// 格式化尺寸
    ///
    /// `length`单位是`B`
    public func gl_formatSize(length: Int) -> String {
        let KB = 1024
        let MB = 1024 * 1024
        let GB = 1024 * 1024 * 1024
        
        var length = length
        if length >= Int.max - 1 {
            length = Int.max - 1
        }
        
        if (length < KB) {
            return String(format: "%.2fB", length.gl_cgFloat)
        } else if (length >= KB && length < MB) {
            return String(format: "%.2fKB", length.gl_cgFloat / KB.gl_cgFloat)
        } else if (length >= MB && length < GB) {
            return String(format: "%.2fMB", length.gl_cgFloat / MB.gl_cgFloat)
        } else {
            return String(format: "%.2fGB", length.gl_cgFloat / GB.gl_cgFloat)
        }
    }
}
