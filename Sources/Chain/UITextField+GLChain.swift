//
//  UITextField+GLChain.swift
//  SwiftTool
//
//  Created by Yule on 2020/12/4.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import UIKit


extension GLChain where Base: UITextField {
    
    @discardableResult
    public func text(_ text: String?) -> Self {
        self.base.text = text
        return self
    }
    
    @discardableResult
    public func attributedText(_ attributedText: NSAttributedString?) -> Self {
        self.base.attributedText = attributedText
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
    public func borderStyle(_ borderStyle: UITextField.BorderStyle) -> Self {
        self.base.borderStyle = borderStyle
        return self
    }
    
    @discardableResult
    public func defaultTextAttributes(_ defaultTextAttributes: [NSAttributedString.Key : Any]) -> Self {
        self.base.defaultTextAttributes = defaultTextAttributes
        return self
    }
    
    @discardableResult
    public func placeholder(_ placeholder: String?) -> Self {
        self.base.placeholder = placeholder
        return self
    }
    
    @discardableResult
    public func attributedPlaceholder(_ attributedPlaceholder: NSAttributedString?) -> Self {
        self.base.attributedPlaceholder = attributedPlaceholder
        return self
    }
    
    @discardableResult
    public func clearsOnBeginEditing(_ clearsOnBeginEditing: Bool) -> Self {
        self.base.clearsOnBeginEditing = clearsOnBeginEditing
        return self
    }
    
    @discardableResult
    public func adjustsFontSizeToFitWidth(_ adjustsFontSizeToFitWidth: Bool) -> Self {
        self.base.adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth
        return self
    }
    
    @discardableResult
    public func minimumFontSize(_ minimumFontSize: CGFloat) -> Self {
        self.base.minimumFontSize = minimumFontSize
        return self
    }
    
    @discardableResult
    public func delegate(_ delegate: UITextFieldDelegate?) -> Self {
        self.base.delegate = delegate
        return self
    }
    
    @discardableResult
    public func background(_ background: UIImage?) -> Self {
        self.base.background = background
        return self
    }
    
    @discardableResult
    public func disabledBackground(_ disabledBackground: UIImage?) -> Self {
        self.base.disabledBackground = disabledBackground
        return self
    }
    
    @discardableResult
    public func allowsEditingTextAttributes(_ allowsEditingTextAttributes: Bool) -> Self {
        self.base.allowsEditingTextAttributes = allowsEditingTextAttributes
        return self
    }
    
    @discardableResult
    public func typingAttributes(_ typingAttributes: [NSAttributedString.Key : Any]?) -> Self {
        self.base.typingAttributes = typingAttributes
        return self
    }
    
    @discardableResult
    public func clearButtonMode(_ clearButtonMode: UITextField.ViewMode) -> Self {
        self.base.clearButtonMode = clearButtonMode
        return self
    }
    
    @discardableResult
    public func leftView(_ leftView: UIView?) -> Self {
        self.base.leftView = leftView
        return self
    }
    
    @discardableResult
    public func leftViewMode(_ leftViewMode: UITextField.ViewMode) -> Self {
        self.base.leftViewMode = leftViewMode
        return self
    }
    
    @discardableResult
    public func rightView(_ rightView: UIView?) -> Self {
        self.base.rightView = rightView
        return self
    }
    
    @discardableResult
    public func rightViewMode(_ rightViewMode: UITextField.ViewMode) -> Self {
        self.base.rightViewMode = rightViewMode
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
}
