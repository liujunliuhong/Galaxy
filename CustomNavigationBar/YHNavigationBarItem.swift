//
//  YHNavigationBarItem.swift
//  SwiftTool
//
//  Created by apple on 2019/5/9.
//  Copyright © 2019 yinhe. All rights reserved.
//

import UIKit

class YHNavigationBarItem: NSObject {
    var view: UIView
    var width: CGFloat
    
    init(view: UIView, width: CGFloat = 44.0) {
        self.view = view
        self.width = width
    }
}
