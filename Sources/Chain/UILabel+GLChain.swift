//
//  UILabel+GLChain.swift
//  SwiftTool
//
//  Created by Yule on 2020/12/4.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import UIKit

extension GLChain where Base: UILabel {
    
    @discardableResult
    public func text(_ text: String?) -> Self {
        self.base.text = text
        return self
    }
    
    @discardableResult
    public func textColor(_ textColor: UIColor?) -> Self {
        self.base.textColor = textColor
        return self
    }
    
    @discardableResult
    public func font(_ font: UIFont?) -> Self {
        self.base.font = font
        return self
    }
    
    @discardableResult
    public func textAlignment(_ textAlignment: NSTextAlignment) -> Self {
        self.base.textAlignment = textAlignment
        return self
    }
    
    @discardableResult
    public func shadowColor(_ shadowColor: UIColor?) -> Self {
        self.base.shadowColor = shadowColor
        return self
    }
    
    @discardableResult
    public func shadowOffset(_ shadowOffset: CGSize) -> Self {
        self.base.shadowOffset = shadowOffset
        return self
    }
    
    @discardableResult
    public func lineBreakMode(_ lineBreakMode: NSLineBreakMode) -> Self {
        self.base.lineBreakMode = lineBreakMode
        return self
    }
    
    @discardableResult
    public func attributedText(_ attributedText: NSAttributedString?) -> Self {
        self.base.attributedText = attributedText
        return self
    }
    
    @discardableResult
    public func highlightedTextColor(_ highlightedTextColor: UIColor?) -> Self {
        self.base.highlightedTextColor = highlightedTextColor
        return self
    }
    
    @discardableResult
    public func isHighlighted(_ isHighlighted: Bool) -> Self {
        self.base.isHighlighted = isHighlighted
        return self
    }
    
    @discardableResult
    public func isEnabled(_ isEnabled: Bool) -> Self {
        self.base.isEnabled = isEnabled
        return self
    }
    
    @discardableResult
    public func numberOfLines(_ numberOfLines: Int) -> Self {
        self.base.numberOfLines = numberOfLines
        return self
    }
    
    @discardableResult
    public func adjustsFontSizeToFitWidth(_ adjustsFontSizeToFitWidth: Bool) -> Self {
        self.base.adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth
        return self
    }
    
    @discardableResult
    public func baselineAdjustment(_ baselineAdjustment: UIBaselineAdjustment) -> Self {
        self.base.baselineAdjustment = baselineAdjustment
        return self
    }
    
    @discardableResult
    public func minimumScaleFactor(_ minimumScaleFactor: CGFloat) -> Self {
        self.base.minimumScaleFactor = minimumScaleFactor
        return self
    }
    
    @discardableResult
    public func allowsDefaultTighteningForTruncation(_ allowsDefaultTighteningForTruncation: Bool) -> Self {
        self.base.allowsDefaultTighteningForTruncation = allowsDefaultTighteningForTruncation
        return self
    }
    
    @discardableResult
    public func lineBreakStrategy(_ lineBreakStrategy: NSParagraphStyle.LineBreakStrategy) -> Self {
        self.base.lineBreakStrategy = lineBreakStrategy
        return self
    }
    
    @discardableResult
    public func preferredMaxLayoutWidth(_ preferredMaxLayoutWidth: CGFloat) -> Self {
        self.base.preferredMaxLayoutWidth = preferredMaxLayoutWidth
        return self
    }
}
