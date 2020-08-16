//
//  SwiftyCusNavigationBarButtonItem.swift
//  SwiftTool
//
//  Created by liujun on 2020/8/16.
//  Copyright © 2020 galaxy. All rights reserved.
//

import UIKit

public class SwiftyCusNavigationBarButtonItem: NSObject {
    
    // layout type
    // custom: Custom width and height
    // auto: Get the width of the control itself by calling `sizeToFit`
    public enum LayoutType {
        case custom(y: CGFloat, width: CGFloat, height: CGFloat)
        case auto
    }
    
    public var view: UIView?
    public var layoutType: LayoutType = .auto
    
    public init(view: UIView?, layoutType: LayoutType) {
        super.init()
        self.view = view
        self.layoutType = layoutType
    }
    
    public override init() {
        super.init()
    }
}
