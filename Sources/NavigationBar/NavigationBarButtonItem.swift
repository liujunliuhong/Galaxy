//
//  NavigationBarButtonItem.swift
//  SwiftTool
//
//  Created by galaxy on 2021/5/24.
//  Copyright © 2021 yinhe. All rights reserved.
//

import Foundation
import UIKit

public final class NavigationBarButtonItem {
    
    public typealias ButtonConfigure = ((UIButton) -> Void)
    public typealias LabelConfigure = ((UILabel) -> Void)
    
    public enum ConstraintsType {
        /// 指定`customView`的具体`size`
        case size(width: NavigationSize, height: NavigationSize)
        /// 自动，需要实现`customView`的`intrinsicContentSize`方法，且是垂直居中显示
        case auto
    }
    
    public var customView: UIView?
    public var constraintsType: ConstraintsType = .auto
    
    public init(customView: UIView?, constraintsType: ConstraintsType) {
        self.customView = customView
        self.constraintsType = constraintsType
    }
    
    public init() { }
}

extension NavigationBarButtonItem {
    /// Custom
    public class func custom(_ customView: UIView, constraintsType: ConstraintsType) -> NavigationBarButtonItem {
        return NavigationBarButtonItem(customView: customView, constraintsType: constraintsType)
    }
    
    /// Button
    public class func button(constraintsType: ConstraintsType, configure: ButtonConfigure?) -> NavigationBarButtonItem {
        let button = UIButton(type: .custom)
        configure?(button)
        return NavigationBarButtonItem(customView: button, constraintsType: constraintsType)
    }
    
    /// Label
    public class func label(constraintsType: ConstraintsType, configure: LabelConfigure?) -> NavigationBarButtonItem {
        let label = UILabel()
        configure?(label)
        return NavigationBarButtonItem(customView: label, constraintsType: constraintsType)
    }
    
    /// Space
    public class func fixedSpace(_ width: NavigationSize) -> NavigationBarButtonItem {
        return NavigationBarButtonItem(customView: nil, constraintsType: .size(width: width, height: .zero))
    }
}
