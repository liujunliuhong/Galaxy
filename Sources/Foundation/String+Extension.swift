//
//  String+Extension.swift
//  SwiftTool
//
//  Created by galaxy on 2021/5/14.
//  Copyright © 2021 yinhe. All rights reserved.
//

import Foundation
import CommonCrypto

extension GL where Base == String {
    /// `json`解析
    public var jsonDecode: Any? {
        guard let data = base.data(using: .utf8) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
    }
    
    /// If it is Chinese, then unicode is displayed on the console, which affects reading, so convert it.
    public var unicodeToUTF8: String? {
        guard let data = base.data(using: .utf8) else { return nil }
        guard let utf8 = String(data: data, encoding: .nonLossyASCII)?.utf8 else { return nil }
        return "\(utf8)"
    }
    
    /// 获取字符串中指定位置的内容
    public func string(index: Int) -> String? {
        if index >= base.count || index < 0 {
            return nil
        }
        let start = base.index(base.startIndex, offsetBy: index)
        let end = base.index(base.startIndex, offsetBy: index + 1)
        return String(base[start..<end])
    }
    
    /// 获取字符串中，某一个范围内的内容
    public func string(startIndex: Int, endIndex: Int) -> String? {
        if base.count <= 0 {
            return nil
        }
        if endIndex <= startIndex {
            return nil
        }
        let start = max(startIndex, 0)
        let end = min(endIndex, base.count)
        let _start = base.index(base.startIndex, offsetBy: start)
        let _end = base.index(base.startIndex, offsetBy: end)
        return String(base[_start..<_end])
    }
    
    /// 字符串中是否包含中文
    public func isIncludeChinese() -> Bool {
        for ch in base.unicodeScalars {
            if (0x4e00 < ch.value  && ch.value < 0x9fff) { // Chinese character range：0x4e00 ~ 0x9fff
                return true
            }
        }
        return false
    }
    
    /// 是否有`0x`或者`0X`前缀
    public var hasHexPrefix: Bool {
        return base.hasPrefix("0x") || base.hasPrefix("0X")
    }
    
    /// 切割`0x`或者`0X`前缀
    public var splitHexPrefix: String {
        if base.hasPrefix("0x") || base.hasPrefix("0X") {
            let indexStart = base.index(base.startIndex, offsetBy: 2)
            let result = String(base[indexStart...])
            if result.gl.hasHexPrefix {
                return result.gl.splitHexPrefix
            }
            return result
        }
        return base
    }
    
    /// 添加`0x`前缀（小写的`0x`）
    public var add0xHexPrefix: String {
        if !base.gl.hasHexPrefix {
            return "0x" + base
        }
        return base
    }
    
    /// 添加'0X'前缀（大写的`0X`）
    public var add0XHexPrefix: String {
        if !base.gl.hasHexPrefix {
            return "0x" + base
        }
        return base
    }
    
    /// `16`进制字符串转`Data`
    ///
    ///     "68656c6c6f" -> <68656c6c 6f>
    ///
    public var toHexData: Data? {
        let string = base.gl.splitHexPrefix
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
    
    /// 字符串转`Bytes<UInt8>`
    public var toBytes: Array<UInt8>? {
        guard let data = base.data(using: .utf8, allowLossyConversion: true) else { return nil }
        return data.gl.bytes
    }
    
    /// 将一个字符串`MD5`
    public var md5: String {
        return MD5.md5(string: self.base, upper: false)
    }
    
    /// 将一个字符串转为合法的`URL`
    ///
    /// 有些链接，比如`www.baidu.com`，在`iOS`里面，这不是一个合法的`URL`
    /// 需要在前面加上`http://`或者`https://`才是一个合法的`URL`
    ///
    ///     let urlString = "http:/.的哈哈🈲👌🏻///://:/www.baidu.com"
    ///     let result = urlString.gl.toURL(schemeType: .https) // https://www.baidu.com
    ///
    ///     let urlString2 = "www.baidu.com"
    ///     let result2 = urlString.gl.toURL(schemeType: .http) // http://www.baidu.com
    ///
    ///     let urlString3 = "http://www.baidu.com"
    ///     let result3 = urlString.gl.toURL(schemeType: .https) // https://www.baidu.com
    ///
    /// 只对前缀有效
    public func toURL(schemeType: SchemeType) -> String {
        let alphas = ["a", "b", "c", "d", "e", "f", "g",
                      "h", "i", "j", "k", "l", "m", "n",
                      "o", "p", "q", "r", "s", "t", "u",
                      "v", "w", "x", "y", "z",
                      "A", "B", "C", "D", "E", "F", "G",
                      "H", "I", "J", "K", "L", "M", "N",
                      "O", "P", "Q", "R", "S", "T", "U",
                      "V", "W", "X", "Y", "Z"]
        
        var tempString = base
        for scheme in SchemeType.allCases {
            if tempString.hasPrefix(scheme.rawValue) {
                let indexStart = tempString.index(tempString.startIndex, offsetBy: scheme.rawValue.count)
                tempString = String(tempString[indexStart...])
            }
        }
        if tempString.count <= 0 {
            return base
        }
        
        let indexStart = tempString.index(tempString.startIndex, offsetBy: 1)
        if !alphas.contains(String(tempString[tempString.startIndex..<indexStart])) {
            return String(tempString[indexStart...]).gl.toURL(schemeType: schemeType)
        }
        return schemeType.rawValue + "://" + base
    }
    
    /// 字符串每`chunkSize`进行分组
    public func split(intoChunksOf chunkSize: Int) -> [String] {
        var output = [String]()
        let splittedString = self.base.map{ $0 }.gl.makeGroups(perRowCount: chunkSize, isMakeUp: false, defaultValueClosure: nil)
        splittedString.forEach {
            output.append($0.map { String($0) }.joined(separator: ""))
        }
        return output
    }
}
