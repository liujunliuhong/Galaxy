//
//  YHTabBar.swift
//  FNDating
//
//  Created by apple on 2019/9/18.
//  Copyright © 2019 yinhe. All rights reserved.
//

import UIKit


protocol YHTabBarProtocol: NSObjectProtocol {
    func tabBar(_ tabBar: UITabBar, shouldSelect item: UITabBarItem) -> Bool
    func tabBar(_ tabBar: UITabBar, shouldHijack item: UITabBarItem) -> Bool
    func tabBar(_ tabBar: UITabBar, didHijack item: UITabBarItem)
}

class YHTabBar: UITabBar {
    
    weak var `protocol`: YHTabBarProtocol?
    
    weak var tabBarController: YHTabBarController?
    
    var containers: [YHTabBarItemContainer] = [YHTabBarItemContainer]()
    
    
    override var items: [UITabBarItem]? {
        didSet {
            
        }
    }
    
    override func setItems(_ items: [UITabBarItem]?, animated: Bool) {
        super.setItems(items, animated: animated)
        
    }
    
    override func beginCustomizingItems(_ items: [UITabBarItem]) {
        super.beginCustomizingItems(items)
    }
    
    override func endCustomizing(animated: Bool) -> Bool {
        return super.endCustomizing(animated: animated)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    
    
    
    
}



extension YHTabBar {
    func updateLayout() {
        guard let tabBarItems = items else {
            return
        }
        
        let originTabBarButtons = subviews.filter { (subView) -> Bool in
            if let cls = NSClassFromString("UITabBarButton") {
                return subView.isKind(of: cls)
            }
            return false
            }.sorted { (view1, view2) -> Bool in
                return view1.frame.origin.x < view2.frame.origin.x
        }
        
        if tabBarItems.count != originTabBarButtons.count {
            return
        }
        
        for (index, item) in tabBarItems.enumerated() {
            if let _ = item as? YHTabBarItem {
                originTabBarButtons[index].isHidden = true
            } else {
                originTabBarButtons[index].isHidden = false
            }
        }
        
        containers.forEach { (container) in
            container.isHidden = false
        }
        
        
        
    }
    
}
