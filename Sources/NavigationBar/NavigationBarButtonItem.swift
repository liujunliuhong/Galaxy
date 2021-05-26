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
    
    /// 自定义`View`
    public var customView: UIView?
    /// 宽度。如果是`auto`，需要实现`customView`的`intrinsicContentSize`方法
    public var width: NavigationSize = .auto
    /// 宽度。如果是`auto`，需要实现`customView`的`intrinsicContentSize`方法，且是垂直居中显示
    public var height: NavigationSize = .auto
    
    public init(customView: UIView?, width: NavigationSize, height: NavigationSize) {
        self.customView = customView
        self.width = width
        self.height = height
    }
    
    public init() { }
}

extension NavigationBarButtonItem {
    /// Custom
    public class func custom(_ customView: UIView, width: NavigationSize, height: NavigationSize) -> NavigationBarButtonItem {
        return NavigationBarButtonItem(customView: customView, width: width, height: height)
    }
    
    /// Button
    public class func button(width: NavigationSize, height: NavigationSize, configure: ButtonConfigure?) -> NavigationBarButtonItem {
        let button = UIButton(type: .custom)
        configure?(button)
        return NavigationBarButtonItem(customView: button, width: width, height: height)
    }
    
    /// Label
    public class func label(width: NavigationSize, height: NavigationSize, configure: LabelConfigure?) -> NavigationBarButtonItem {
        let label = UILabel()
        configure?(label)
        return NavigationBarButtonItem(customView: label, width: width, height: height)
    }
    
    /// Space
    public class func fixedSpace(_ width: NavigationSize) -> NavigationBarButtonItem {
        return NavigationBarButtonItem(customView: nil, width: width, height: .zero)
    }
}
