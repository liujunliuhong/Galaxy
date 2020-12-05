//
//  UIActivityIndicatorView+GLChain.swift
//  SwiftTool
//
//  Created by Yule on 2020/12/4.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import UIKit

extension GLChain where Base: UIActivityIndicatorView {
    @discardableResult
    public func style(_ style: UIActivityIndicatorView.Style) -> Self {
        self.base.style = style
        return self
    }
    
    @discardableResult
    public func hidesWhenStopped(_ hidesWhenStopped: Bool) -> Self {
        self.base.hidesWhenStopped = hidesWhenStopped
        return self
    }
    
    @discardableResult
    public func color(_ color: UIColor?) -> Self {
        self.base.color = color
        return self
    }
    
    @discardableResult
    public func startAnimating() -> Self {
        self.base.startAnimating()
        return self
    }
    
    @discardableResult
    public func stopAnimating() -> Self {
        self.base.stopAnimating()
        return self
    }
}
