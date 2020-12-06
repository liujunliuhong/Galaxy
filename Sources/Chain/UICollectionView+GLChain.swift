//
//  UICollectionView+GLChain.swift
//  SwiftTool
//
//  Created by Yule on 2020/12/4.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import UIKit


extension GLChain where Base: UICollectionView {
    
    @discardableResult
    public func collectionViewLayout(_ collectionViewLayout: UICollectionViewLayout) -> Self {
        self.base.collectionViewLayout = collectionViewLayout
        return self
    }
    
    @discardableResult
    public func delegate(_ delegate: UICollectionViewDelegate?) -> Self {
        self.base.delegate = delegate
        return self
    }
    
    @discardableResult
    public func dataSource(_ dataSource: UICollectionViewDataSource?) -> Self {
        self.base.dataSource = dataSource
        return self
    }
    
    @available(iOS 10.0, *)
    @discardableResult
    public func prefetchDataSource(_ prefetchDataSource: UICollectionViewDataSourcePrefetching?) -> Self {
        self.base.prefetchDataSource = prefetchDataSource
        return self
    }
    
    @available(iOS 10.0, *)
    @discardableResult
    public func isPrefetchingEnabled(_ isPrefetchingEnabled: Bool) -> Self {
        self.base.isPrefetchingEnabled = isPrefetchingEnabled
        return self
    }
    
    @available(iOS 11.0, *)
    @discardableResult
    public func dragDelegate(_ dragDelegate: UICollectionViewDragDelegate?) -> Self {
        self.base.dragDelegate = dragDelegate
        return self
    }
    
    @available(iOS 11.0, *)
    @discardableResult
    public func dropDelegate(_ dropDelegate: UICollectionViewDropDelegate?) -> Self {
        self.base.dropDelegate = dropDelegate
        return self
    }
    
    @available(iOS 11.0, *)
    @discardableResult
    public func dragInteractionEnabled(_ dragInteractionEnabled: Bool) -> Self {
        self.base.dragInteractionEnabled = dragInteractionEnabled
        return self
    }
    
    @available(iOS 11.0, *)
    @discardableResult
    public func reorderingCadence(_ reorderingCadence: UICollectionView.ReorderingCadence) -> Self {
        self.base.reorderingCadence = reorderingCadence
        return self
    }
    
    @discardableResult
    public func backgroundView(_ backgroundView: UIView?) -> Self {
        self.base.backgroundView = backgroundView
        return self
    }
    
    @discardableResult
    public func register(_ cellClass: AnyClass?, forCellWithReuseIdentifier identifier: String) -> Self {
        self.base.register(cellClass, forCellWithReuseIdentifier: identifier)
        return self
    }
    
    @discardableResult
    public func register(_ nib: UINib?, forCellWithReuseIdentifier identifier: String) -> Self {
        self.base.register(nib, forCellWithReuseIdentifier: identifier)
        return self
    }
    
    @discardableResult
    public func register(_ viewClass: AnyClass?, forSupplementaryViewOfKind elementKind: String, withReuseIdentifier identifier: String) -> Self {
        self.base.register(viewClass, forSupplementaryViewOfKind: elementKind, withReuseIdentifier: identifier)
        return self
    }
    
    @discardableResult
    public func register(_ nib: UINib?, forSupplementaryViewOfKind kind: String, withReuseIdentifier identifier: String) -> Self {
        self.base.register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: identifier)
        return self
    }
    
    @discardableResult
    public func allowsSelection(_ allowsSelection: Bool) -> Self {
        self.base.allowsSelection = allowsSelection
        return self
    }
    
    @discardableResult
    public func allowsMultipleSelection(_ allowsMultipleSelection: Bool) -> Self {
        self.base.allowsMultipleSelection = allowsMultipleSelection
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
    
    @available(iOS 14.0, *)
    @discardableResult
    public func isEditing(_ isEditing: Bool) -> Self {
        self.base.isEditing = isEditing
        return self
    }
    
    @available(iOS 14.0, *)
    @discardableResult
    public func allowsSelectionDuringEditing(_ allowsSelectionDuringEditing: Bool) -> Self {
        self.base.allowsSelectionDuringEditing = allowsSelectionDuringEditing
        return self
    }
    
    @available(iOS 14.0, *)
    @discardableResult
    public func allowsMultipleSelectionDuringEditing(_ allowsMultipleSelectionDuringEditing: Bool) -> Self {
        self.base.allowsMultipleSelectionDuringEditing = allowsMultipleSelectionDuringEditing
        return self
    }
}
