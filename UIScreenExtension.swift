//
//  UIScreenExtension.swift
//  SwiftTool
//
//  Created by apple on 2019/4/25.
//  Copyright © 2019 yinhe. All rights reserved.
//

import Foundation
import UIKit


extension UIScreen {
    public static func YH_Width() -> CGFloat {
        return UIScreen.main.bounds.size.width;
    }
    
    public static func YH_Height() -> CGFloat {
        return UIScreen.main.bounds.size.height;
    }
}
