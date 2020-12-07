//
//  GLCusNaviBarButtonItem.swift
//  SwiftTool
//
//  Created by galaxy on 2020/10/25.
//  Copyright © 2020 yinhe. All rights reserved.
//

import UIKit


public class GLCusNaviBarButtonItem {
    
    public enum LayoutType {
        case custom(width: CGFloat, height: CGFloat)
        case auto  // 需要实现`view`的`intrinsicContentSize`方法，且是垂直居中显示
    }
    
    public var view: UIView?
    public var layoutType: LayoutType = .auto
    
    public init(view: UIView?, layoutType: LayoutType) {
        self.view = view
        self.layoutType = layoutType
    }
    public init() {
        
    }
}
