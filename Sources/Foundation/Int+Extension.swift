//
//  Int+Extension.swift
//  SwiftTool
//
//  Created by liujun on 2021/5/15.
//  Copyright © 2021 yinhe. All rights reserved.
//

import Foundation


extension Int {
    /// `Int`转`Float`
    public var gl_float: Float {
        return Float(self)
    }
    
    /// `Int`转`CGFloat`
    public var gl_cgFloat: CGFloat {
        return CGFloat(self)
    }
}
