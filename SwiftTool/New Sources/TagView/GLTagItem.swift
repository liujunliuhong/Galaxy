//
//  GLTagItem.swift
//  SwiftTool
//
//  Created by galaxy on 2020/10/23.
//  Copyright © 2020 yinhe. All rights reserved.
//

import UIKit

public class GLTagItem {
    /// item对应的view
    public let view: UIView
    /// `item`的宽度。如果`item`的宽度小于等于`0`，那么将使用`item`对应`view`的`intrinsicContentSize.width`
    public let width: CGFloat
    /// `item`的高度。如果`item`的高度小于等于`0`，那么将使用`item`对应`view`的`intrinsicContentSize.height`
    public let height: CGFloat
    
    /// 初始化方法
    public init(view: UIView, width: CGFloat, height: CGFloat) {
        self.view = view
        self.width = width
        self.height = height
    }
}

extension GLTagItem {
    /// `item`的唯一标识符，用于两个`item`之间的比较
    internal var identifier: String {
        return UUID().uuidString
    }
}
