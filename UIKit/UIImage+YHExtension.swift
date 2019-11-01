//
//  UIImage+YHExtension.swift
//  FNDating
//
//  Created by apple on 2019/9/25.
//  Copyright © 2019 yinhe. All rights reserved.
//

import Foundation
import UIKit

@objc
extension UIImage {
    
    static func yh_image(color: UIColor, size: CGSize) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
