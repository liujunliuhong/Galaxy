//
//  GLCusNaviBarTitle.swift
//  SwiftTool
//
//  Created by galaxy on 2020/10/25.
//  Copyright © 2020 yinhe. All rights reserved.
//

import UIKit

public class GLCusNaviBarTitle {
    
    public enum LayoutType {
        case center  // 居中显示，高度就是`barHeight`，宽度根据左右`items`来动态调整
        case fill    // 填充完所有空间
    }
    
    public var view: UIView?
    public var layoutType: LayoutType = .center
    
    public init(view: UIView?, layoutType: LayoutType) {
        self.view = view
        self.layoutType = layoutType
    }
    
    public init() {
        
    }
}
