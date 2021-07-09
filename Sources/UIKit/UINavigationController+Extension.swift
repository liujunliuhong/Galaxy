//
//  UINavigationController+Extension.swift
//  SwiftTool
//
//  Created by galaxy on 2021/5/22.
//  Copyright © 2021 yinhe. All rights reserved.
//

import Foundation
import UIKit

extension GL where Base: UINavigationController {
    /// Push
    /// - Parameters:
    ///   - viewController: 控制器
    ///   - animated: 是否需要动画
    public func push(destination viewController: UIViewController?, animated: Bool) {
        guard let viewController = viewController else { return }
        viewController.hidesBottomBarWhenPushed = true
        base.pushViewController(viewController, animated: animated)
    }
    
    /// `Pop`到指定控制器
    /// - Parameters:
    ///   - vcName: 控制器名称，如果为`nil`，`pop`到上一个控制器
    ///   - animated: 是否需要动画
    public func pop(to vcName: String?, animated: Bool) {
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

extension GL where Base: UINavigationController {
    
    /// 获取第一个符合类型的视图控制器
    /// - Parameter controller: 控制器类型
    /// - Returns: 控制器
    public func first<T: UIViewController>(controller: T.Type) -> T? {
        return base.viewControllers.first { type(of: $0) == controller } as? T
    }
    
    /// 过滤所有符合类型的视图控制器
    /// - Parameter controller: 要过滤的控制器类型
    /// - Returns: 过滤之后的控制器集合
    public func filter<T: UIViewController>(controller: T.Type) -> [T] {
        return base.viewControllers.filter { type(of: $0) == controller } as? [T] ?? []
    }
    
    /// 移除所有符合类型的视图控制器
    /// - Parameters:
    ///   - controller: 要移除的控制器类型
    ///   - animated: 是否动画
    /// - Returns: 移除掉的控制器集合
    @discardableResult
    public func remove<T: UIViewController>(controller: T.Type, animated: Bool = false) -> [T]? {
        let controllers = filter(controller: T.self)
        var temp = base.viewControllers
        temp.removeAll(controllers)
        base.setViewControllers(temp, animated: animated)
        return controllers
    }
    
    /// 移除一个视图控制器
    /// - Parameters:
    ///   - controller: 要移除的控制器对象
    ///   - animated: 是否动画
    public func remove(controller: UIViewController, animated: Bool = false) {
        var temp = base.viewControllers
        temp.removeAll([controller])
        base.setViewControllers(temp, animated: animated)
    }
    
    /// 移除多个视图控制器
    /// - Parameter controllers: 要移除的控制器对象集合
    /// - Parameter animated: 是否动画
    public func remove(controllers: [UIViewController], animated: Bool = false) {
        var temp = base.viewControllers
        temp.removeAll(controllers)
        base.setViewControllers(temp, animated: animated)
    }
}

fileprivate extension Array where Element: Equatable {
    @discardableResult
    mutating func removeAll(_ items: [Element]) -> [Element] {
        guard !items.isEmpty else { return self }
        removeAll(where: { items.contains($0) })
        return self
    }
}
