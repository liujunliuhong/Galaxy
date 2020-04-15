//
//  YHTabBarController.swift
//  FNDating
//
//  Created by apple on 2019/9/18.
//  Copyright © 2019 yinhe. All rights reserved.
//

import UIKit


/// 是否需要自定义点击事件回调类型
public typealias YHTabBarControllerShouldHijackHandler = ((_ tabBarController: UITabBarController, _ viewController: UIViewController, _ index: Int) -> (Bool))
/// 自定义点击事件的回调
public typealias YHTabBarControllerDidHijackHandler = ((_ tabBarController: UITabBarController, _ viewController: UIViewController, _ index: Int) -> (Void))


@objc
open class YHTabBarController: UITabBarController {
    
    open var shouldHijackHandler: YHTabBarControllerShouldHijackHandler?
    open var didHijackHandler: YHTabBarControllerDidHijackHandler?
    
    private var flag = false
    
    open override var selectedViewController: UIViewController? {
        willSet {
            guard let _newValue = newValue else {
                return
            }
            
            if flag {
                flag = false
                return
            }
            
            guard let _tabBar = self.tabBar as? YHTabBar, let _ = _tabBar.items, let index = viewControllers?.firstIndex(of: _newValue) else {
                return
            }
            
            _tabBar.select(itemAtIndex: index, animation: false)
        }
    }
    
    open override var selectedIndex: Int {
        willSet {
            if flag {
                flag = false
                return
            }
            guard let _tabBar = self.tabBar as? YHTabBar, let _ = _tabBar.items else {
                return
            }
            _tabBar.select(itemAtIndex: newValue, animation: false)
        }
    }
    
    open override var viewControllers: [UIViewController]? {
        didSet {
            if let _viewControllers = viewControllers, _viewControllers.count > 5 {
                fatalError("items数组数量不能超过5个") // 超过5个报错，到目前为止，我还没有见过超过5个Item的应用，况且苹果也会拒绝超过5个Item的应用
            }
            super.viewControllers = viewControllers
        }
    }

    open override func viewDidLoad() {
        super.viewDidLoad()

        let tabBar = YHTabBar()
        tabBar.delegate = self
        tabBar.protocol = self
        tabBar.tabBarController = self
        
        // 核心
        setValue(tabBar, forKey: "tabBar")
    }
}

extension YHTabBarController {
    open override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let idx = tabBar.items?.firstIndex(of: item) else {
            return;
        }
        if let vc = viewControllers?[idx] {
            flag = true
            selectedIndex = idx // 此处会调用set方法，因此把flag设置为YES，否则会造成死循环
            flag = false // 重置
            delegate?.tabBarController?(self, didSelect: vc)
        }
    }
    open override func tabBar(_ tabBar: UITabBar, willBeginCustomizing items: [UITabBarItem]) {
        if let _tabBar = tabBar as? YHTabBar {
            _tabBar.updateLayout()
        }
    }
    
    open override func tabBar(_ tabBar: UITabBar, didEndCustomizing items: [UITabBarItem], changed: Bool) {
        if let _tabBar = tabBar as? YHTabBar {
            _tabBar.updateLayout()
        }
    }
}

extension YHTabBarController: YHTabBarProtocol {
    internal func tabBar(_ tabBar: UITabBar, shouldSelect item: UITabBarItem, index: Int) -> Bool {
        if let vc = viewControllers?[index] {
            return delegate?.tabBarController?(self, shouldSelect: vc) ?? true
        }
        return true
    }
    
    internal func tabBar(_ tabBar: UITabBar, shouldHijack item: UITabBarItem, index: Int) -> Bool {
        if let vc = viewControllers?[index] {
            return shouldHijackHandler?(self, vc, index) ?? false
        }
        return false
    }
    
    internal func tabBar(_ tabBar: UITabBar, didHijack item: UITabBarItem, index: Int) {
        if let vc = viewControllers?[index] {
            didHijackHandler?(self, vc, index)
        }
    }
}
