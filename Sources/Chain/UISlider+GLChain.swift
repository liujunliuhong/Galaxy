//
//  UISlider+GLChain.swift
//  SwiftTool
//
//  Created by Yule on 2020/12/4.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import UIKit

extension GLChain where Base: UISlider {
    
    @discardableResult
    public func value(_ value: Float) -> Self {
        self.base.value = value
        return self
    }
    
    @discardableResult
    public func minimumValue(_ minimumValue: Float) -> Self {
        self.base.minimumValue = minimumValue
        return self
    }
    
    @discardableResult
    public func maximumValue(_ maximumValue: Float) -> Self {
        self.base.maximumValue = maximumValue
        return self
    }
    
    @discardableResult
    public func minimumValueImage(_ minimumValueImage: UIImage?) -> Self {
        self.base.minimumValueImage = minimumValueImage
        return self
    }
    
    @discardableResult
    public func maximumValueImage(_ maximumValueImage: UIImage?) -> Self {
        self.base.maximumValueImage = maximumValueImage
        return self
    }
    
    @discardableResult
    public func isContinuous(_ isContinuous: Bool) -> Self {
        self.base.isContinuous = isContinuous
        return self
    }
    
    @discardableResult
    public func minimumTrackTintColor(_ minimumTrackTintColor: UIColor?) -> Self {
        self.base.minimumTrackTintColor = minimumTrackTintColor
        return self
    }
    
    @discardableResult
    public func maximumTrackTintColor(_ maximumTrackTintColor: UIColor?) -> Self {
        self.base.maximumTrackTintColor = maximumTrackTintColor
        return self
    }
    
    @discardableResult
    public func thumbTintColor(_ thumbTintColor: UIColor?) -> Self {
        self.base.thumbTintColor = thumbTintColor
        return self
    }
    
    @discardableResult
    public func setValue(_ value: Float, animated: Bool) -> Self {
        self.base.setValue(value, animated: animated)
        return self
    }
    
    @discardableResult
    public func setThumbImage(_ image: UIImage?, for state: UIControl.State) -> Self {
        self.base.setThumbImage(image, for: state)
        return self
    }
    
    @discardableResult
    public func setMinimumTrackImage(_ image: UIImage?, for state: UIControl.State) -> Self {
        self.base.setMinimumTrackImage(image, for: state)
        return self
    }
    
    @discardableResult
    public func setMaximumTrackImage(_ image: UIImage?, for state: UIControl.State) -> Self {
        self.base.setMaximumTrackImage(image, for: state)
        return self
    }
}
