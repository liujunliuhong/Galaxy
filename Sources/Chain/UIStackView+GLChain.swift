//
//  UIStackView+GLChain.swift
//  SwiftTool
//
//  Created by galaxy on 2020/12/6.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import UIKit

extension GLChain where Base: UIStackView {
    
    @discardableResult
    public func axis(_ axis: NSLayoutConstraint.Axis) -> Self {
        self.base.axis = axis
        return self
    }
    
    @discardableResult
    public func distribution(_ distribution: UIStackView.Distribution) -> Self {
        self.base.distribution = distribution
        return self
    }
    
    @discardableResult
    public func alignment(_ alignment: UIStackView.Alignment) -> Self {
        self.base.alignment = alignment
        return self
    }
    
    @discardableResult
    public func spacing(_ spacing: CGFloat) -> Self {
        self.base.spacing = spacing
        return self
    }
    
    @discardableResult
    public func isBaselineRelativeArrangement(_ isBaselineRelativeArrangement: Bool) -> Self {
        self.base.isBaselineRelativeArrangement = isBaselineRelativeArrangement
        return self
    }
    
    @discardableResult
    public func isLayoutMarginsRelativeArrangement(_ isLayoutMarginsRelativeArrangement: Bool) -> Self {
        self.base.isLayoutMarginsRelativeArrangement = isLayoutMarginsRelativeArrangement
        return self
    }
}
