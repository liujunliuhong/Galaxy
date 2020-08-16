//
//  SwiftyCusNavigationBarSpace.swift
//  SwiftTool
//
//  Created by liujun on 2020/8/16.
//  Copyright © 2020 galaxy. All rights reserved.
//

import UIKit

public class SwiftyCusNavigationBarSpace: NSObject {
    
    public var space: CGFloat = 0.0
    
    public override init() {
        super.init()
    }
    
    public init(space: CGFloat) {
        super.init()
        self.space = space
    }
}
