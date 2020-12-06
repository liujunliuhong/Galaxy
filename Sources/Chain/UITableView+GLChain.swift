//
//  UITableView+GLChain.swift
//  SwiftTool
//
//  Created by Yule on 2020/12/4.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import UIKit

extension GLChain where Base: UITableView {
    
    @discardableResult
    public func delegate(_ delegate: UITableViewDelegate?) -> Self {
        self.base.delegate = delegate
        return self
    }
    
    @discardableResult
    public func dataSource(_ dataSource: UITableViewDataSource?) -> Self {
        self.base.dataSource = dataSource
        return self
    }
    
    @available(iOS 10.0, *)
    @discardableResult
    public func prefetchDataSource(_ prefetchDataSource: UITableViewDataSourcePrefetching?) -> Self {
        self.base.prefetchDataSource = prefetchDataSource
        return self
    }
    
    @available(iOS 11.0, *)
    @discardableResult
    public func dragDelegate(_ dragDelegate: UITableViewDragDelegate?) -> Self {
        self.base.dragDelegate = dragDelegate
        return self
    }
    
    @available(iOS 11.0, *)
    @discardableResult
    public func dropDelegate(_ dropDelegate: UITableViewDropDelegate?) -> Self {
        self.base.dropDelegate = dropDelegate
        return self
    }
    
    @discardableResult
    public func rowHeight(_ rowHeight: CGFloat) -> Self {
        self.base.rowHeight = rowHeight
        return self
    }
    
    @discardableResult
    public func sectionHeaderHeight(_ sectionHeaderHeight: CGFloat) -> Self {
        self.base.sectionHeaderHeight = sectionHeaderHeight
        return self
    }
    
    @discardableResult
    public func sectionFooterHeight(_ sectionFooterHeight: CGFloat) -> Self {
        self.base.sectionFooterHeight = sectionFooterHeight
        return self
    }
    
    @discardableResult
    public func estimatedRowHeight(_ estimatedRowHeight: CGFloat) -> Self {
        self.base.estimatedRowHeight = estimatedRowHeight
        return self
    }
    
    @discardableResult
    public func estimatedSectionHeaderHeight(_ estimatedSectionHeaderHeight: CGFloat) -> Self {
        self.base.estimatedSectionHeaderHeight = estimatedSectionHeaderHeight
        return self
    }
    
    @discardableResult
    public func estimatedSectionFooterHeight(_ estimatedSectionFooterHeight: CGFloat) -> Self {
        self.base.estimatedSectionFooterHeight = estimatedSectionFooterHeight
        return self
    }
    
    @discardableResult
    public func separatorInset(_ separatorInset: UIEdgeInsets) -> Self {
        self.base.separatorInset = separatorInset
        return self
    }
    
    @available(iOS 11.0, *)
    @discardableResult
    public func separatorInsetReference(_ separatorInsetReference: UITableView.SeparatorInsetReference) -> Self {
        self.base.separatorInsetReference = separatorInsetReference
        return self
    }
    
    @discardableResult
    public func backgroundView(_ backgroundView: UIView?) -> Self {
        self.base.backgroundView = backgroundView
        return self
    }
    
    @discardableResult
    public func isEditing(_ isEditing: Bool) -> Self {
        self.base.isEditing = isEditing
        return self
    }
    
    @discardableResult
    public func allowsSelection(_ allowsSelection: Bool) -> Self {
        self.base.allowsSelection = allowsSelection
        return self
    }
    
    @discardableResult
    public func allowsSelectionDuringEditing(_ allowsSelectionDuringEditing: Bool) -> Self {
        self.base.allowsSelectionDuringEditing = allowsSelectionDuringEditing
        return self
    }
    
    @discardableResult
    public func allowsMultipleSelection(_ allowsMultipleSelection: Bool) -> Self {
        self.base.allowsMultipleSelection = allowsMultipleSelection
        return self
    }
    
    @discardableResult
    public func allowsMultipleSelectionDuringEditing(_ allowsMultipleSelectionDuringEditing: Bool) -> Self {
        self.base.allowsMultipleSelectionDuringEditing = allowsMultipleSelectionDuringEditing
        return self
    }
    
    @discardableResult
    public func sectionIndexMinimumDisplayRowCount(_ sectionIndexMinimumDisplayRowCount: Int) -> Self {
        self.base.sectionIndexMinimumDisplayRowCount = sectionIndexMinimumDisplayRowCount
        return self
    }
    
    @discardableResult
    public func sectionIndexColor(_ sectionIndexColor: UIColor?) -> Self {
        self.base.sectionIndexColor = sectionIndexColor
        return self
    }
    
    @discardableResult
    public func sectionIndexBackgroundColor(_ sectionIndexBackgroundColor: UIColor?) -> Self {
        self.base.sectionIndexBackgroundColor = sectionIndexBackgroundColor
        return self
    }
    
    @discardableResult
    public func sectionIndexTrackingBackgroundColor(_ sectionIndexTrackingBackgroundColor: UIColor?) -> Self {
        self.base.sectionIndexTrackingBackgroundColor = sectionIndexTrackingBackgroundColor
        return self
    }
    
    @discardableResult
    public func separatorStyle(_ separatorStyle: UITableViewCell.SeparatorStyle) -> Self {
        self.base.separatorStyle = separatorStyle
        return self
    }
    
    @discardableResult
    public func separatorColor(_ separatorColor: UIColor?) -> Self {
        self.base.separatorColor = separatorColor
        return self
    }
    
    @discardableResult
    public func separatorEffect(_ separatorEffect: UIVisualEffect?) -> Self {
        self.base.separatorEffect = separatorEffect
        return self
    }
    
    @discardableResult
    public func cellLayoutMarginsFollowReadableWidth(_ cellLayoutMarginsFollowReadableWidth: Bool) -> Self {
        self.base.cellLayoutMarginsFollowReadableWidth = cellLayoutMarginsFollowReadableWidth
        return self
    }
    
    @available(iOS 11.0, *)
    @discardableResult
    public func insetsContentViewsToSafeArea(_ insetsContentViewsToSafeArea: Bool) -> Self {
        self.base.insetsContentViewsToSafeArea = insetsContentViewsToSafeArea
        return self
    }
    
    @discardableResult
    public func tableHeaderView(_ tableHeaderView: UIView?) -> Self {
        self.base.tableHeaderView = tableHeaderView
        return self
    }
    
    @discardableResult
    public func tableFooterView(_ tableFooterView: UIView?) -> Self {
        self.base.tableFooterView = tableFooterView
        return self
    }
    
    @discardableResult
    public func register(_ nib: UINib?, forCellReuseIdentifier identifier: String) -> Self {
        self.base.register(nib, forCellReuseIdentifier: identifier)
        return self
    }
    
    @discardableResult
    public func register(_ cellClass: AnyClass?, forCellReuseIdentifier identifier: String) -> Self {
        self.base.register(cellClass, forCellReuseIdentifier: identifier)
        return self
    }
    
    @discardableResult
    public func register(_ nib: UINib?, forHeaderFooterViewReuseIdentifier identifier: String) -> Self {
        self.base.register(nib, forHeaderFooterViewReuseIdentifier: identifier)
        return self
    }
    
    @discardableResult
    public func register(_ aClass: AnyClass?, forHeaderFooterViewReuseIdentifier identifier: String) -> Self {
        self.base.register(aClass, forHeaderFooterViewReuseIdentifier: identifier)
        return self
    }
    
    @discardableResult
    public func remembersLastFocusedIndexPath(_ remembersLastFocusedIndexPath: Bool) -> Self {
        self.base.remembersLastFocusedIndexPath = remembersLastFocusedIndexPath
        return self
    }
    
    @available(iOS 14.0, *)
    @discardableResult
    public func selectionFollowsFocus(_ selectionFollowsFocus: Bool) -> Self {
        self.base.selectionFollowsFocus = selectionFollowsFocus
        return self
    }
    
    @available(iOS 11.0, *)
    @discardableResult
    public func dragInteractionEnabled(_ dragInteractionEnabled: Bool) -> Self {
        self.base.dragInteractionEnabled = dragInteractionEnabled
        return self
    }
}
