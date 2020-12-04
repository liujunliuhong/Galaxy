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
    
    public var layer: GLChain<CALayer> {
        objc_setAssociatedObject(self.base.layer, &Keys.view_layer_key, self, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return GLChain<CALayer>(self.base.layer)
    }
    
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
    public func tintAdjustmentMode(_ tintAdjustmentMode: UIView.TintAdjustmentMode) -> Self {
        self.base.tintAdjustmentMode = tintAdjustmentMode
        return self
    }
}
