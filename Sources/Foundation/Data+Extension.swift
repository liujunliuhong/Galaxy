//
//  Data+Extension.swift
//  SwiftTool
//
//  Created by galaxy on 2021/5/14.
//  Copyright © 2021 yinhe. All rights reserved.
//

import Foundation

extension Data {
    /// 获取设备token，用于推送
    public var gl_deviceToken: String {
        return reduce("", { $0 + String(format: "%02x", $1) })
    }
}
