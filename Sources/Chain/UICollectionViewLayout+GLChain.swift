//
//  UICollectionViewLayout+GLChain.swift
//  SwiftTool
//
//  Created by galaxy on 2020/12/6.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import UIKit

extension GLChain where Base: UICollectionViewLayout {
    
    @discardableResult
    public func register(_ viewClass: AnyClass?, forDecorationViewOfKind elementKind: String) -> Self {
        self.base.register(viewClass, forDecorationViewOfKind: elementKind)
        return self
    }
    
    @discardableResult
    public func register(_ nib: UINib?, forDecorationViewOfKind elementKind: String) -> Self {
        self.base.register(nib, forDecorationViewOfKind: elementKind)
        return self
    }
}
