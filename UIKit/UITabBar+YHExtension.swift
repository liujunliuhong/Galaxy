//
//  UITabBar+YHExtension.swift
//  FNDating
//
//  Created by apple on 2019/9/25.
//  Copyright © 2019 yinhe. All rights reserved.
//

import Foundation
import UIKit

// 参考了QMUI
extension UITabBar {
    
    func yh_backgroundView() -> UIView? {
        if #available(iOS 10.0, *) {
            return value(forKey: "_backgroundView") as? UIView
        }
        return value(forKey: "_UITabBarBackgroundView") as? UIView
    }
    
    func yh_shadowImageView() -> UIImageView? {
        if #available(iOS 13, *) {
            // 13.0之后
            var shadowImageView = self.yh_backgroundView()?.value(forKey: "_shadowView1") as? UIImageView
            if shadowImageView == nil {
                setNeedsLayout()
                layoutIfNeeded()
                shadowImageView = self.yh_backgroundView()?.value(forKey: "_shadowView1") as? UIImageView
            }
            return shadowImageView
        } else if #available(iOS 10, *) {
            // 10.0 - 13.0
            var shadowImageView = self.yh_backgroundView()?.value(forKey: "_shadowView") as? UIImageView
            if shadowImageView == nil {
                setNeedsLayout()
                layoutIfNeeded()
                shadowImageView = self.yh_backgroundView()?.value(forKey: "_shadowView") as? UIImageView
            }
            return shadowImageView
        } else {
            // 10.0以前
            var shadowImageView = value(forKey: "_shadowView")
            if shadowImageView == nil {
                setNeedsLayout()
                layoutIfNeeded()
                shadowImageView = value(forKey: "_shadowView")
            }
            return shadowImageView as? UIImageView
        }
    }
}

