//
//  UIImage+Extension.swift
//  SwiftTool
//
//  Created by galaxy on 2021/5/16.
//  Copyright © 2021 yinhe. All rights reserved.
//

import Foundation
import UIKit

extension GL where Base: UIImage {
    /// 图片的高宽比
    public var heightRatio: CGFloat {
        if base.size.width.isLessThanOrEqualTo(.zero) {
            return 1.0
        }
        return base.size.height / base.size.width
    }
    
    /// 图片的宽高比
    public var widthRatio: CGFloat {
        if base.size.height.isLessThanOrEqualTo(.zero) {
            return 1.0
        }
        return base.size.width / base.size.height
    }
}
