//
//  CGFloat+SwiftyExtension.swift
//  SwiftTool
//
//  Created by apple on 2020/5/20.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import UIKit

extension CGFloat {
    /// Angle to radian
    public var yh_degreesToRadius: CGFloat {
        return self * CGFloat(Double.pi) / 180.0
    }
    
    /// Radian to angle
    public var yh_radiusToDegrees: CGFloat {
        return (self * 180.0) / CGFloat(Double.pi)
    }
}
