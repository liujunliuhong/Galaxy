//
//  SwiftyTabBar.swift
//  SwiftTool
//
//  Created by apple on 2020/6/16.
//  Copyright © 2020 yinhe. All rights reserved.
//

import UIKit

open class SwiftyTabBar: UITabBar {

    open override var items: [UITabBarItem]? {
        didSet {
            
        }
    }
    
    open override func setItems(_ items: [UITabBarItem]?, animated: Bool) {
        super.setItems(items, animated: animated)
    }
    
    open override func beginCustomizingItems(_ items: [UITabBarItem]) {
        super.beginCustomizingItems(items)
    }
    
    open override func endCustomizing(animated: Bool) -> Bool {
        return super.endCustomizing(animated: animated)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        var b = super.point(inside: point, with: event)
        return b
    }
}

extension SwiftyTabBar {
    
}
