//
//  YHTabBarItemContainer.swift
//  FNDating
//
//  Created by apple on 2019/9/19.
//  Copyright © 2019 yinhe. All rights reserved.
//

import UIKit

internal class YHTabBarItemContainer: UIControl {

    @available(iOS, unavailable)
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    init(target: AnyObject?, tag: Int) {
        super.init(frame: .zero)
        self.tag = tag
        self.addTarget(target, action: #selector(YHTabBar.selectAction(_:)), for: .touchUpInside)
        self.addTarget(target, action: #selector(YHTabBar.highlightAction(_:)), for: .touchDown)
        self.addTarget(target, action: #selector(YHTabBar.highlightAction(_:)), for: .touchDragEnter)
        self.addTarget(target, action: #selector(YHTabBar.dehighlightAction(_:)), for: .touchDragExit)
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


internal extension YHTabBarItemContainer {
    override func layoutSubviews() {
        super.layoutSubviews()
        for subView in subviews {
            if let _subView = subView as? YHTabBatItemContentView {
                let inset = _subView.insets
                _subView.frame = CGRect(x: inset.left, y: inset.top, width: bounds.size.width - inset.left - inset.right, height: bounds.size.height - inset.top - inset.bottom)
                _subView.updateLayout()
            }
        }
    }
}

extension YHTabBarItemContainer {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        var b = super.point(inside: point, with: event)
        if !b {
            for subView in subviews {
                if subView.point(inside: CGPoint(x: point.x - subView.frame.origin.x, y: point.y - subView.frame.origin.y), with: event) {
                    b = true
                }
            }
        }
        return b
    }
}
