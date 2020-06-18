//
//  SwiftyTabBar.swift
//  SwiftTool
//
//  Created by apple on 2020/6/16.
//  Copyright © 2020 yinhe. All rights reserved.
//

import UIKit

internal let baseTag: Int = 1000

public enum SwiftyTabBarItemPositioning {
    case system(position: UITabBar.ItemPositioning)
    case fillUp
}

internal protocol SwiftyTabBarDelegate: NSObjectProtocol {
    func tabBar(_ tabBar: SwiftyTabBar, shouldSelect item: UITabBarItem) -> Bool
    func tabBar(_ tabBar: SwiftyTabBar, shouldHijack item: UITabBarItem) -> Bool
    func tabBar(_ tabBar: SwiftyTabBar, didHijack item: UITabBarItem)
}


public class SwiftyTabBar: UITabBar {

    internal weak var customDelegate: SwiftyTabBarDelegate?
    internal weak var tabBarController: SwiftyTabBarController?
    internal var wrapViews: [_SwiftyTabBarItemWrapView] = []
    
    public var itemCustomPositioning: SwiftyTabBarItemPositioning? {
        didSet {
            if let p = itemCustomPositioning {
                switch p {
                case .system(let position):
                    self.itemPositioning = position
                default:
                    break
                }
            }
            self.updateDisplay()
        }
    }
    
    public var itemEdgeInsets: UIEdgeInsets = .zero
    
    public var shadowColor: UIColor? {
        didSet {
            self.setNeedsLayout()
            self.layoutIfNeeded()
            self.updateShadowColor(view: self)
        }
    }
    
    public override var items: [UITabBarItem]? {
        didSet {
            self.updateDisplay()
        }
    }
    
    public override func setItems(_ items: [UITabBarItem]?, animated: Bool) {
        super.setItems(items, animated: animated)
        self.updateDisplay()
    }
    
    public override func beginCustomizingItems(_ items: [UITabBarItem]) {
        super.beginCustomizingItems(items)
    }
    
    public override func endCustomizing(animated: Bool) -> Bool {
        return super.endCustomizing(animated: animated)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        //
        self.updateLayout()
    }
    
    public override func value(forUndefinedKey key: String) -> Any? {
        return nil
    }
    
    public override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        var b = super.point(inside: point, with: event)
        if !b {
            for v in self.wrapViews {
                if v.point(inside: CGPoint(x: point.x - v.frame.origin.x, y: point.y - v.frame.origin.y), with: event) {
                    b = true
                }
            }
        }
        return b
    }
}

fileprivate extension SwiftyTabBar {
    func updateShadowColor(view: UIView) {
        for (_, v) in view.subviews.enumerated() {
            if v.frame.height.isLessThanOrEqualTo(1.0) {
                v.backgroundColor = self.shadowColor
                if let c = self.shadowColor {
                    if c == UIColor.clear {
                        v.isHidden = true
                    } else {
                        v.isHidden = false
                    }
                } else {
                    v.isHidden = true
                }
            } else {
                if v.subviews.count > 0 {
                    self.updateShadowColor(view: v)
                }
            }
        }
    }
}

extension SwiftyTabBar {
    
    /// remove all wrapViews
    internal func removeAll() {
        for v in self.wrapViews {
            v.removeFromSuperview()
        }
        self.wrapViews.removeAll()
    }
    
    /// update display
    internal func updateDisplay() {
        //
        self.removeAll()
        //
        guard let tabBarItems = self.items else {
            return
        }
        if tabBarItems.count <= 0 {
            return
        }
        //
        for (index, item) in tabBarItems.enumerated() {
            let wrapView = _SwiftyTabBarItemWrapView(target: self, tag: baseTag + index)
            self.addSubview(wrapView)
            self.wrapViews.append(wrapView)
            
            if let item = item as? SwiftyTabBarItem, let containerView = item.containerView {
                wrapView.addSubview(containerView)
            }
        }
        //
        self.setNeedsLayout()
    }
    
    /// update layout
    internal func updateLayout() {
        //
        guard let tabBarItems = self.items else {
            return
        }
        if tabBarItems.count <= 0 {
            return
        }
        // Obtain the tabBarButton of the system. If the system is upgraded, and Apple changes the attributes or the hierarchy, the custom tabBar may fail.
        let originTabBarButtons = subviews.filter { (subView) -> Bool in
            if let cls = NSClassFromString("UITabBarButton") {
                return subView.isKind(of: cls)
            }
            return false
        }.sorted { (view1, view2) -> Bool in
            return view1.frame.origin.x < view2.frame.origin.x
        }
        //
        if originTabBarButtons.count != tabBarItems.count {
            return
        }
        if originTabBarButtons.count != self.wrapViews.count {
            return
        }
        //
        if self.isCustomizing {
            originTabBarButtons.forEach { (v) in
                v.isHidden = false
            }
            self.wrapViews.forEach { (v) in
                v.isHidden = true
            }
        } else {
            for (index, item) in tabBarItems.enumerated() {
                if let _ = item as? SwiftyTabBarItem {
                    originTabBarButtons[index].isHidden = true // If it is of type `SwiftyTabBarItem`, hide the system’s tabBarButton
                } else {
                    originTabBarButtons[index].isHidden = false // If it is the system's `UITabBarItem`, it is not hidden
                }
            }
            self.wrapViews.forEach { (v) in
                v.isHidden = false
            }
        }
        //
        if let p = self.itemCustomPositioning {
            switch p {
            case .system(_):
                for (index, w) in self.wrapViews.enumerated() {
                    w.frame = originTabBarButtons[index].frame
                }
            case .fillUp:
                var x: CGFloat = self.itemEdgeInsets.left
                let y: CGFloat = self.itemEdgeInsets.top
                
                let width = self.bounds.size.width - self.itemEdgeInsets.left - self.itemEdgeInsets.right
                let eachHeight = self.bounds.size.height - self.itemEdgeInsets.top - self.itemEdgeInsets.bottom
                let eachWidth = self.itemWidth.isLessThanOrEqualTo(.zero) ? width / CGFloat(self.wrapViews.count) : self.itemWidth
                let spacing = self.itemSpacing.isLessThanOrEqualTo(.zero) ? .zero : self.itemSpacing
                
                for v in self.wrapViews {
                    v.frame = CGRect(x: x, y: y, width: eachWidth, height: eachHeight)
                    x += eachWidth
                    x += spacing
                }
            }
        } else {
            for (index, w) in self.wrapViews.enumerated() {
                w.frame = originTabBarButtons[index].frame
            }
        }
    }
}

extension SwiftyTabBar {
    @objc internal func selectAction(_ sender: AnyObject?) {
        guard let v = sender as? _SwiftyTabBarItemWrapView else {
            return
        }
        let newIndex = max(0, v.tag - baseTag)
        self.select(itemAtIndex: newIndex, animated: true)
    }
    
     @objc internal func select(itemAtIndex index: Int, animated: Bool) {
        let newIndex = max(0, index)
        let currentIndex = (self.selectedItem != nil) ? (self.items?.firstIndex(of: self.selectedItem!) ?? -1) : -1
        guard newIndex < self.items?.count ?? 0, let item = self.items?[newIndex], item.isEnabled == true else {
            return
        }
        if (self.customDelegate?.tabBar(self, shouldSelect: item) ?? true) == false {
            return
        }
        //
        if (self.customDelegate?.tabBar(self, shouldHijack: item) ?? false) == true {
            self.customDelegate?.tabBar(self, didHijack: item)
            if animated {
                if let item = item as? SwiftyTabBarItem {
                    item.containerView?.select(animated: animated, completion: {
                        item.containerView?.deselect(animated: false, completion: nil)
                    })
                }
            }
            return
        }
        //
        if currentIndex != newIndex {
            if currentIndex >= 0 && currentIndex <= (self.items?.count ?? 0) {
                if let currentItem = self.items?[currentIndex] as? SwiftyTabBarItem {
                    currentItem.containerView?.deselect(animated: animated, completion: nil)
                }
            }
            if let item = item as? SwiftyTabBarItem {
                item.containerView?.select(animated: animated, completion: nil)
            }
        } else {
            if currentIndex >= 0 && currentIndex <= (self.items?.count ?? 0) {
                if let item = item as? SwiftyTabBarItem {
                    item.containerView?.reselect(animated: animated, completion: nil)
                }
            }
        }
        //
        self.delegate?.tabBar?(self, didSelect: item)
    }
}
