//
//  UIImage+Extension.swift
//  SwiftTool
//
//  Created by galaxy on 2021/5/16.
//  Copyright © 2021 yinhe. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    /// 图片的高宽比
    public var gl_heightRatio: CGFloat {
        if size.width.isLessThanOrEqualTo(.zero) {
            return 1.0
        }
        return size.height / size.width
    }
    
    /// 图片的宽高比
    public var gl_widthRatio: CGFloat {
        if size.height.isLessThanOrEqualTo(.zero) {
            return 1.0
        }
        return size.width / size.height
    }
}
