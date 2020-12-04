//
//  GLChainCompatible.swift
//  SwiftTool
//
//  Created by Yule on 2020/12/4.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import UIKit

public struct GLChain<Base> {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

public protocol GLChainCompatible {
    associatedtype GLChainBase
    var glc: GLChain<GLChainBase> { get }
}

extension GLChainCompatible {
    public var glc: GLChain<Self> {
        return GLChain(self)
    }
}

extension UIView: GLChainCompatible{}
extension CALayer: GLChainCompatible{}

internal struct Keys {
    static var view_layer_key = "com.galaxy.glc.view_layer.key"
}
