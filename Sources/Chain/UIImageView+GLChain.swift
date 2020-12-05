//
//  UIImageView+GLChain.swift
//  SwiftTool
//
//  Created by Yule on 2020/12/4.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import UIKit

extension GLChain where Base: UIImageView {
    
    @discardableResult
    public func image(_ image: UIImage?) -> Self {
        self.base.image = image
        return self
    }
    
    @discardableResult
    public func highlightedImage(_ highlightedImage: UIImage?) -> Self {
        self.base.highlightedImage = highlightedImage
        return self
    }
    
    @available(iOS 13.0, *)
    @discardableResult
    public func preferredSymbolConfiguration(_ preferredSymbolConfiguration: UIImage.SymbolConfiguration?) -> Self {
        self.base.preferredSymbolConfiguration = preferredSymbolConfiguration
        return self
    }
    
    @discardableResult
    public func isUserInteractionEnabled(_ isUserInteractionEnabled: Bool) -> Self {
        self.base.isUserInteractionEnabled = isUserInteractionEnabled
        return self
    }
    
    @discardableResult
    public func isHighlighted(_ isHighlighted: Bool) -> Self {
        self.base.isHighlighted = isHighlighted
        return self
    }
    
    @discardableResult
    public func animationImages(_ animationImages: [UIImage]?) -> Self {
        self.base.animationImages = animationImages
        return self
    }
    
    @discardableResult
    public func highlightedAnimationImages(_ highlightedAnimationImages: [UIImage]?) -> Self {
        self.base.highlightedAnimationImages = highlightedAnimationImages
        return self
    }
    
    @discardableResult
    public func animationDuration(_ animationDuration: TimeInterval) -> Self {
        self.base.animationDuration = animationDuration
        return self
    }
    
    @discardableResult
    public func animationRepeatCount(_ animationRepeatCount: Int) -> Self {
        self.base.animationRepeatCount = animationRepeatCount
        return self
    }
    
    @discardableResult
    public func tintColor(_ tintColor: UIColor?) -> Self {
        self.base.tintColor = tintColor
        return self
    }
}
