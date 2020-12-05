//
//  UIControl+GLChain.swift
//  SwiftTool
//
//  Created by Yule on 2020/12/4.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import UIKit

extension GLChain where Base: UIControl {
    
    @discardableResult
    public func contentVerticalAlignment(_ contentVerticalAlignment: UIControl.ContentVerticalAlignment) -> Self {
        self.base.contentVerticalAlignment = contentVerticalAlignment
        return self
    }
    
    @discardableResult
    public func contentHorizontalAlignment(_ contentHorizontalAlignment: UIControl.ContentHorizontalAlignment) -> Self {
        self.base.contentHorizontalAlignment = contentHorizontalAlignment
        return self
    }
    
    @discardableResult
    public func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) -> Self {
        self.base.addTarget(target, action: action, for: controlEvents)
        return self
    }
    
    @discardableResult
    public func isEnabled(_ isEnabled: Bool) -> Self {
        self.base.isEnabled = isEnabled
        return self
    }
    
    @discardableResult
    public func isSelected(_ isSelected: Bool) -> Self {
        self.base.isSelected = isSelected
        return self
    }
    
    @discardableResult
    public func isHighlighted(_ isHighlighted: Bool) -> Self {
        self.base.isHighlighted = isHighlighted
        return self
    }
    
    @discardableResult
    public func removeTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) -> Self {
        self.base.removeTarget(target, action: action, for: controlEvents)
        return self
    }
    
    @available(iOS 14.0, *)
    @discardableResult
    public func addAction(_ action: UIAction, for controlEvents: UIControl.Event) -> Self {
        self.base.addAction(action, for: controlEvents)
        return self
    }
    
    @available(iOS 14.0, *)
    @discardableResult
    public func removeAction(_ action: UIAction, for controlEvents: UIControl.Event) -> Self {
        self.base.removeAction(action, for: controlEvents)
        return self
    }
    
    @available(iOS 14.0, *)
    @discardableResult
    public func removeAction(identifiedBy actionIdentifier: UIAction.Identifier, for controlEvents: UIControl.Event) -> Self {
        self.base.removeAction(identifiedBy: actionIdentifier, for: controlEvents)
        return self
    }
    
    @discardableResult
    public func sendAction(_ action: Selector, to target: Any?, for event: UIEvent?) -> Self {
        self.base.sendAction(action, to: target, for: event)
        return self
    }
    
    @available(iOS 14.0, *)
    @discardableResult
    public func sendAction(_ action: UIAction) -> Self {
        self.base.sendAction(action)
        return self
    }
    
    @discardableResult
    public func sendActions(for controlEvents: UIControl.Event) -> Self {
        self.base.sendActions(for: controlEvents)
        return self
    }
    
    @available(iOS 14.0, *)
    @discardableResult
    public func isContextMenuInteractionEnabled(_ isContextMenuInteractionEnabled: Bool) -> Self {
        self.base.isContextMenuInteractionEnabled = isContextMenuInteractionEnabled
        return self
    }
    
    @available(iOS 14.0, *)
    @discardableResult
    public func showsMenuAsPrimaryAction(_ showsMenuAsPrimaryAction: Bool) -> Self {
        self.base.showsMenuAsPrimaryAction = showsMenuAsPrimaryAction
        return self
    }
}
