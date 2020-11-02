//
//  Data+GLExtension.swift
//  SwiftTool
//
//  Created by galaxy on 2020/10/21.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation

extension Data {
    /// 设备token，用于推送
    public var gl_deviceToken: String {
        return self.reduce("", { $0 + String(format: "%02x", $1) })
    }
}
