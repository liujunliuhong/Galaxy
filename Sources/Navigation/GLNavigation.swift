//
//  GLNavigation.swift
//  SwiftTool
//
//  Created by Yule on 2020/12/7.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import UIKit

public struct GLNavigation {}


extension GLNavigation {
    
    public static func push(with sender: UINavigationController?, destination viewController: UIViewController?, animated: Bool) {
        guard let sender = sender else { return }
        guard let viewController = viewController else { return }
        viewController.hidesBottomBarWhenPushed = true
        sender.pushViewController(viewController, animated: animated)
    }
    
    public static func pop(with sender: UINavigationController?, destination vcName: String?, animated: Bool) {
        guard let sender = sender else { return }
        guard sender.viewControllers.count > 0 else { return }
        if let vcName = vcName {
            for (_, vc) in sender.viewControllers.reversed().enumerated() {
                if NSStringFromClass(vc.classForCoder) == vcName {
                    sender.popToViewController(vc, animated: animated)
                    break
                }
            }
        } else {
            sender.popViewController(animated: animated)
        }
    }
    
    public static func present(with sender: UIViewController?, destination viewController: UIViewController?, animated: Bool, completion: (() -> Void)? = nil) {
        guard let sender = sender else { return }
        guard let viewController = viewController else { return }
        viewController.modalPresentationStyle = .fullScreen
        sender.present(viewController, animated: animated, completion: completion)
    }
    
    public static func dismiss(with viewController: UIViewController?, animated: Bool, completion: (() -> Void)? = nil) {
        guard let viewController = viewController else { return }
        viewController.dismiss(animated: animated, completion: completion)
    }
}
