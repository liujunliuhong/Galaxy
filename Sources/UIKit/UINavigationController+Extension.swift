//
//  UINavigationController+Extension.swift
//  SwiftTool
//
//  Created by galaxy on 2021/5/22.
//  Copyright © 2021 yinhe. All rights reserved.
//

import Foundation
import UIKit

extension GL where Base == UINavigationController {
    /// push
    /// - Parameters:
    ///   - viewController: 控制器
    ///   - animated: 是否需要动画
    public func gl_push(destination viewController: UIViewController?, animated: Bool) {
        guard let viewController = viewController else { return }
        viewController.hidesBottomBarWhenPushed = true
        base.pushViewController(viewController, animated: animated)
    }
    
    /// `pop`到指定控制器
    /// - Parameters:
    ///   - vcName: 控制器名称，如果为`nil`，`pop`到上一个控制器
    ///   - animated: 是否需要动画
    public func gl_pop(to vcName: String?, animated: Bool) {
        guard base.viewControllers.count > 0 else { return }
        if let vcName = vcName {
            for (_, vc) in base.viewControllers.reversed().enumerated() {
                if NSStringFromClass(vc.classForCoder) == vcName {
                    base.popToViewController(vc, animated: animated)
                    break
                }
            }
        } else {
            base.popViewController(animated: animated)
        }
    }
}
