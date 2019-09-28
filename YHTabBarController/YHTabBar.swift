//
//  YHTabBar.swift
//  FNDating
//
//  Created by apple on 2019/9/18.
//  Copyright © 2019 yinhe. All rights reserved.
//

import UIKit


protocol YHTabBarProtocol: NSObjectProtocol {
    func tabBar(_ tabBar: UITabBar, shouldSelect item: UITabBarItem, index: Int) -> Bool
    func tabBar(_ tabBar: UITabBar, shouldHijack item: UITabBarItem, index: Int) -> Bool
    func tabBar(_ tabBar: UITabBar, didHijack item: UITabBarItem, index: Int)
}

open class YHTabBar: UITabBar {
    
    private let baseTag: Int = 1000
    
    /// 填充方式。在系统的基础上新增加了fillUp模式
    public enum YHTabBarItemPosition {
        case automatic
        case fill
        case centered
        case fillUp
    }
    
    internal weak var `protocol`: YHTabBarProtocol?
    
    internal weak var tabBarController: YHTabBarController?
    
    internal var containers: [YHTabBarItemContainer] = [YHTabBarItemContainer]()
    
    
    /// 当设置为fillUp时，最好设置下contentView的insets属性，否则在iPhone X系列手机上图标文字的具体过大
    open var itemCustomPositioning: YHTabBar.YHTabBarItemPosition? {
        didSet {
            if let _itemCustomPositioning = itemCustomPositioning {
                switch _itemCustomPositioning {
                case .automatic:
                    itemPositioning = .automatic
                case .fill:
                    itemPositioning = .fill
                case .centered:
                    itemPositioning = .centered
                default:
                    break
                }
            }
        }
    }
    
    
    /// 偏移量，影响的是每个item对应的container的偏移量
    open var insets: UIEdgeInsets = UIEdgeInsets.zero {
        didSet {
            reload()
        }
    }
    
    open override var items: [UITabBarItem]? {
        didSet {
            reload()
        }
    }
    
    
    /// 阴影颜色
    open var shadowColor: UIColor? {
        didSet {
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    // 是否隐藏阴影
    open var hideShadowImage: Bool = false {
        didSet {
            self.yh_shadowImageView()?.isHidden = hideShadowImage
            
        }
    }
    
    
    open override func setItems(_ items: [UITabBarItem]?, animated: Bool) {
        super.setItems(items, animated: animated)
        reload()
        
    }
    
    open override func beginCustomizingItems(_ items: [UITabBarItem]) {
        super.beginCustomizingItems(items)
    }
    
    open override func endCustomizing(animated: Bool) -> Bool {
        return super.endCustomizing(animated: animated)
    }
}

extension YHTabBar {
    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        var b = super.point(inside: point, with: event)
        if !b {
            for container in containers {
                if container.point(inside: CGPoint(x: point.x - container.frame.origin.x, y: point.y - container.frame.origin.y), with: event) {
                    b = true
                }
            }
        }
        return b
    }
}

extension YHTabBar {
    open override func layoutSubviews() {
        super.layoutSubviews()
        updateLayout()
        
        if let _shadowColor = shadowColor {
            self.yh_shadowImageView()?.backgroundColor = _shadowColor
        }
        
//        subviews.forEach { (view) in
//            if NSStringFromClass(view.classForCoder) == "_UIBarBackground" {
//                view.subviews.forEach { (v) in
//                    print(v)
//                    if let imageView = v as? UIImageView {
//                        imageView.backgroundColor = shadowColor
//                    }
//                }
//            }
//        }
    }
}


extension YHTabBar {
    /// 布局
    internal func updateLayout() {
        guard let _items = items else {
            return
        }
        
        // 获取系统的tabBarButton(核心，如果系统升级，苹果把属性已改或者层级结构一改，那么自定义tabBar可能会失效)
        let originTabBarButtons = subviews.filter { (subView) -> Bool in
            if let cls = NSClassFromString("UITabBarButton") {
                return subView.isKind(of: cls)
            }
            return false
            }.sorted { (view1, view2) -> Bool in
                return view1.frame.origin.x < view2.frame.origin.x
        }
        
        // 做个判断
        if _items.count != originTabBarButtons.count {
            return
        }
        if containers.count != originTabBarButtons.count {
            return
        }
        
        // 判断
        if isCustomizing {
            originTabBarButtons.forEach { (view) in
                view.isHidden = true
            }
            containers.forEach { (container) in
                container.isHidden = true
            }
        } else {
            for (index, item) in _items.enumerated() {
                if let _ = item as? YHTabBarItem {
                    originTabBarButtons[index].isHidden = true // 如果是`YHTabBarItem`类型的，则把系统的tabBar隐藏掉
                } else {
                    originTabBarButtons[index].isHidden = false // 如果是系统的`UITabBarItem`，则不隐藏
                }
            }
            containers.forEach { (container) in
                container.isHidden = false
            }
        }
        
        // 布局规则判断
        var layoutBaseSystem: Bool = true
        if let _itemCustomPositioning = itemCustomPositioning {
            switch _itemCustomPositioning {
            case .fillUp:
                layoutBaseSystem = false
            default:
                break
            }
        }
        
        
        // 布局container
        if layoutBaseSystem {
            // 如果按照系统原生的tabBarButton布局
            for (index, container) in containers.enumerated() {
                container.frame = originTabBarButtons[index].frame
            }
        } else {
            // 自定义布局
            var x: CGFloat = insets.left
            let y: CGFloat = insets.top
            
            let width = bounds.size.width - insets.left - insets.right
            let itemHeight = bounds.size.height - insets.top - insets.bottom
            let _itemWidth = itemWidth == 0.0 ? width / CGFloat(containers.count) : itemWidth
            let spacing = itemSpacing == 0.0 ? 0.0 : itemSpacing
            
            for container in containers {
                container.frame = CGRect(x: x, y: y, width: _itemWidth, height: itemHeight)
                x += _itemWidth
                x += spacing
            }
        }
    }
}


extension YHTabBar {
    /// 移除tabBar所有`YHTabBarItemContainer`视图
    internal func removeAll() {
        containers.forEach { (container) in
            container.removeFromSuperview()
        }
        containers.removeAll()
    }
    
    /// 刷新视图
    internal func reload() {
        removeAll()
        
        guard let _items = items else {
            return
        }
        
        for (index, item) in _items.enumerated() {
            let container = YHTabBarItemContainer(target: self, tag: baseTag + index)
            addSubview(container)
            containers.append(container)
            
            if let _item = item as? YHTabBarItem, let contentView = _item.contentView {
                container.addSubview(contentView)
            }
        }
        setNeedsLayout()
    }
}


extension YHTabBar {
    @objc func highlightAction(_ sender: AnyObject?) {
        guard let container = sender as? YHTabBarItemContainer else {
            return
        }
        
        guard let _items = items else {
            return
        }
        
        if _items.count <= 0 {
            return
        }
        
        let index = max(0, container.tag - baseTag)
        
        if index > _items.count - 1 {
            return
        }
        
        let item = _items[index]
        
        if (self.protocol?.tabBar(self, shouldSelect: item, index: index) ?? true) == false {
            return
        }
        
        if let _item = item as? YHTabBarItem {
            _item.contentView?.highlight(animation: true, completion: nil)
        }
    }
    
    @objc func dehighlightAction(_ sender: AnyObject?) {
        guard let container = sender as? YHTabBarItemContainer else {
            return
        }
        guard let _items = items else {
            return
        }
        
        if _items.count <= 0 {
            return
        }
        
        let index = max(0, container.tag - baseTag)
        
        if index > _items.count - 1 {
            return
        }
        
        let item = _items[index]
        
        if (self.protocol?.tabBar(self, shouldSelect: item, index: index) ?? true) == false {
            return
        }
        
        if let _item = item as? YHTabBarItem {
            _item.contentView?.dehighlight(animation: true, completion: nil)
        }
    }
    
    @objc func selectAction(_ sender: AnyObject?) {
        guard let container = sender as? YHTabBarItemContainer else {
            return
        }
        
        let index = max(0, container.tag - baseTag)
        
        select(itemAtIndex: index, animation: true)
    }
}

extension YHTabBar {
    @objc func select(itemAtIndex index: Int, animation: Bool) {
        
        guard let _items = items else {
            return
        }
        
        if _items.count <= 0 {
            return
        }
        
        var newIndex = max(0, index)
        if newIndex > _items.count - 1 {
            newIndex = _items.count - 1
        }
        
        let newItem = _items[newIndex]
        
        if !newItem.isEnabled {
            return
        }
        
        let currentIndex = (selectedItem != nil) ? (_items.firstIndex(of: selectedItem!) ?? -1) : -1
        
        if (self.protocol?.tabBar(self, shouldSelect: newItem, index: newIndex) ?? true) == false {
            return
        }
        
        if (self.protocol?.tabBar(self, shouldHijack: newItem, index: newIndex) ?? false) == true {
            self.protocol?.tabBar(self, didHijack: newItem, index: newIndex)
            if animation {
                if let _item = newItem as? YHTabBarItem {
                    _item.contentView?.select(animation: animation, completion: {
                        _item.contentView?.deselect(animation: false, completion: nil)
                    })
                }
            }
            return
        }
        
        if currentIndex != newIndex {
            if currentIndex >= 0 && currentIndex <= _items.count {
                if let currentItem = _items[currentIndex] as? YHTabBarItem {
                    currentItem.contentView?.deselect(animation: animation, completion: nil) // 取消选中当前的item
                }
            }
            
            if let _newItem = newItem as? YHTabBarItem {
                _newItem.contentView?.select(animation: animation, completion: nil) // 选中将要选中的item
            }
            
        } else if currentIndex == newIndex {
            if currentIndex >= 0 && currentIndex <= _items.count {
                if let currentItem = _items[currentIndex] as? YHTabBarItem {
                    currentItem.contentView?.reselect(animation: animation, completion: nil)
                }
            }
        }
        
        delegate?.tabBar?(self, didSelect: newItem)
    }
}
