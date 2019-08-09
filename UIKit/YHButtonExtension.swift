//
//  YHButtonExtension.swift
//  SwiftTool
//
//  Created by apple on 2019/6/26.
//  Copyright © 2019 yinhe. All rights reserved.
//

import Foundation
import UIKit


extension UIButton {
    typealias YHActionHandler = () -> ()
    
    private struct YHButtonActionAssociatedKeys {
        static var key = "com.yinhe.button_action.key"
    }
    
    func YHAddAction(for type: UIControl.Event, handler: @escaping YHActionHandler) {
        objc_setAssociatedObject(self, &YHButtonActionAssociatedKeys.key, handler, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        self.addTarget(self, action: #selector(action(button:)), for: type)
    }
    
    @objc
    func action(button: UIButton) {
        if let handler = objc_getAssociatedObject(self, &YHButtonActionAssociatedKeys.key) as? YHActionHandler {
            handler()
        }
    }
}
