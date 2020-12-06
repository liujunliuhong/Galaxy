//
//  UIRefreshControl+GLChain.swift
//  SwiftTool
//
//  Created by Yule on 2020/12/4.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import UIKit

extension GLChain where Base: UIRefreshControl {
    
    @discardableResult
    public func tintColor(_ tintColor: UIColor?) -> Self {
        self.base.tintColor = tintColor
        return self
    }
    
    @discardableResult
    public func attributedTitle(_ attributedTitle: NSAttributedString?) -> Self {
        self.base.attributedTitle = attributedTitle
        return self
    }
}
