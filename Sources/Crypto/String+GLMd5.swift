//
//  String+GLMd5.swift
//  SwiftTool
//
//  Created by Yule on 2020/12/7.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import CommonCrypto

extension String {
    /// md5
    public var gl_md5: String {
        let ccharArray = self.cString(using: String.Encoding.utf8)
        var uint8Array = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        CC_MD5(ccharArray, CC_LONG(ccharArray!.count - 1), &uint8Array)
        let result = uint8Array.reduce("") { $0 + String(format: "%02X", $1) }
        return result
    }
}
