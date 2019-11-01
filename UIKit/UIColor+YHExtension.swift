//
//  UIColor+YHExtension.swift
//  FNDating
//
//  Created by apple on 2019/8/26.
//  Copyright © 2019 yinhe. All rights reserved.
//

import Foundation
import UIKit

@objc
extension UIColor {
    public static func YH_RGBA(R: Int, G: Int, B: Int, A: CGFloat = 1) -> UIColor {
        return UIColor(red: (CGFloat(R) / 255.0), green: (CGFloat(G) / 255.0), blue: (CGFloat(B) / 255.0), alpha: A)
    }
    
    public static var YH_RandomColor: UIColor {
        let R: CGFloat = CGFloat(arc4random() % 255)
        let G: CGFloat = CGFloat(arc4random() % 255)
        let B: CGFloat = CGFloat(arc4random() % 255)
        let A: CGFloat = 1.0
        return UIColor(red: (CGFloat(R) / 255.0), green: (CGFloat(G) / 255.0), blue: (CGFloat(B) / 255.0), alpha: A)
    }
    
//    public static func YH_HexColor(hex: Int) -> UIColor {
//        return .red
//    }
//    public static func YH_HexColor(hex: String) -> UIColor {
//        return .red
//    }
}

