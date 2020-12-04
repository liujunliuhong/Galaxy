//
//  UIControl+GLChain.swift
//  SwiftTool
//
//  Created by Yule on 2020/12/4.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import UIKit

extension GLChain where Base: UIControl {
    
    @discardableResult
    public func contentVerticalAlignment(_ contentVerticalAlignment: UIControl.ContentVerticalAlignment) -> Self {
        self.base.contentVerticalAlignment = contentVerticalAlignment
        return self
    }
    
    @discardableResult
    public func contentHorizontalAlignment(_ contentHorizontalAlignment: UIControl.ContentHorizontalAlignment) -> Self {
        self.base.contentHorizontalAlignment = contentHorizontalAlignment
        return self
    }
    
    @discardableResult
    public func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) -> Self {
        self.base.addTarget(target, action: action, for: controlEvents)
        return self
    }
}
