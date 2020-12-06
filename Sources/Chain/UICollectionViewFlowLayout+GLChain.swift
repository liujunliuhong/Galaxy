//
//  UICollectionViewFlowLayout+GLChain.swift
//  SwiftTool
//
//  Created by galaxy on 2020/12/6.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import UIKit

extension GLChain where Base: UICollectionViewFlowLayout {
    
    @discardableResult
    public func minimumLineSpacing(_ minimumLineSpacing: CGFloat) -> Self {
        self.base.minimumLineSpacing = minimumLineSpacing
        return self
    }
    
    @discardableResult
    public func minimumInteritemSpacing(_ minimumInteritemSpacing: CGFloat) -> Self {
        self.base.minimumInteritemSpacing = minimumInteritemSpacing
        return self
    }
    
    @discardableResult
    public func itemSize(_ itemSize: CGSize) -> Self {
        self.base.itemSize = itemSize
        return self
    }
    
    @discardableResult
    public func estimatedItemSize(_ estimatedItemSize: CGSize) -> Self {
        self.base.estimatedItemSize = estimatedItemSize
        return self
    }
    
    @discardableResult
    public func scrollDirection(_ scrollDirection: UICollectionView.ScrollDirection) -> Self {
        self.base.scrollDirection = scrollDirection
        return self
    }
    
    @discardableResult
    public func headerReferenceSize(_ headerReferenceSize: CGSize) -> Self {
        self.base.headerReferenceSize = headerReferenceSize
        return self
    }
    
    @discardableResult
    public func footerReferenceSize(_ footerReferenceSize: CGSize) -> Self {
        self.base.footerReferenceSize = footerReferenceSize
        return self
    }
    
    @discardableResult
    public func sectionInset(_ sectionInset: UIEdgeInsets) -> Self {
        self.base.sectionInset = sectionInset
        return self
    }
    
    @available(iOS 11.0, *)
    @discardableResult
    public func sectionInsetReference(_ sectionInsetReference: UICollectionViewFlowLayout.SectionInsetReference) -> Self {
        self.base.sectionInsetReference = sectionInsetReference
        return self
    }
    
    @discardableResult
    public func sectionHeadersPinToVisibleBounds(_ sectionHeadersPinToVisibleBounds: Bool) -> Self {
        self.base.sectionHeadersPinToVisibleBounds = sectionHeadersPinToVisibleBounds
        return self
    }
    
    @discardableResult
    public func sectionFootersPinToVisibleBounds(_ sectionFootersPinToVisibleBounds: Bool) -> Self {
        self.base.sectionFootersPinToVisibleBounds = sectionFootersPinToVisibleBounds
        return self
    }
}
