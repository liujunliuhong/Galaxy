//
//  UITableViewCell+GLChain.swift
//  SwiftTool
//
//  Created by Yule on 2020/12/7.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import UIKit

extension GLChain where Base: UITableViewCell {
    
    @available(iOS 14.0, *)
    @discardableResult
    public func automaticallyUpdatesContentConfiguration(_ automaticallyUpdatesContentConfiguration: Bool) -> Self {
        self.base.automaticallyUpdatesContentConfiguration = automaticallyUpdatesContentConfiguration
        return self
    }
    
    @available(iOS 14.0, *)
    @discardableResult
    public func automaticallyUpdatesBackgroundConfiguration(_ automaticallyUpdatesBackgroundConfiguration: Bool) -> Self {
        self.base.automaticallyUpdatesBackgroundConfiguration = automaticallyUpdatesBackgroundConfiguration
        return self
    }
    
    @discardableResult
    public func backgroundView(_ backgroundView: UIView?) -> Self {
        self.base.backgroundView = backgroundView
        return self
    }
    
    @discardableResult
    public func selectedBackgroundView(_ selectedBackgroundView: UIView?) -> Self {
        self.base.selectedBackgroundView = selectedBackgroundView
        return self
    }
    
    @discardableResult
    public func multipleSelectionBackgroundView(_ multipleSelectionBackgroundView: UIView?) -> Self {
        self.base.multipleSelectionBackgroundView = multipleSelectionBackgroundView
        return self
    }
    
    @discardableResult
    public func selectionStyle(_ selectionStyle: UITableViewCell.SelectionStyle) -> Self {
        self.base.selectionStyle = selectionStyle
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
    public func showsReorderControl(_ showsReorderControl: Bool) -> Self {
        self.base.showsReorderControl = showsReorderControl
        return self
    }
    
    @discardableResult
    public func shouldIndentWhileEditing(_ shouldIndentWhileEditing: Bool) -> Self {
        self.base.shouldIndentWhileEditing = shouldIndentWhileEditing
        return self
    }
    
    @discardableResult
    public func accessoryType(_ accessoryType: UITableViewCell.AccessoryType) -> Self {
        self.base.accessoryType = accessoryType
        return self
    }
    
    @discardableResult
    public func accessoryView(_ accessoryView: UIView?) -> Self {
        self.base.accessoryView = accessoryView
        return self
    }
    
    @discardableResult
    public func editingAccessoryType(_ editingAccessoryType: UITableViewCell.AccessoryType) -> Self {
        self.base.editingAccessoryType = editingAccessoryType
        return self
    }
    
    @discardableResult
    public func editingAccessoryView(_ editingAccessoryView: UIView?) -> Self {
        self.base.editingAccessoryView = editingAccessoryView
        return self
    }
    
    @discardableResult
    public func indentationLevel(_ indentationLevel: Int) -> Self {
        self.base.indentationLevel = indentationLevel
        return self
    }
    
    @discardableResult
    public func indentationWidth(_ indentationWidth: CGFloat) -> Self {
        self.base.indentationWidth = indentationWidth
        return self
    }
    
    @discardableResult
    public func separatorInset(_ separatorInset: UIEdgeInsets) -> Self {
        self.base.separatorInset = separatorInset
        return self
    }
    
    @discardableResult
    public func isEditing(_ isEditing: Bool) -> Self {
        self.base.isEditing = isEditing
        return self
    }
    
    @discardableResult
    public func focusStyle(_ focusStyle: UITableViewCell.FocusStyle) -> Self {
        self.base.focusStyle = focusStyle
        return self
    }
    
    @available(iOS 11.0, *)
    @discardableResult
    public func userInteractionEnabledWhileDragging(_ userInteractionEnabledWhileDragging: Bool) -> Self {
        self.base.userInteractionEnabledWhileDragging = userInteractionEnabledWhileDragging
        return self
    }
    
    @available(iOS 14.0, tvOS 14.0, *)
    @discardableResult
    public func contentConfiguration(_ contentConfiguration: UIContentConfiguration?) -> Self {
        self.base.contentConfiguration = contentConfiguration
        return self
    }
    
    @available(iOS 14.0, tvOS 14.0, *)
    @discardableResult
    public func backgroundConfiguration(_ backgroundConfiguration: UIBackgroundConfiguration?) -> Self {
        self.base.backgroundConfiguration = backgroundConfiguration
        return self
    }
}
