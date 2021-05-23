//
//  Array+Extension.swift
//  SwiftTool
//
//  Created by galaxy on 2021/5/14.
//  Copyright © 2021 yinhe. All rights reserved.
//

import Foundation

extension GL where Base == Array<UInt8> {
    /// 字节数组转字符串
    public var bytesToString: String? {
        return String(bytes: base, encoding: .utf8)
    }
    
    /// 字节数组转`16`进制字符串
    public var bytesToHexString: String {
        return base.`lazy`.reduce("") {
            var s = String($1, radix: 16)
            if s.count == 1 {
                s = "0" + s
            }
            return $0 + s
        }
    }
}
