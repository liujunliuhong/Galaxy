//
//  UIViewController+NavigationBar.swift
//  SwiftTool
//
//  Created by liujun on 2021/5/26.
//  Copyright © 2021 yinhe. All rights reserved.
//

import Foundation
import UIKit

private struct AssociatedKeys {
    static var navigation = "com.galaxy.navigationBar.navigation.key"
}

extension GL where Base: UIViewController {
    public var navigationBar: NavigationBar {
        if let _ = objc_getAssociatedObject(self.base, &AssociatedKeys.navigation) as? NavigationBar {
            
        }
        return NavigationBar()
    }
    
    public func addNavigationBar() {
        if let _ = objc_getAssociatedObject(self.base, &AssociatedKeys.navigation) as? NavigationBar {
            return
        }
        
        
    }
}
