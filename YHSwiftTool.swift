//
//  YHSwiftTool.swift
//  SwiftTool
//
//  Created by apple on 2019/4/16.
//  Copyright © 2019 yinhe. All rights reserved.
//

import Foundation
import UIKit



extension UIColor {
    static public func YH_RGBA(R:Int, G:Int, B:Int, A:CGFloat = 1) -> UIColor {
        return UIColor(red: (CGFloat(R) / 255.0), green: (CGFloat(G) / 255.0), blue: (CGFloat(B) / 255.0), alpha: A)
    }
}

extension UIScreen {
    static public func YH_Width() -> CGFloat {
        return UIScreen.main.bounds.size.width;
    }
    
    static public func YH_Height() -> CGFloat {
        return UIScreen.main.bounds.size.height;
    }
}
