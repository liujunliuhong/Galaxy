//
//  GLChain+Label.swift
//  SwiftTool
//
//  Created by galaxy on 2020/12/3.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import UIKit



public class GLLabelChain: GLBaseViewChain {
    @discardableResult
    public func text(_ text: String?) -> Self {
        let label = self.view as! UILabel
        label.text = text
        return self
    }
    
    @discardableResult
    public func textColor(_ textColor: UIColor?) -> Self {
        let label = self.view as! UILabel
        label.textColor = textColor
        return self
    }
}
