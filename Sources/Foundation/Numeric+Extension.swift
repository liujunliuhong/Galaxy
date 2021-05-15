//
//  Numeric+Extension.swift
//  SwiftTool
//
//  Created by liujun on 2021/5/15.
//  Copyright © 2021 yinhe. All rights reserved.
//

import Foundation


extension Numeric {
    /// 角度转弧度
    public var gl_degreesToRadius: Double {
        let temp: Double = Double("\(self)") ?? 0
        var result = temp * Double.pi
        result = result / Double(180.0)
        return result
    }
    
    /// 弧度转角度
    public var gl_radiusToDegrees: Double {
        let temp: Double = Double("\(self)") ?? 0
        var result = temp * Double(180.0)
        result = result / Double.pi
        return result
    }
}
