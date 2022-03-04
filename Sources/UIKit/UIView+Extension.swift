//
//  UIView+Extension.swift
//  SwiftTool
//
//  Created by galaxy on 2021/5/16.
//  Copyright © 2021 yinhe. All rights reserved.
//

import Foundation
import UIKit

extension GL where Base: UIView {
    /// origin
    public var origin: CGPoint {
        get {
            return base.frame.origin
        }
        set {
            var frame = base.frame
            frame.origin = newValue
            base.frame = frame
        }
    }
    
    /// x
    public var x: CGFloat {
        get {
            return base.frame.origin.x
        }
        set {
            var frame = base.frame
            frame.origin.x = newValue
            base.frame = frame
        }
    }
    
    /// y
    public var y: CGFloat {
        get {
            return base.frame.origin.y
        }
        set {
            var frame = base.frame
            frame.origin.y = newValue
            base.frame = frame
        }
    }
    
    /// size
    public var size: CGSize {
        get {
            return base.frame.size
        }
        set {
            var frame = base.frame
            frame.size = newValue
            base.frame = frame
        }
    }
    
    /// width
    public var width: CGFloat {
        get {
            return base.frame.size.width
        }
        set {
            var frame = base.frame
            frame.size.width = newValue
            base.frame = frame
        }
    }
    
    /// height
    public var height: CGFloat {
        get {
            return base.frame.size.height
        }
        set {
            var frame = base.frame
            frame.size.height = newValue
            base.frame = frame
        }
    }
    
    /// center
    public var center: CGPoint {
        get {
            return base.center
        }
        set {
            base.center = newValue
        }
    }
    
    /// center x
    public var centerX: CGFloat {
        get {
            return base.center.x
        }
        set {
            base.center = CGPoint(x: newValue, y: base.center.y)
        }
    }
    
    /// center y
    public var centerY: CGFloat {
        get {
            return base.center.y
        }
        set {
            base.center = CGPoint(x: base.center.x, y: newValue)
        }
    }
    
    /// top
    public var top: CGFloat {
        get {
            return base.frame.origin.y
        }
        set {
            var frame = base.frame
            frame.origin.y = newValue
            base.frame = frame
        }
    }
    
    /// bottom
    public var bottom: CGFloat {
        get {
            return base.frame.origin.y + base.frame.size.height
        }
        set {
            var frame = base.frame
            frame.origin.y = newValue - base.frame.size.height
            base.frame = frame
        }
    }
    
    /// left
    public var left: CGFloat {
        get {
            return base.frame.origin.x
        }
        set {
            var frame = base.frame
            frame.origin.x = newValue
            base.frame = frame
        }
    }
    
    /// right
    public var right: CGFloat {
        get {
            return base.frame.origin.x + base.frame.size.width
        }
        set {
            var frame = base.frame
            frame.origin.x = newValue - base.frame.size.width
            base.frame = frame
        }
    }
}

extension GL where Base: UIView {
    /// 对一个`View`的指定`Rect`截图
    public func snapshot(targetRect: CGRect?) -> UIImage? {
        // Setting the screen magnification can guarantee the quality of screenshots
        let scale: CGFloat = UIScreen.main.scale
        //
        var targetRect = targetRect ?? base.bounds
        targetRect = CGRect(x: targetRect.origin.x * scale, y: targetRect.origin.y * scale, width: targetRect.width * scale, height: targetRect.height * scale)
        //
        UIGraphicsBeginImageContextWithOptions(base.bounds.size, true, scale)
        defer { UIGraphicsEndImageContext() }
        // This code cannot be written in front of `UIGraphicsBeginImageContextWithOptions`.
        // Otherwise `context` is nil.
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        base.layer.render(in: context)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        guard let cgImage = image.cgImage?.cropping(to: targetRect) else { return nil }
        return UIImage(cgImage: cgImage)
    }
    
    
    /// 获取某一点颜色
    public func toColor(point: CGPoint) -> UIColor {
        var pixel = [UInt8](repeatElement(0, count: 4))
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(
            data: &pixel,
            width: 1,
            height: 1,
            bitsPerComponent: 8,
            bytesPerRow: 4,
            space: colorSpace,
            bitmapInfo: bitmapInfo.rawValue
        )
        guard let temp = context else {
            return .clear
        }
        
        temp.translateBy(x: -point.x, y: -point.y)
        
        base.layer.render(in: temp)
        
        let r = pixel[0]
        let g = pixel[1]
        let b = pixel[2]
        let a = pixel[3]
        
        return GL<UIColor>.rgba(R: CGFloat(r), G: CGFloat(g), B: CGFloat(b), A: CGFloat(a))
    }
}

extension GL where Base: UIView {
    public static func loadNib(bundle: Bundle = .main) -> UINib {
        return UINib(nibName: String(describing: Base.self), bundle: bundle)
    }
    
    public static func loadViewFromNib(bundle: Bundle = .main) -> Base {
        return bundle.loadNibNamed(String(describing: Base.self), owner: nil, options: nil)?.first as! Base
    }
}
