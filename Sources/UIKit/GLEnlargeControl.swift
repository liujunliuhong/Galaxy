//
//  GLEnlargeControl.swift
//  SwiftTool
//
//  Created by galaxy on 2020/10/19.
//  Copyright © 2020 yinhe. All rights reserved.
//

import UIKit


open class GLEnlargeControl: UIControl {
    public var gl_enlargeInsets: UIEdgeInsets = .zero
}

extension GLEnlargeControl {
    private func getNewArea() -> CGRect {
        return CGRect(x: self.bounds.origin.x - self.gl_enlargeInsets.left,
                      y: self.bounds.origin.y - self.gl_enlargeInsets.top,
                      width: self.bounds.size.width + self.gl_enlargeInsets.left + self.gl_enlargeInsets.right,
                      height: self.bounds.size.height + self.gl_enlargeInsets.top + self.gl_enlargeInsets.bottom)
    }
}

extension GLEnlargeControl {
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
