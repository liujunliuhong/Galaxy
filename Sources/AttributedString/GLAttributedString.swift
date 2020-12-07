//
//  GLAttributedString.swift
//  SwiftTool
//
//  Created by galaxy on 2020/12/7.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import UIKit

public struct GLAttributedString<Base> {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

public protocol GLAttributedStringCompatible {
    associatedtype GLAttributedBase
    var gl_atr: GLAttributedString<GLAttributedBase> { get }
}

extension GLAttributedStringCompatible {
    public var gl_atr: GLAttributedString<Self> {
        if let value = objc_getAssociatedObject(self, &Keys.associatedKey) as? GLAttributedString<Self> {
            return value
        }
        let value = GLAttributedString(self)
        objc_setAssociatedObject(self, &Keys.associatedKey, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return value
    }
}

extension NSMutableAttributedString: GLAttributedStringCompatible{}

fileprivate struct Keys {
    static var associatedKey = "com.galaxy.glattributedstring.associatedKey"
}
