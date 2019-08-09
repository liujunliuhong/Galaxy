//
//  YHViewControllerExtension.swift
//  SwiftTool
//
//  Created by apple on 2019/6/26.
//  Copyright © 2019 yinhe. All rights reserved.
//

import Foundation
import UIKit




extension UIViewController {
    
    enum YHBackType {
        case pop
        case popTo(UIViewController)
        case dismiss
    }
    
    func YHBack(for type: YHBackType) {
        switch type {
        case .pop:
            self.navigationController?.popViewController(animated: true)
        case let .popTo(viewcontroller):
            self.navigationController?.popToViewController(viewcontroller, animated: true)
        case .dismiss:
            self.dismiss(animated: true, completion: nil)
        }
    }
}
