//
//  UITextView+GLChain.swift
//  SwiftTool
//
//  Created by Yule on 2020/12/4.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import UIKit

extension GLChain where Base: UITextView {
    @discardableResult
    public func delegate(_ delegate: UITextViewDelegate?) -> Self {
        self.base.delegate = delegate
        return self
    }
    
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
    public func selectedRange(_ selectedRange: NSRange) -> Self {
        self.base.selectedRange = selectedRange
        return self
    }
    
    @discardableResult
    public func isEditable(_ isEditable: Bool) -> Self {
        self.base.isEditable = isEditable
        return self
    }
    
    @discardableResult
    public func isSelectable(_ isSelectable: Bool) -> Self {
        self.base.isSelectable = isSelectable
        return self
    }
    
    @discardableResult
    public func dataDetectorTypes(_ dataDetectorTypes: UIDataDetectorTypes) -> Self {
        self.base.dataDetectorTypes = dataDetectorTypes
        return self
    }
    
    @discardableResult
    public func allowsEditingTextAttributes(_ allowsEditingTextAttributes: Bool) -> Self {
        self.base.allowsEditingTextAttributes = allowsEditingTextAttributes
        return self
    }
    
    @discardableResult
    public func attributedText(_ attributedText: NSAttributedString?) -> Self {
        self.base.attributedText = attributedText
        return self
    }
    
    @discardableResult
    public func typingAttributes(_ typingAttributes: [NSAttributedString.Key : Any]) -> Self {
        self.base.typingAttributes = typingAttributes
        return self
    }
    
    @discardableResult
    public func inputView(_ inputView: UIView?) -> Self {
        self.base.inputView = inputView
        return self
    }
    
    @discardableResult
    public func inputAccessoryView(_ inputAccessoryView: UIView?) -> Self {
        self.base.inputAccessoryView = inputAccessoryView
        return self
    }
    
    @discardableResult
    public func clearsOnInsertion(_ clearsOnInsertion: Bool) -> Self {
        self.base.clearsOnInsertion = clearsOnInsertion
        return self
    }
    
    @discardableResult
    public func textContainerInset(_ textContainerInset: UIEdgeInsets) -> Self {
        self.base.textContainerInset = textContainerInset
        return self
    }
    
    @discardableResult
    public func linkTextAttributes(_ linkTextAttributes: [NSAttributedString.Key : Any]?) -> Self {
        self.base.linkTextAttributes = linkTextAttributes
        return self
    }
    
    @available(iOS 13.0, *)
    @discardableResult
    public func usesStandardTextScaling(_ usesStandardTextScaling: Bool) -> Self {
        self.base.usesStandardTextScaling = usesStandardTextScaling
        return self
    }
}
