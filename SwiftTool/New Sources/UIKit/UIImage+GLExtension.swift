//
//  UIImage+GLExtension.swift
//  SwiftTool
//
//  Created by galaxy on 2020/10/17.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    /// 颜色转图片
    public static func gl_image(color: UIColor, size: CGSize = CGSize(width: 1.0, height: 1.0)) -> UIImage? {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    /// 获取某个bundle下的图片
    public static func gl_image(bundle: Bundle?, name: String?) -> UIImage? {
        guard let name = name else { return nil }
        guard let bundle = bundle else { return nil }
        var scale = Int(UIScreen.main.scale)
        if scale < 2 {
            scale = 2
        } else if scale > 3 {
            scale = 3
        }
        let newName = "\(name)@\(scale)x"
        var image: UIImage? = nil
        if let path = bundle.path(forResource: newName, ofType: "png") { /* test@2x.png */
            image = UIImage(contentsOfFile: path)
        } else if let path = bundle.path(forResource: newName, ofType: "jpg") { /* test@2x.jpg */
            image = UIImage(contentsOfFile: path)
        } else if let path = bundle.path(forResource: newName, ofType: "jpeg") { /* test@2x.jpeg */
            image = UIImage(contentsOfFile: path)
        } else if let path = bundle.path(forResource: name, ofType: "png") { /* test.png */
            image = UIImage(contentsOfFile: path)
        } else if let path = bundle.path(forResource: name, ofType: "jpg") { /* test.jpg */
            image = UIImage(contentsOfFile: path)
        } else if let path = bundle.path(forResource: name, ofType: "jpeg") { /* test.jpeg */
            image = UIImage(contentsOfFile: path)
        } else if let path = bundle.path(forResource: name, ofType: nil) {
            image = UIImage(contentsOfFile: path)
        }
        return image
    }
}
