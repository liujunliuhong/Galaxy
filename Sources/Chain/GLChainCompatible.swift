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
        if let value = objc_getAssociatedObject(self, &Keys.associatedKey) as? GLChain<Self> {
            return value
        }
        let value = GLChain(self)
        objc_setAssociatedObject(self, &Keys.associatedKey, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return value
    }
}

extension UIView: GLChainCompatible{}
extension CALayer: GLChainCompatible{}

internal struct Keys {
    static var associatedKey = "com.galaxy.glchain.associatedKey"
}
