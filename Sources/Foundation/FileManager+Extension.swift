//
//  FileManager+Extension.swift
//  SwiftTool
//
//  Created by galaxy on 2021/5/16.
//  Copyright © 2021 yinhe. All rights reserved.
//

import Foundation

extension GL where Base == FileManager {
    /// 获取`Document`文件夹路径
    public static var documentDirectory: String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last ?? ""
    }
    
    /// 获取`Library`文件夹路径
    public static var libraryDirectory: String {
        return NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).last ?? ""
    }
    
    /// 获取`Caches`文件夹路径
    public static var cachesDirectory: String {
        return NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last ?? ""
    }
    
    /// 创建文件夹
    ///
    /// `path`是文件夹的路径
    public func creatDirectory(path: String?) {
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
    public func formatSize(length: Int) -> String {
        let KB = 1024
        let MB = 1024 * 1024
        let GB = 1024 * 1024 * 1024
        
        var length = length
        if length >= Int.max - 1 {
            length = Int.max - 1
        }
        
        if (length < KB) {
            return String(format: "%.2fB", length.gl.cgFloat)
        } else if (length >= KB && length < MB) {
            return String(format: "%.2fKB", length.gl.cgFloat / KB.gl.cgFloat)
        } else if (length >= MB && length < GB) {
            return String(format: "%.2fMB", length.gl.cgFloat / MB.gl.cgFloat)
        } else {
            return String(format: "%.2fGB", length.gl.cgFloat / GB.gl.cgFloat)
        }
    }
}
