//
//  UIView+GLChain.swift
//  SwiftTool
//
//  Created by Yule on 2020/12/4.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import UIKit

extension GLChain where Base: UIView {
    
    @discardableResult
    public func backgroundColor(_ backgroundColor: UIColor?) -> Self {
        self.base.backgroundColor = backgroundColor
        return self
    }
    
    @discardableResult
    public func isUserInteractionEnabled(_ isUserInteractionEnabled: Bool) -> Self {
        self.base.isUserInteractionEnabled = isUserInteractionEnabled
        return self
    }
    
    @discardableResult
    public func clipsToBounds(_ clipsToBounds: Bool) -> Self {
        self.base.clipsToBounds = clipsToBounds
        return self
    }
    
    @discardableResult
    public func alpha(_ alpha: CGFloat) -> Self {
        self.base.alpha = alpha
        return self
    }
    
    @discardableResult
    public func isOpaque(_ isOpaque: Bool) -> Self {
        self.base.isOpaque = isOpaque
        return self
    }
    
    @discardableResult
    public func clearsContextBeforeDrawing(_ clearsContextBeforeDrawing: Bool) -> Self {
        self.base.clearsContextBeforeDrawing = clearsContextBeforeDrawing
        return self
    }
    
    @discardableResult
    public func isHidden(_ isHidden: Bool) -> Self {
        self.base.isHidden = isHidden
        return self
    }
    
    @discardableResult
    public func contentMode(_ contentMode: UIView.ContentMode) -> Self {
        self.base.contentMode = contentMode
        return self
    }
    
    @discardableResult
    public func mask(_ mask: UIView?) -> Self {
        self.base.mask = mask
        return self
    }
    
    @discardableResult
    public func tintColor(_ tintColor: UIColor?) -> Self {
        self.base.tintColor = tintColor
        return self
    }
    
    @discardableResult
    public func tag(_ tag: Int) -> Self {
        self.base.tag = tag
        return self
    }
    
    @available(iOS 14.0, *)
    @discardableResult
    public func focusGroupIdentifier(_ focusGroupIdentifier: String?) -> Self {
        self.base.focusGroupIdentifier = focusGroupIdentifier
        return self
    }
    
    @discardableResult
    public func semanticContentAttribute(_ semanticContentAttribute: UISemanticContentAttribute) -> Self {
        self.base.semanticContentAttribute = semanticContentAttribute
        return self
    }
    
    @discardableResult
    public func frame(_ frame: CGRect) -> Self {
        self.base.frame = frame
        return self
    }
    
    @discardableResult
    public func bounds(_ bounds: CGRect) -> Self {
        self.base.bounds = bounds
        return self
    }
    
    @discardableResult
    public func center(_ center: CGPoint) -> Self {
        self.base.center = center
        return self
    }
    
    @discardableResult
    public func transform(_ transform: CGAffineTransform) -> Self {
        self.base.transform = transform
        return self
    }
    
    @available(iOS 13.0, *)
    @discardableResult
    public func transform3D(_ transform3D: CATransform3D) -> Self {
        self.base.transform3D = transform3D
        return self
    }
    
    @discardableResult
    public func contentScaleFactor(_ contentScaleFactor: CGFloat) -> Self {
        self.base.contentScaleFactor = contentScaleFactor
        return self
    }
    
    @discardableResult
    public func isMultipleTouchEnabled(_ isMultipleTouchEnabled: Bool) -> Self {
        self.base.isMultipleTouchEnabled = isMultipleTouchEnabled
        return self
    }
    
    @discardableResult
    public func isExclusiveTouch(_ isExclusiveTouch: Bool) -> Self {
        self.base.isExclusiveTouch = isExclusiveTouch
        return self
    }
    
    @discardableResult
    public func autoresizesSubviews(_ autoresizesSubviews: Bool) -> Self {
        self.base.autoresizesSubviews = autoresizesSubviews
        return self
    }
    
    @discardableResult
    public func autoresizingMask(_ autoresizingMask: UIView.AutoresizingMask) -> Self {
        self.base.autoresizingMask = autoresizingMask
        return self
    }
    
    @discardableResult
    public func layoutMargins(_ layoutMargins: UIEdgeInsets) -> Self {
        self.base.layoutMargins = layoutMargins
        return self
    }
    
    @available(iOS 11.0, *)
    @discardableResult
    public func directionalLayoutMargins(_ directionalLayoutMargins: NSDirectionalEdgeInsets) -> Self {
        self.base.directionalLayoutMargins = directionalLayoutMargins
        return self
    }
    
    @discardableResult
    public func preservesSuperviewLayoutMargins(_ preservesSuperviewLayoutMargins: Bool) -> Self {
        self.base.preservesSuperviewLayoutMargins = preservesSuperviewLayoutMargins
        return self
    }
    
    @available(iOS 11.0, *)
    @discardableResult
    public func insetsLayoutMarginsFromSafeArea(_ insetsLayoutMarginsFromSafeArea: Bool) -> Self {
        self.base.insetsLayoutMarginsFromSafeArea = insetsLayoutMarginsFromSafeArea
        return self
    }
    
    @discardableResult
    public func tintAdjustmentMode(_ tintAdjustmentMode: UIView.TintAdjustmentMode) -> Self {
        self.base.tintAdjustmentMode = tintAdjustmentMode
        return self
    }
    
    @discardableResult
    public func gestureRecognizers(_ gestureRecognizers: [UIGestureRecognizer]?) -> Self {
        self.base.gestureRecognizers = gestureRecognizers
        return self
    }
    
    @discardableResult
    public func motionEffects(_ motionEffects: [UIMotionEffect]) -> Self {
        self.base.motionEffects = motionEffects
        return self
    }
    
    @discardableResult
    public func translatesAutoresizingMaskIntoConstraints(_ translatesAutoresizingMaskIntoConstraints: Bool) -> Self {
        self.base.translatesAutoresizingMaskIntoConstraints = translatesAutoresizingMaskIntoConstraints
        return self
    }
    
    @discardableResult
    public func restorationIdentifier(_ restorationIdentifier: String?) -> Self {
        self.base.restorationIdentifier = restorationIdentifier
        return self
    }
    
    @available(iOS 13.0, *)
    @discardableResult
    public func overrideUserInterfaceStyle(_ overrideUserInterfaceStyle: UIUserInterfaceStyle) -> Self {
        self.base.overrideUserInterfaceStyle = overrideUserInterfaceStyle
        return self
    }
}
