//
//  Numeric+Extension.swift
//  SwiftTool
//
//  Created by liujun on 2021/5/15.
//  Copyright © 2021 yinhe. All rights reserved.
//

import Foundation

extension GL where Base: Numeric {
    /// 角度转弧度
    public var degreesToRadius: Double {
        let temp: Double = Double("\(base)") ?? 0
        var result = temp * Double.pi
        result = result / Double(180.0)
        return result
    }
    
    /// 弧度转角度
    public var radiusToDegrees: Double {
        let temp: Double = Double("\(base)") ?? 0
        var result = temp * Double(180.0)
        result = result / Double.pi
        return result
    }
}
