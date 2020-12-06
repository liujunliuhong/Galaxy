//
//  UIProgressView+GLChain.swift
//  SwiftTool
//
//  Created by Yule on 2020/12/4.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import UIKit

extension GLChain where Base: UIProgressView {
    
    @discardableResult
    public func progressViewStyle(_ progressViewStyle: UIProgressView.Style) -> Self {
        self.base.progressViewStyle = progressViewStyle
        return self
    }
    
    @discardableResult
    public func progress(_ progress: Float) -> Self {
        self.base.progress = progress
        return self
    }
    
    @discardableResult
    public func progressTintColor(_ progressTintColor: UIColor?) -> Self {
        self.base.progressTintColor = progressTintColor
        return self
    }
    
    @discardableResult
    public func trackTintColor(_ trackTintColor: UIColor?) -> Self {
        self.base.trackTintColor = trackTintColor
        return self
    }
    
    @discardableResult
    public func progressImage(_ progressImage: UIImage?) -> Self {
        self.base.progressImage = progressImage
        return self
    }
    
    @discardableResult
    public func trackImage(_ trackImage: UIImage?) -> Self {
        self.base.trackImage = trackImage
        return self
    }
    
    @discardableResult
    public func observedProgress(_ observedProgress: Progress?) -> Self {
        self.base.observedProgress = observedProgress
        return self
    }
}
