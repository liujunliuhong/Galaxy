//
//  GLChain+Base.swift
//  SwiftTool
//
//  Created by galaxy on 2020/12/3.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import UIKit

open class GLBaseViewChain: NSObject {
    public let view: UIView
    public init(view: UIView) {
        self.view = view
    }
    
    @discardableResult
    public func backgroundColor(_ backgroundColor: UIColor?) -> Self {
        self.view.backgroundColor = backgroundColor
        return self
    }
}
