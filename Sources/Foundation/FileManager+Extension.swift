//
//  FileManager+Extension.swift
//  SwiftTool
//
//  Created by galaxy on 2021/5/16.
//  Copyright © 2021 yinhe. All rights reserved.
//

import Foundation

extension GL where Base: FileManager {
    /// 获取`Document`文件夹路径
    public var documentDirectory: String? {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last
    }
    
    /// 获取`Library`文件夹路径
    public var libraryDirectory: String? {
        return NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).last
    }
    
    /// 获取`Caches`文件夹路径
    public var cachesDirectory: String? {
        return NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last
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
    public func formatSize(length: Int64) -> String {
        let KB: Int64 = 1024
        let MB: Int64 = 1024 * 1024
        let GB: Int64 = 1024 * 1024 * 1024
        
        var length = length
        if length >= Int64.max - 1 {
            length = Int64.max - 1
        }
        
        if (length < KB) {
            return String(format: "%.2f B", length.gl.cgFloat)
        } else if (length >= KB && length < MB) {
            return String(format: "%.2f KB", length.gl.cgFloat / KB.gl.cgFloat)
        } else if (length >= MB && length < GB) {
            return String(format: "%.2f MB", length.gl.cgFloat / MB.gl.cgFloat)
        } else {
            return String(format: "%.2f GB", length.gl.cgFloat / GB.gl.cgFloat)
        }
    }
    
    /// 获取文件大小，支持文件夹
    ///
    ///     返回的单位是`B`
    public func fileSize(at path: String) -> Int64? {
        var isDirectory: ObjCBool = false
        guard base.fileExists(atPath: path, isDirectory: &isDirectory) else {
            return nil
        }
        
        if isDirectory.boolValue {
            return base.subpaths(atPath: path)?.reduce(into: 0) {
                $0 += (fileSize(at: path + "/" + $1) ?? 0)
            }
        } else {
            let attributes = try? base.attributesOfItem(atPath: path)
            return attributes?[.size] as? Int64
        }
    }
}
