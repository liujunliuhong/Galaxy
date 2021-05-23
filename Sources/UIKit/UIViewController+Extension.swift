//
//  UIViewController+Extension.swift
//  SwiftTool
//
//  Created by galaxy on 2021/5/22.
//  Copyright © 2021 yinhe. All rights reserved.
//

import Foundation
import UIKit

extension GL where Base == UIViewController {
    
    /// `present`
    /// - Parameters:
    ///   - viewController: 控制器
    ///   - animated: 是否需要动画
    ///   - completion: 完成回调
    public func present(destination viewController: UIViewController?, animated: Bool, completion: (() -> Void)? = nil) {
        guard let viewController = viewController else { return }
        viewController.modalPresentationStyle = .fullScreen
        base.present(viewController, animated: animated, completion: completion)
    }
    
    
    /// `dismiss`
    /// - Parameters:
    ///   - animated: 是否需要动画
    ///   - completion: 完成回调
    public func dismiss(animated: Bool, completion: (() -> Void)? = nil) {
        base.dismiss(animated: animated, completion: completion)
    }
}
