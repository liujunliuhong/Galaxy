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
    
}
