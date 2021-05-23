//
//  Int+Extension.swift
//  SwiftTool
//
//  Created by liujun on 2021/5/15.
//  Copyright © 2021 yinhe. All rights reserved.
//

import Foundation
import CoreGraphics

extension GL where Base == Int {
    /// `Int`转`Float`
    public var float: Float {
        return Float(base)
    }
    
    /// `Int`转`CGFloat`
    public var cgFloat: CGFloat {
        return CGFloat(base)
    }
}
