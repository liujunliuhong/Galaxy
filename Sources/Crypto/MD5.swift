//
//  MD5.swift
//  SwiftTool
//
//  Created by liujun on 2021/5/28.
//  Copyright © 2021 yinhe. All rights reserved.
//

import Foundation
import CommonCrypto

public struct MD5 {
    /// MD5
    public static func md5(string: String, upper: Bool) -> String {
        let ccharArray = string.cString(using: String.Encoding.utf8)
        var uint8Array = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        CC_MD5(ccharArray, CC_LONG(ccharArray!.count - 1), &uint8Array)
        if upper {
            let result = uint8Array.reduce("") { $0 + String(format: "%02X", $1) }
            return result
        } else {
            let result = uint8Array.reduce("") { $0 + String(format: "%02x", $1) }
            return result
        }
    }
}
