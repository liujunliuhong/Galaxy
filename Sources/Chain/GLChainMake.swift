//
//  GLChainMake.swift
//  SwiftTool
//
//  Created by galaxy on 2020/12/4.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    @objc open var gl: GLBaseViewChain {
        return GLBaseViewChain(view: self)
    }
}

extension UILabel {
    open override var gl: GLLabelChain {
        return GLLabelChain(view: self)
    }
}

//extension UIButton {
//    open override var gl: GLLabelChain {
//        return GLLabelChain(view: self)
//    }
//}
