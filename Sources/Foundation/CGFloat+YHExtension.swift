//
//  CGFloat+YHExtension.swift
//  FNDating
//
//  Created by apple on 2019/9/27.
//  Copyright © 2019 yinhe. All rights reserved.
//

import Foundation
import CoreGraphics


public extension CGFloat {
    
    /// 角度转弧度
    var yh_degreesToRadius: CGFloat {
        get {
            return self / 180.0 * CGFloat(Double.pi)
        }
    }
}


