//
//  SwiftyEnlargeTouchAreaControl.swift
//  SwiftTool
//
//  Created by galaxy on 2020/9/3.
//  Copyright © 2020 yinhe. All rights reserved.
//

import UIKit

open class SwiftyEnlargeTouchAreaControl: UIControl {
    public var enlargeInsets: UIEdgeInsets = .zero
}

extension SwiftyEnlargeTouchAreaControl {
    private func getNewArea() -> CGRect {
        return CGRect(x: self.bounds.origin.x - self.enlargeInsets.left,
                      y: self.bounds.origin.y - self.enlargeInsets.top,
                      width: self.bounds.size.width + self.enlargeInsets.left + self.enlargeInsets.right,
                      height: self.bounds.size.height + self.enlargeInsets.top + self.enlargeInsets.bottom)
    }
}

extension SwiftyEnlargeTouchAreaControl {
    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if self.isHidden || self.alpha.isLessThanOrEqualTo(.zero) {
            return false
        }
        let newRect = self.getNewArea()
        if self.bounds.equalTo(newRect) {
            return super.point(inside: point, with: event)
        }
        return newRect.contains(point)
    }
}
