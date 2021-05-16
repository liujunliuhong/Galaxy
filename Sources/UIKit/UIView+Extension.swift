//
//  UIView+Extension.swift
//  SwiftTool
//
//  Created by galaxy on 2021/5/16.
//  Copyright © 2021 yinhe. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    /// origin
    public var gl_origin: CGPoint {
        get {
            return self.frame.origin
        }
        set {
            var frame = self.frame
            frame.origin = newValue
            self.frame = frame
        }
    }
    
    /// x
    public var gl_x: CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
    }
    
    /// y
    public var gl_y: CGFloat {
        get {
            return self.frame.origin.y
        }
        set {
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
    }
    
    /// size
    public var gl_size: CGSize {
        get {
            return self.frame.size
        }
        set {
            var frame = self.frame
            frame.size = newValue
            self.frame = frame
        }
    }
    
    /// width
    public var gl_width: CGFloat {
        get {
            return self.frame.size.width
        }
        set {
            var frame = self.frame
            frame.size.width = newValue
            self.frame = frame
        }
    }
    
    /// height
    public var gl_height: CGFloat {
        get {
            return self.frame.size.height
        }
        set {
            var frame = self.frame
            frame.size.height = newValue
            self.frame = frame
        }
    }
    
    /// center
    public var gl_center: CGPoint {
        get {
            return self.center
        }
        set {
            self.center = newValue
        }
    }
    
    /// center x
    public var gl_centerX: CGFloat {
        get {
            return self.center.x
        }
        set {
            self.center = CGPoint(x: newValue, y: self.center.y)
        }
    }
    
    /// center y
    public var gl_centerY: CGFloat {
        get {
            return self.center.y
        }
        set {
            self.center = CGPoint(x: self.center.x, y: newValue)
        }
    }
    
    /// top
    public var gl_top: CGFloat {
        get {
            return self.frame.origin.y
        }
        set {
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
    }
    
    /// bottom
    public var gl_bottom: CGFloat {
        get {
            return self.frame.origin.y + self.frame.size.height
        }
        set {
            var frame = self.frame
            frame.origin.y = newValue - self.frame.size.height
            self.frame = frame
        }
    }
    
    /// left
    public var gl_left: CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
    }
    
    /// right
    public var gl_right: CGFloat {
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

extension UIView {
    /// 对一个`View`的指定`Rect`截图
    public func gl_snapshot(targetRect: CGRect?) -> UIImage? {
        // Setting the screen magnification can guarantee the quality of screenshots
        let scale: CGFloat = UIScreen.main.scale
        //
        var targetRect = targetRect ?? self.frame
        targetRect = CGRect(x: targetRect.origin.x * scale, y: targetRect.origin.y * scale, width: targetRect.width * scale, height: targetRect.height * scale)
        //
        UIGraphicsBeginImageContextWithOptions(self.frame.size, true, scale)
        // This code cannot be written in front of `UIGraphicsBeginImageContextWithOptions`.
        // Otherwise `context` is nil.
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        self.layer.render(in: context)
        defer {
            UIGraphicsEndImageContext()
        }
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        guard let cgImage = image.cgImage?.cropping(to: targetRect) else {
            return nil
        }
        return UIImage(cgImage: cgImage)
    }
}
