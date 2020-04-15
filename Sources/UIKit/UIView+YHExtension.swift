//
//  UIView+YHExtension.swift
//  FNDating
//
//  Created by apple on 2019/8/26.
//  Copyright © 2019 yinhe. All rights reserved.
//

import Foundation
import UIKit

@objc public extension UIView {
    var YH_Origin: CGPoint {
        get {
            return self.frame.origin
        }
        set {
            var frame = self.frame
            frame.origin = newValue
            self.frame = frame
        }
    }
    
    var YH_X: CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
    }
    
    var YH_Y: CGFloat {
        get {
            return self.frame.origin.y
        }
        set {
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
    }
    
    var YH_Size: CGSize {
        get {
            return self.frame.size
        }
        set {
            var frame = self.frame
            frame.size = newValue
            self.frame = frame
        }
    }
    
    var YH_Width: CGFloat {
        get {
            return self.frame.size.width
        }
        set {
            var frame = self.frame
            frame.size.width = newValue
            self.frame = frame
        }
    }
    
    var YH_Height: CGFloat {
        get {
            return self.frame.size.height
        }
        set {
            var frame = self.frame
            frame.size.height = newValue
            self.frame = frame
        }
    }
    
    var YH_Center: CGPoint {
        get {
            return self.center
        }
        set {
            self.center = newValue
        }
    }
    
    var YH_CenterX: CGFloat {
        get {
            return self.center.x
        }
        set {
            self.center = CGPoint(x: newValue, y: self.center.y)
        }
    }
    
    var YH_CenterY: CGFloat {
        get {
            return self.center.y
        }
        set {
            self.center = CGPoint(x: self.center.x, y: newValue)
        }
    }
    
    var YH_Top: CGFloat {
        get {
            return self.frame.origin.y
        }
        set {
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
    }
    
    var YH_Bottom: CGFloat {
        get {
            return self.frame.origin.y + self.frame.size.height
        }
        set {
            var frame = self.frame
            frame.origin.y = newValue - self.frame.size.height
            self.frame = frame
        }
    }
    
    var YH_Left: CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
    }
    
    var YH_Right: CGFloat {
        get {
            return self.frame.origin.x + self.frame.size.width
        }
        set {
            var frame = self.frame
            frame.origin.x = newValue - self.frame.size.width
            self.frame = frame
        }
    }
}


public extension UIView {
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        YHDebugLog("[KVC报错] [value: \(String(describing: value))] [key: \(key)]")
    }
    
    override func value(forUndefinedKey key: String) -> Any? {
        YHDebugLog("[KVC报错] [key: \(key)]")
        return nil
    }
}


public extension UIView {
    /// 截取view指定区域
    /// - Parameter targetRect: 指定区域被裁剪
    func yh_snapshot(targetRect: CGRect) -> UIImage? {
        let scale: CGFloat = UIScreen.main.scale // 设置屏幕倍率可以保证截图的质量
        UIGraphicsBeginImageContextWithOptions(self.frame.size, true, scale)
        guard let context = UIGraphicsGetCurrentContext() else { // 这段代码不能写在`UIGraphicsBeginImageContextWithOptions`的前面，否则`context`为nil
            return nil
        }
        self.layer.render(in: context)
        defer {
            UIGraphicsEndImageContext()
        }
        let targetRect = CGRect(x: targetRect.origin.x * scale, y: targetRect.origin.y * scale, width: targetRect.width * scale, height: targetRect.height * scale)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        guard let cgImage = image.cgImage?.cropping(to: targetRect) else {
            return nil
        }
        return UIImage(cgImage: cgImage)
    }
}
