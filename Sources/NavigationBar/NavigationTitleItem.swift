//
//  NavigationTitleItem.swift
//  SwiftTool
//
//  Created by galaxy on 2021/5/24.
//  Copyright © 2021 yinhe. All rights reserved.
//

import Foundation
import UIKit

public final class NavigationTitleItem {
    
    public typealias LabelConfigure = ((UILabel) -> Void)
    
    public enum ConstraintsType {
        /// 居中显示，会做一系列的动态判断
        case center(width: NavigationSize, height: NavigationSize)
        /// 填充完`items`之外的所有空间
        case fill
    }
    
    /// 自定义`View`
    public var customView: UIView?
    /// 布局类型
    public var constraintsType: ConstraintsType = .center(width: .auto, height: .auto)
    
    public init(customView: UIView?, constraintsType: ConstraintsType) {
        self.customView = customView
        self.constraintsType = constraintsType
    }
    
    public init() { }
}

extension NavigationTitleItem {
    /// Label
    public class func label(constraintsType: ConstraintsType, configure: LabelConfigure?) -> NavigationTitleItem {
        let label = UILabel()
        configure?(label)
        return NavigationTitleItem(customView: label, constraintsType: constraintsType)
    }
}
