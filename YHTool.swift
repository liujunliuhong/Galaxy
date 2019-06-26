//
//  YHTool.swift
//  SwiftTool
//
//  Created by 银河 on 2019/6/26.
//  Copyright © 2019 yinhe. All rights reserved.
//

import Foundation
import UIKit

// Open iphone setting.
func YHOpenIphoneSettings() {
    DispatchQueue.main.async {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
        }
    }
}
