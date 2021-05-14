//
//  String+Extension.swift
//  SwiftTool
//
//  Created by galaxy on 2021/5/14.
//  Copyright © 2021 yinhe. All rights reserved.
//

import Foundation

extension String {
    /// json decode
    public var gl_jsonDecode: Any? {
        guard let data = data(using: .utf8) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
    }
    
    /// If it is Chinese, then unicode is displayed on the console, which affects reading, so convert it.
    public var gl_unicodeToUTF8: String? {
        guard let data = data(using: .utf8) else { return nil }
        guard let utf8 = String(data: data, encoding: .nonLossyASCII)?.utf8 else { return nil }
        return "\(utf8)"
    }
    
    /// 获取字符串中指定位置的内容
    public func gl_string(index: Int) -> String? {
        if index >= count || index < 0 {
            return nil
        }
        let start = self.index(startIndex, offsetBy: index)
        let end = self.index(startIndex, offsetBy: index + 1)
        return String(self[start..<end])
    }
    
    /// 获取字符串中，某一个范围内的内容
    public func gl_string(startIndex: Int, endIndex: Int) -> String? {
        if count <= 0 {
            return nil
        }
        if endIndex <= startIndex {
            return nil
        }
        let start = max(startIndex, 0)
        let end = min(endIndex, count)
        let _start = self.index(self.startIndex, offsetBy: start)
        let _end = self.index(self.startIndex, offsetBy: end)
        return String(self[_start..<_end])
    }
    
    /// 字符串中是否包含中文
    public func gl_isIncludeChinese() -> Bool {
        for ch in unicodeScalars {
            if (0x4e00 < ch.value  && ch.value < 0x9fff) { // Chinese character range：0x4e00 ~ 0x9fff
                return true
            }
        }
        return false
    }
}
