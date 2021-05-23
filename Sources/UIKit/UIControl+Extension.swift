//
//  UIControl+Extension.swift
//  SwiftTool
//
//  Created by liujun on 2021/5/17.
//  Copyright © 2021 yinhe. All rights reserved.
//

import Foundation
import UIKit

private struct AssociatedKeys {
    static var top = "com.galaxy.enlarge.top"
    static var left = "com.galaxy.enlarge.left"
    static var bottom = "com.galaxy.enlarge.bottom"
    static var right = "com.galaxy.enlarge.right"
}

private func getAssociatedObject<ValueType: AnyObject>(base: AnyObject,
                                                       key: UnsafeRawPointer,
                                                       initialValue: ValueType) -> ValueType {
    if let associated = objc_getAssociatedObject(base, key) as? ValueType {
        return associated
    }
    objc_setAssociatedObject(base, key, initialValue, .OBJC_ASSOCIATION_RETAIN)
    return initialValue
}

private func setAssociateObject<ValueType: AnyObject>(base: AnyObject,
                                                      key: UnsafeRawPointer,
                                                      value: ValueType) {
    objc_setAssociatedObject(base, key, value, .OBJC_ASSOCIATION_RETAIN)
}


extension GL where Base == UIControl {
    /// 扩大点击区域(top)
    public var enlargeTop: Double  {
        set {
            setAssociateObject(base: base, key: &AssociatedKeys.top, value: NSNumber(value: newValue))
        }
        get {
            let initialValue: Double = 0.0
            return getAssociatedObject(base: base, key: &AssociatedKeys.top, initialValue: NSNumber(value: initialValue)).doubleValue
        }
    }
    
    /// 扩大点击区域(left)
    public var enlargeLeft: Double {
        set {
            setAssociateObject(base: base, key: &AssociatedKeys.left, value: NSNumber(value: newValue))
        }
        get {
            let initialValue: Double = 0.0
            return getAssociatedObject(base: base, key: &AssociatedKeys.left, initialValue: NSNumber(value: initialValue)).doubleValue
        }
    }
    
    /// 扩大点击区域(bottom)
    public var enlargeBottom: Double {
        set {
            setAssociateObject(base: base, key: &AssociatedKeys.bottom, value: NSNumber(value: newValue))
        }
        get {
            let initialValue: Double = 0.0
            return getAssociatedObject(base: base, key: &AssociatedKeys.bottom, initialValue: NSNumber(value: initialValue)).doubleValue
        }
    }
    
    /// 扩大点击区域(right)
    public var enlargeRight: Double {
        set {
            setAssociateObject(base: base, key: &AssociatedKeys.right, value: NSNumber(value: newValue))
        }
        get {
            let initialValue: Double = 0.0
            return getAssociatedObject(base: base, key: &AssociatedKeys.right, initialValue: NSNumber(value: initialValue)).doubleValue
        }
    }
    
    /// 扩大点击区域(insets)
    public var enlargeInsets: UIEdgeInsets {
        get {
            return UIEdgeInsets(top: CGFloat(enlargeTop),
                                left: CGFloat(enlargeLeft),
                                bottom: CGFloat(enlargeBottom),
                                right: CGFloat(enlargeRight))
        }
        set {
            enlargeTop = Double(newValue.top)
            enlargeLeft = Double(newValue.left)
            enlargeBottom = Double(newValue.bottom)
            enlargeRight = Double(newValue.right)
        }
    }
}

extension UIControl {
    fileprivate var enlargeRect: CGRect {
        return CGRect(x: bounds.origin.x - CGFloat(gl.enlargeLeft),
                      y: bounds.origin.y - CGFloat(gl.enlargeTop),
                      width: bounds.size.width + CGFloat(gl.enlargeLeft) + CGFloat(gl.enlargeRight),
                      height: bounds.size.height + CGFloat(gl.enlargeTop) + CGFloat(gl.enlargeBottom))
    }
}

extension UIControl {
    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if isHidden || alpha.isLessThanOrEqualTo(.zero) {
            return false
        }
        let newRect = enlargeRect
        if bounds.equalTo(newRect) {
            return super.point(inside: point, with: event)
        }
        return newRect.contains(point)
    }
}
