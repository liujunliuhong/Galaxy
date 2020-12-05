//
//  UIButton+GLChain.swift
//  SwiftTool
//
//  Created by Yule on 2020/12/4.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import UIKit

extension GLChain where Base: UIButton {
    
    @discardableResult
    public func setTitle(_ title: String?, for state: UIControl.State) -> Self {
        self.base.setTitle(title, for: state)
        return self
    }
    
    @discardableResult
    public func setTitleColor(_ color: UIColor?, for state: UIControl.State) -> Self {
        self.base.setTitleColor(color, for: state)
        return self
    }
    
    @discardableResult
    public func contentEdgeInsets(_ contentEdgeInsets: UIEdgeInsets) -> Self {
        self.base.contentEdgeInsets = contentEdgeInsets
        return self
    }
    
    @discardableResult
    public func titleEdgeInsets(_ titleEdgeInsets: UIEdgeInsets) -> Self {
        self.base.titleEdgeInsets = titleEdgeInsets
        return self
    }
    
    @discardableResult
    public func reversesTitleShadowWhenHighlighted(_ reversesTitleShadowWhenHighlighted: Bool) -> Self {
        self.base.reversesTitleShadowWhenHighlighted = reversesTitleShadowWhenHighlighted
        return self
    }
    
    @discardableResult
    public func imageEdgeInsets(_ imageEdgeInsets: UIEdgeInsets) -> Self {
        self.base.imageEdgeInsets = imageEdgeInsets
        return self
    }
    
    @discardableResult
    public func adjustsImageWhenHighlighted(_ adjustsImageWhenHighlighted: Bool) -> Self {
        self.base.adjustsImageWhenHighlighted = adjustsImageWhenHighlighted
        return self
    }
    
    @discardableResult
    public func adjustsImageWhenDisabled(_ adjustsImageWhenDisabled: Bool) -> Self {
        self.base.adjustsImageWhenDisabled = adjustsImageWhenDisabled
        return self
    }
    
    @discardableResult
    public func showsTouchWhenHighlighted(_ showsTouchWhenHighlighted: Bool) -> Self {
        self.base.showsTouchWhenHighlighted = showsTouchWhenHighlighted
        return self
    }
    
    @discardableResult
    public func tintColor(_ tintColor: UIColor?) -> Self {
        self.base.tintColor = tintColor
        return self
    }
    
    @available(iOS 14.0, *)
    @discardableResult
    public func role(_ role: UIButton.Role) -> Self {
        self.base.role = role
        return self
    }
    
    @available(iOS 13.4, *)
    @discardableResult
    public func isPointerInteractionEnabled(_ isPointerInteractionEnabled: Bool) -> Self {
        self.base.isPointerInteractionEnabled = isPointerInteractionEnabled
        return self
    }
    
    @available(iOS 14.0, *)
    @discardableResult
    public func menu(_ menu: UIMenu?) -> Self {
        self.base.menu = menu
        return self
    }
    
    @discardableResult
    public func setTitleShadowColor(_ color: UIColor?, for state: UIControl.State) -> Self {
        self.base.setTitleShadowColor(color, for: state)
        return self
    }
    
    @discardableResult
    public func setImage(_ image: UIImage?, for state: UIControl.State) -> Self {
        self.base.setImage(image, for: state)
        return self
    }
    
    @discardableResult
    public func setBackgroundImage(_ image: UIImage?, for state: UIControl.State) -> Self {
        self.base.setBackgroundImage(image, for: state)
        return self
    }
    
    @available(iOS 13.0, *)
    @discardableResult
    public func setPreferredSymbolConfiguration(_ configuration: UIImage.SymbolConfiguration?, forImageIn state: UIControl.State) -> Self {
        self.base.setPreferredSymbolConfiguration(configuration, forImageIn: state)
        return self
    }
    
    @discardableResult
    public func setAttributedTitle(_ title: NSAttributedString?, for state: UIControl.State) -> Self {
        self.base.setAttributedTitle(title, for: state)
        return self
    }
    
    @available(iOS 13.4, *)
    @discardableResult
    public func pointerStyleProvider(_ pointerStyleProvider: UIButton.PointerStyleProvider?) -> Self {
        self.base.pointerStyleProvider = pointerStyleProvider
        return self
    }
}
