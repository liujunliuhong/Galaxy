//
//  SwiftyCusNavigationBarTitle.swift
//  SwiftTool
//
//  Created by liujun on 2020/8/16.
//  Copyright © 2020 galaxy. All rights reserved.
//

import UIKit

public class SwiftyCusNavigationBarTitle: NSObject {
    
    // layout type
    // custom: Custom width and height
    // auto: Fill the remaining space
    public enum LayoutType {
        case custom(y: CGFloat, width: CGFloat, height: CGFloat)
        case fill
    }
    
    public var view: UIView?
    public var layoutType: LayoutType = .fill
    
    public init(view: UIView?, layoutType: LayoutType) {
        super.init()
        self.view = view
        self.layoutType = layoutType
    }
    
    public override init() {
        super.init()
        
    }
}
