//
//  String+Extension.swift
//  SwiftTool
//
//  Created by galaxy on 2021/5/14.
//  Copyright © 2021 yinhe. All rights reserved.
//

import Foundation
import UIKit
import CoreText
import BigInt

extension GL where Base == String {
    /// `json`解析
    public func jsonDecode(options: JSONSerialization.ReadingOptions = []) -> Any? {
        guard let data = base.data(using: .utf8) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: options)
    }
    
    /// `json`解析到指定模型
    public func jsonDecodeTo<T>(type: T.Type) -> T? where T: Decodable {
        guard let data = base.data(using: .utf8) else { return nil }
        return try? JSONDecoder().decode(type, from: data)
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
    
    /// 字符串转`Date`
    public func toDate(format: String, locale: Locale = .current) -> Date? {
        String.formatter.locale = locale
        String.formatter.dateFormat = format
        return String.formatter.date(from: base)
    }
    
    /// 大单位转小单位
    ///
    ///     "1.1".block.parseToBigUInt(5) => 110000
    public func parseToBigUInt(decimals: Int) -> BigUInt? {
        var string = base.replacingOccurrences(of: ",", with: "")
        string = string.replacingOccurrences(of: "_", with: "")
        let components = string.components(separatedBy: ".")
        guard components.count == 1 || components.count == 2 else { return nil }
        let unitDecimals = decimals
        guard let beforeDecPoint = BigUInt(components[0], radix: 10) else { return nil }
        var mainPart = beforeDecPoint*BigUInt(10).power(unitDecimals)
        if (components.count == 2) {
            var value = components[1]
            if value.count > unitDecimals {
                value = String(value.prefix(unitDecimals))
            }
            let numDigits = value.count
            guard let afterDecPoint = BigUInt(value, radix: 10) else { return nil }
            let extraPart = afterDecPoint*BigUInt(10).power(unitDecimals-numDigits)
            mainPart = mainPart + extraPart
        }
        return mainPart
    }
    
    /// 小数后面补齐`0`
    ///
    ///     "1.2".block.decimalRightPadding(toLength: 5, withPad: "0") => 1.20000
    public func decimalRightPadding(toLength: UInt, withPad character: Character, decimalSeparator: String = ".") -> String {
        let groups = base.components(separatedBy: decimalSeparator)
        if groups.count == 1, let _ = BigInt(base, radix: 10) {
            return (base + decimalSeparator + "0").gl.decimalRightPadding(toLength: toLength, withPad: character, decimalSeparator: decimalSeparator)
        } else if groups.count == 2 {
            let before = groups[0]
            var after = groups[1]
            guard let _ = BigInt(before, radix: 10) else { return base }
            guard let _ = BigInt(after, radix: 10) else { return base }
            if toLength <= 0 {
                return before
            }
            if after.count >= toLength {
                after = String(after.prefix(Int(toLength)))
            } else {
                after = after + String(repeating: character, count: Int(toLength) - after.count)
            }
            return before + decimalSeparator + after
        }
        return base
    }
    
    /// 字符串的整个范围
    public var fullRange: Range<String.Index> {
        return base.startIndex..<base.endIndex
    }
    
    /// 字符串的整个范围
    public var fullNSRange: NSRange {
        return NSRange(fullRange, in: base)
    }
}

extension String {
    fileprivate static let formatter = DateFormatter()
}


extension GL where Base == String {
    /// 文字转图片
    public func toImage(size: CGFloat, font: UIFont, scale: CGFloat = UIScreen.main.scale) -> UIImage? {
        guard !base.isEmpty, scale >= 1 else { return nil }
        let attributedString = NSAttributedString(string: base, attributes: [.font : font, .foregroundColor: UIColor.white.cgColor])
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGImageAlphaInfo.premultipliedFirst.rawValue | CGImageByteOrderInfo.orderDefault.rawValue
        guard let context = CGContext(data: nil,
                                      width: Int(size * scale),
                                      height: Int(size * scale),
                                      bitsPerComponent: 8,
                                      bytesPerRow: 0,
                                      space: colorSpace,
                                      bitmapInfo: bitmapInfo) else {
            return nil
        }
        context.interpolationQuality = .high
        let line = CTLineCreateWithAttributedString(attributedString)
        let frame = CTLineGetBoundsWithOptions(line, .useGlyphPathBounds)
        context.textPosition = CGPoint(x: 0, y: -frame.origin.y)
        CTLineDraw(line, context)
        guard let cgImage = context.makeImage() else { return nil }
        return UIImage(cgImage: cgImage, scale: scale, orientation: .up)
    }
}
