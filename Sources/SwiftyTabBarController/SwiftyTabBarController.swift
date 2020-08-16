//
//  SwiftyTabBarController.swift
//  SwiftTool
//
//  Created by apple on 2020/6/11.
//  Copyright © 2020 galaxy. All rights reserved.
//

import UIKit

/// Do you need to intercept click events
public typealias SwiftyTabBarControllerShouldHijackHandler = ((_ tabBarController: SwiftyTabBarController, _ viewController: UIViewController, _ index: Int) -> (Bool))
/// Callback to intercept click event
public typealias SwiftyTabBarControllerDidHijackHandler = ((_ tabBarController: SwiftyTabBarController, _ viewController: UIViewController, _ index: Int) -> (Void))


open class SwiftyTabBarController: UITabBarController {

    open var shouldHijackHandler: SwiftyTabBarControllerShouldHijackHandler?
    open var didHijackHandler: SwiftyTabBarControllerDidHijackHandler?
    
    fileprivate var ignoreNextSelection = false
    
    open override var selectedViewController: UIViewController? {
        willSet {
            guard let newValue = newValue else {
                return
            }
            if self.ignoreNextSelection {
                self.ignoreNextSelection = false
                return
            }
            guard let tabBar = self.tabBar as? SwiftyTabBar, let _ = tabBar.items, let index = self.viewControllers?.firstIndex(of: newValue) else {
                return
            }
            tabBar.select(itemAtIndex: index, animated: false)
        }
    }
    
    open override var selectedIndex: Int {
        willSet {
            if self.ignoreNextSelection {
                self.ignoreNextSelection = false
                return
            }
            guard let tabBar = self.tabBar as? SwiftyTabBar, let _ = tabBar.items else {
                return
            }
            tabBar.select(itemAtIndex: newValue, animated: false)
        }
    }
    
    open override var viewControllers: [UIViewController]? {
        willSet {
            if let newValue = newValue, newValue.count > 5 {
                // More than 5 errors are reported. So far, I have not seen more than 5 Item applications, and Apple will reject more than 5 Item applications.
                fatalError("The number of items count cannot exceed 5.")
            }
            super.viewControllers = newValue
        }
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        let tabBar = SwiftyTabBar()
        tabBar.delegate = self
        tabBar.customDelegate = self
        tabBar.tabBarController = self
        // kvc
        self.setValue(tabBar, forKey: "tabBar")
    }
    
    open override func value(forUndefinedKey key: String) -> Any? {
        return nil
    }
}

extension SwiftyTabBarController {
    open override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let idx = tabBar.items?.firstIndex(of: item) else {
            return;
        }
        if let vc = self.viewControllers?[idx] {
            self.ignoreNextSelection = true
            self.selectedIndex = idx // The set method is called here, so set the `ignoreNextSelection` to YES, otherwise it will cause an endless loop
            self.ignoreNextSelection = false // reset
            self.delegate?.tabBarController?(self, didSelect: vc)
        }
    }
    open override func tabBar(_ tabBar: UITabBar, willBeginCustomizing items: [UITabBarItem]) {
        if let tabBar = tabBar as? SwiftyTabBar {
            tabBar.updateLayout()
        }
    }
    
    open override func tabBar(_ tabBar: UITabBar, didEndCustomizing items: [UITabBarItem], changed: Bool) {
        if let tabBar = tabBar as? SwiftyTabBar {
            tabBar.updateLayout()
        }
    }
}

extension SwiftyTabBarController: SwiftyTabBarDelegate {
    internal func tabBar(_ tabBar: SwiftyTabBar, shouldSelect item: UITabBarItem) -> Bool {
        if let idx = tabBar.items?.firstIndex(of: item), let vc = self.viewControllers?[idx] {
            return delegate?.tabBarController?(self, shouldSelect: vc) ?? true
        }
        return true
    }
    
    internal func tabBar(_ tabBar: SwiftyTabBar, shouldHijack item: UITabBarItem) -> Bool {
        if let idx = tabBar.items?.firstIndex(of: item), let vc = viewControllers?[idx] {
            return self.shouldHijackHandler?(self, vc, idx) ?? false
        }
        return false
    }
    
    internal func tabBar(_ tabBar: SwiftyTabBar, didHijack item: UITabBarItem) {
        if let idx = tabBar.items?.firstIndex(of: item), let vc = viewControllers?[idx] {
            self.didHijackHandler?(self, vc, idx)
        }
    }
}
