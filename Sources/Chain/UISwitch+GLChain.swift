//
//  UISwitch+GLChain.swift
//  SwiftTool
//
//  Created by Yule on 2020/12/4.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import UIKit

extension GLChain where Base: UISwitch {
    
    @discardableResult
    public func onTintColor(_ onTintColor: UIColor?) -> Self {
        self.base.onTintColor = onTintColor
        return self
    }
    
    @discardableResult
    public func thumbTintColor(_ thumbTintColor: UIColor?) -> Self {
        self.base.thumbTintColor = thumbTintColor
        return self
    }
    
    @discardableResult
    public func onImage(_ onImage: UIImage?) -> Self {
        self.base.onImage = onImage
        return self
    }
    
    @discardableResult
    public func offImage(_ offImage: UIImage?) -> Self {
        self.base.offImage = offImage
        return self
    }
    
    @available(iOS 14.0, *)
    @discardableResult
    public func title(_ title: String?) -> Self {
        self.base.title = title
        return self
    }
    
    @available(iOS 14.0, *)
    @discardableResult
    public func preferredStyle(_ preferredStyle: UISwitch.Style) -> Self {
        self.base.preferredStyle = preferredStyle
        return self
    }
    
    @discardableResult
    public func isOn(_ isOn: Bool) -> Self {
        self.base.isOn = isOn
        return self
    }
    
    @discardableResult
    public func setOn(_ on: Bool, animated: Bool) -> Self {
        self.base.setOn(on, animated: animated)
        return self
    }
}
