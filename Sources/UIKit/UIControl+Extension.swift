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


extension UIControl {
    /// 扩大点击区域(top)
    public var gl_enlarge_top: Double  {
        set {
            setAssociateObject(base: self, key: &AssociatedKeys.top, value: NSNumber(value: newValue))
        }
        get {
            let initialValue: Double = 0.0
            return getAssociatedObject(base: self, key: &AssociatedKeys.top, initialValue: NSNumber(value: initialValue)).doubleValue
        }
    }
    
    /// 扩大点击区域(left)
    public var gl_enlarge_left: Double {
        set {
            setAssociateObject(base: self, key: &AssociatedKeys.left, value: NSNumber(value: newValue))
        }
        get {
            let initialValue: Double = 0.0
            return getAssociatedObject(base: self, key: &AssociatedKeys.left, initialValue: NSNumber(value: initialValue)).doubleValue
        }
    }
    
    /// 扩大点击区域(bottom)
    public var gl_enlarge_bottom: Double {
        set {
            setAssociateObject(base: self, key: &AssociatedKeys.bottom, value: NSNumber(value: newValue))
        }
        get {
            let initialValue: Double = 0.0
            return getAssociatedObject(base: self, key: &AssociatedKeys.bottom, initialValue: NSNumber(value: initialValue)).doubleValue
        }
    }
    
    /// 扩大点击区域(right)
    public var gl_enlarge_right: Double {
        set {
            setAssociateObject(base: self, key: &AssociatedKeys.right, value: NSNumber(value: newValue))
        }
        get {
            let initialValue: Double = 0.0
            return getAssociatedObject(base: self, key: &AssociatedKeys.right, initialValue: NSNumber(value: initialValue)).doubleValue
        }
    }
    
    /// 扩大点击区域(insets)
    public var gl_enlarge_insets: UIEdgeInsets {
        get {
            let top = gl_enlarge_top
            let bottom = gl_enlarge_bottom
            let left = gl_enlarge_left
            let right = gl_enlarge_right
            return UIEdgeInsets(top: CGFloat(top), left: CGFloat(left), bottom: CGFloat(bottom), right: CGFloat(right))
        }
        set {
            self.gl_enlarge_top = Double(newValue.top)
            self.gl_enlarge_left = Double(newValue.left)
            self.gl_enlarge_bottom = Double(newValue.bottom)
            self.gl_enlarge_right = Double(newValue.right)
        }
    }
}

extension UIControl {
    fileprivate var enlargeRect: CGRect {
        let top = gl_enlarge_top
        let bottom = gl_enlarge_bottom
        let left = gl_enlarge_left
        let right = gl_enlarge_right
        return CGRect(x: bounds.origin.x - CGFloat(left),
                      y: bounds.origin.y - CGFloat(top),
                      width: bounds.size.width + CGFloat(left) + CGFloat(right),
                      height: bounds.size.height + CGFloat(top) + CGFloat(bottom))
    }
}

extension UIControl {
    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if self.isHidden || self.alpha.isLessThanOrEqualTo(.zero) {
            return false
        }
        let newRect = self.enlargeRect
        if self.bounds.equalTo(newRect) {
            return super.point(inside: point, with: event)
        }
        return newRect.contains(point)
    }
}
