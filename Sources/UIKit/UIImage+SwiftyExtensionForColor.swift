//
//  UIImage+SwiftyExtensionForColor.swift
//  SwiftTool
//
//  Created by apple on 2020/5/18.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import UIKit

public extension UIImage {
    
    /// color to image
    /// - Parameters:
    ///   - color: color
    ///   - size: size
    /// - Returns: UIImage
    static func YH_Image(color: UIColor, size: CGSize = CGSize(width: 1.0, height: 1.0)) -> UIImage? {
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
