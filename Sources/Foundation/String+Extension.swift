//
//  String+Extension.swift
//  SwiftTool
//
//  Created by galaxy on 2021/5/14.
//  Copyright © 2021 yinhe. All rights reserved.
//

import Foundation


extension String {
    /// `json`解析
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
    
    /// 是否有`0x`或者`0X`前缀
    public var gl_hasHexPrefix: Bool {
        return hasPrefix("0x") || hasPrefix("0X")
    }
    
    /// 切割`0x`或者`0X`前缀
    public var gl_splitHexPrefix: String {
        if hasPrefix("0x") || hasPrefix("0X") {
            let indexStart = index(startIndex, offsetBy: 2)
            let result = String(self[indexStart...])
            if result.gl_hasHexPrefix {
                return result.gl_splitHexPrefix
            }
            return result
        }
        return self
    }
    
    /// 添加`0x`前缀（小写的`0x`）
    public var gl_add0xHexPrefix: String {
        if !gl_hasHexPrefix {
            return "0x" + self
        }
        return self
    }
    
    /// 添加'0X'前缀（大写的`0X`）
    public var gl_add0XHexPrefix: String {
        if !gl_hasHexPrefix {
            return "0x" + self
        }
        return self
    }
    
    /// `16`进制字符串转`Data`
    ///
    ///     "68656c6c6f" -> <68656c6c 6f>
    ///
    public var gl_toHexData: Data? {
        let string = gl_splitHexPrefix
        guard let hexData = string.data(using: .ascii) else { return nil }
        
        let len = string.count / 2
        var data: Data?
        
        hexData.withUnsafeBytes { ptr in
            var dataPtrOffset = 0
            
            guard let baseAddress = ptr.baseAddress else { return }
            let dataPtr = UnsafeMutablePointer<UInt8>.allocate(capacity: len)
            
            for offset in stride(from: 0, to: string.count, by: 2) {
                let bytes = Data(bytes: baseAddress+offset, count: 2)
                guard let string = String(data: bytes, encoding: .ascii) else {
                    dataPtr.deallocate()
                    return
                }
                guard let num = UInt8(string, radix: 16) else {
                    dataPtr.deallocate()
                    return
                }
                dataPtr[dataPtrOffset] = num
                dataPtrOffset += 1
            }
            data = Data(bytesNoCopy: dataPtr, count: len, deallocator: .free)
        }
        guard let validData = data else { return nil }
        return validData
    }
    
    /// 字符串转`Bytes`
    public var gl_toBytes: Array<UInt8>? {
        guard let data = data(using: .utf8, allowLossyConversion: true) else { return nil }
        return data.gl_bytes
    }
    
    /// 将一个字符串转为合法的`URL`
    ///
    /// 有些链接，比如`www.baidu.com`，在`iOS`里面，这不是一个合法的`URL`
    /// 需要在前面加上`http://`或者`https://`才是一个合法的`URL`
    ///
    ///     let urlString = "http:/.的哈哈🈲👌🏻///://:/www.baidu.com"
    ///     let result = urlString.gl_toURL(schemeType: .https) // https://www.baidu.com
    ///
    ///     let urlString2 = "www.baidu.com"
    ///     let result2 = urlString.gl_toURL(schemeType: .http) // http://www.baidu.com
    ///
    ///     let urlString3 = "http://www.baidu.com"
    ///     let result3 = urlString.gl_toURL(schemeType: .https) // https://www.baidu.com
    ///
    public func gl_toURL(schemeType: URL.GLSchemeType) -> String {
        let alphas = ["a", "b", "c", "d", "e", "f", "g",
                      "h", "i", "j", "k", "l", "m", "n",
                      "o", "p", "q", "r", "s", "t", "u",
                      "v", "w", "x", "y", "z",
                      "A", "B", "C", "D", "E", "F", "G",
                      "H", "I", "J", "K", "L", "M", "N",
                      "O", "P", "Q", "R", "S", "T", "U",
                      "V", "W", "X", "Y", "Z"]
        
        var tempString = self
        for scheme in URL.GLSchemeType.allCases {
            if tempString.hasPrefix(scheme.rawValue) {
                let indexStart = tempString.index(tempString.startIndex, offsetBy: scheme.rawValue.count)
                tempString = String(tempString[indexStart...])
            }
        }
        if tempString.count <= 0 {
            return self
        }
        
        let indexStart = tempString.index(tempString.startIndex, offsetBy: 1)
        if !alphas.contains(String(tempString[tempString.startIndex..<indexStart])) {
            return String(tempString[indexStart...]).gl_toURL(schemeType: schemeType)
        }
        return schemeType.rawValue + "://" + self
    }
}
