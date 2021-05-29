//
//  Data+Extension.swift
//  SwiftTool
//
//  Created by galaxy on 2021/5/14.
//  Copyright © 2021 yinhe. All rights reserved.
//

import Foundation

private let hexAlphabet = "0123456789abcdef".unicodeScalars.map { $0 }

extension GL where Base == Data {
    /// 获取设备`token`，用于推送
    public var deviceToken: String {
        return toHexString
    }
    
    /// `Data`转`Bytes`
    ///
    /// `Byte`是`UInt8`类型
    public var bytes: [UInt8] {
        return [UInt8](base)
    }
    
    /// `Data`转`16`进制字符串
    ///
    /// 转换为`16`进制字符串之后，全部为小写，且不含`0x`或者`0X`前缀
    ///
    ///     <68656c6c 6f> -> "68656c6c6f"
    public var toHexString: String {
        return base.reduce("", { $0 + String(format: "%02x", $1) })
    }
    
    /// 生成指定长度的随机`Data`
    public static func randomData(length: Int) -> Data? {
        for _ in 0...1024 {
            var data = Data(repeating: 0, count: length)
            let result = data.withUnsafeMutableBytes { (body: UnsafeMutableRawBufferPointer) -> Int32? in
                if let bodyAddress = body.baseAddress, body.count > 0 {
                    let pointer = bodyAddress.assumingMemoryBound(to: UInt8.self)
                    return SecRandomCopyBytes(kSecRandomDefault, length, pointer)
                } else {
                    return nil
                }
            }
            if let notNilResult = result, notNilResult == errSecSuccess {
                return data
            }
        }
        return nil
    }
}
