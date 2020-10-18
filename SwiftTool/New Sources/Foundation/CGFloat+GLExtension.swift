//
//  CGFloat+GLExtension.swift
//  SwiftTool
//
//  Created by galaxy on 2020/10/18.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation


extension CGFloat {
    /// 角度转弧度
    public var gl_degreesToRadius: CGFloat {
        return self * CGFloat(Double.pi) / 180.0
    }
    
    /// 弧度转角度
    public var gl_radiusToDegrees: CGFloat {
        return (self * 180.0) / CGFloat(Double.pi)
    }
}
