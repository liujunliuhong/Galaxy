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


/**
 参考了一个第三方：https://github.com/eggswift/ESTabBarController，在此表示感谢，通过阅读源码，我在其基础上做了很多改进
 另外自定义tabBar还有个写的比较好的：https://github.com/ChenYilong/CYLTabBarController，不过在使用过程中遇到了好些坑，并且升级到iOS 13之后竟然崩溃，也许是我项目里面其他代码导致的。因此我打算自己写一个(又在造轮子了...不过自定义tabBar是我很早之前就有这么个想法，只是一直没有付诸实施，正好这次把它写出来)
 */
open class YHTabBarController: UITabBarController {
    
    open var shouldHijackHandler: YHTabBarControllerShouldHijackHandler?
    open var didHijackHandler: YHTabBarControllerDidHijackHandler?
    
    
    open override var selectedViewController: UIViewController? {
        willSet {
            guard let _newValue = newValue else {
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
            guard let _tabBar = self.tabBar as? YHTabBar, let _ = _tabBar.items else {
                return
            }
            _tabBar.select(itemAtIndex: newValue, animation: false)
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
    // 重写此方法，是为了避免崩溃，万一iOS系统升级，导致KVC失效（例子:iOS 13 TextField使用KVC改变placeholder属性崩溃）
    open override func setValue(_ value: Any?, forUndefinedKey key: String) {
        print("[YHTabBar] KVC崩溃")
    }
}

extension YHTabBarController {
    open override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let idx = tabBar.items?.firstIndex(of: item) else {
            return;
        }
        if let vc = viewControllers?[idx] {
            selectedIndex = idx
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
    func tabBar(_ tabBar: UITabBar, shouldSelect item: UITabBarItem, index: Int) -> Bool {
        if let vc = viewControllers?[index] {
            return delegate?.tabBarController?(self, shouldSelect: vc) ?? true
        }
        return true
    }
    
    func tabBar(_ tabBar: UITabBar, shouldHijack item: UITabBarItem, index: Int) -> Bool {
        if let vc = viewControllers?[index] {
            return shouldHijackHandler?(self, vc, index) ?? false
        }
        return false
    }
    
    func tabBar(_ tabBar: UITabBar, didHijack item: UITabBarItem, index: Int) {
        if let vc = viewControllers?[index] {
            didHijackHandler?(self, vc, index)
        }
    }
}
