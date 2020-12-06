//
//  UIScrollView+GLChain.swift
//  SwiftTool
//
//  Created by Yule on 2020/12/4.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import UIKit

extension GLChain where Base: UIScrollView {
    
    @discardableResult
    public func contentOffset(_ contentOffset: CGPoint) -> Self {
        self.base.contentOffset = contentOffset
        return self
    }
    
    @discardableResult
    public func contentSize(_ contentSize: CGSize) -> Self {
        self.base.contentSize = contentSize
        return self
    }
    
    @discardableResult
    public func contentInset(_ contentInset: UIEdgeInsets) -> Self {
        self.base.contentInset = contentInset
        return self
    }
    
    @available(iOS 11.0, *)
    @discardableResult
    public func contentInsetAdjustmentBehavior(_ contentInsetAdjustmentBehavior: UIScrollView.ContentInsetAdjustmentBehavior) -> Self {
        self.base.contentInsetAdjustmentBehavior = contentInsetAdjustmentBehavior
        return self
    }
    
    @available(iOS 13.0, *)
    @discardableResult
    public func automaticallyAdjustsScrollIndicatorInsets(_ automaticallyAdjustsScrollIndicatorInsets: Bool) -> Self {
        self.base.automaticallyAdjustsScrollIndicatorInsets = automaticallyAdjustsScrollIndicatorInsets
        return self
    }
    
    @discardableResult
    public func delegate(_ delegate: UIScrollViewDelegate?) -> Self {
        self.base.delegate = delegate
        return self
    }
    
    @discardableResult
    public func isDirectionalLockEnabled(_ isDirectionalLockEnabled: Bool) -> Self {
        self.base.isDirectionalLockEnabled = isDirectionalLockEnabled
        return self
    }
    
    @discardableResult
    public func bounces(_ bounces: Bool) -> Self {
        self.base.bounces = bounces
        return self
    }
    
    @discardableResult
    public func alwaysBounceVertical(_ alwaysBounceVertical: Bool) -> Self {
        self.base.alwaysBounceVertical = alwaysBounceVertical
        return self
    }
    
    @discardableResult
    public func alwaysBounceHorizontal(_ alwaysBounceHorizontal: Bool) -> Self {
        self.base.alwaysBounceHorizontal = alwaysBounceHorizontal
        return self
    }
    
    @discardableResult
    public func isPagingEnabled(_ isPagingEnabled: Bool) -> Self {
        self.base.isPagingEnabled = isPagingEnabled
        return self
    }
    
    @discardableResult
    public func isScrollEnabled(_ isScrollEnabled: Bool) -> Self {
        self.base.isScrollEnabled = isScrollEnabled
        return self
    }
    
    @discardableResult
    public func showsVerticalScrollIndicator(_ showsVerticalScrollIndicator: Bool) -> Self {
        self.base.showsVerticalScrollIndicator = showsVerticalScrollIndicator
        return self
    }
    
    @discardableResult
    public func showsHorizontalScrollIndicator(_ showsHorizontalScrollIndicator: Bool) -> Self {
        self.base.showsHorizontalScrollIndicator = showsHorizontalScrollIndicator
        return self
    }
    
    @discardableResult
    public func indicatorStyle(_ indicatorStyle: UIScrollView.IndicatorStyle) -> Self {
        self.base.indicatorStyle = indicatorStyle
        return self
    }
    
    @available(iOS 11.1, *)
    @discardableResult
    public func verticalScrollIndicatorInsets(_ verticalScrollIndicatorInsets: UIEdgeInsets) -> Self {
        self.base.verticalScrollIndicatorInsets = verticalScrollIndicatorInsets
        return self
    }
    
    @available(iOS 11.1, *)
    @discardableResult
    public func horizontalScrollIndicatorInsets(_ horizontalScrollIndicatorInsets: UIEdgeInsets) -> Self {
        self.base.horizontalScrollIndicatorInsets = horizontalScrollIndicatorInsets
        return self
    }
    
    @discardableResult
    public func scrollIndicatorInsets(_ scrollIndicatorInsets: UIEdgeInsets) -> Self {
        self.base.scrollIndicatorInsets = scrollIndicatorInsets
        return self
    }
    
    @available(iOS 3.0, *)
    @discardableResult
    public func decelerationRate(_ decelerationRate: UIScrollView.DecelerationRate) -> Self {
        self.base.decelerationRate = decelerationRate
        return self
    }
    
    @discardableResult
    public func indexDisplayMode(_ indexDisplayMode: UIScrollView.IndexDisplayMode) -> Self {
        self.base.indexDisplayMode = indexDisplayMode
        return self
    }
    
    @discardableResult
    public func delaysContentTouches(_ delaysContentTouches: Bool) -> Self {
        self.base.delaysContentTouches = delaysContentTouches
        return self
    }
    
    @discardableResult
    public func canCancelContentTouches(_ canCancelContentTouches: Bool) -> Self {
        self.base.canCancelContentTouches = canCancelContentTouches
        return self
    }
    
    @discardableResult
    public func minimumZoomScale(_ minimumZoomScale: CGFloat) -> Self {
        self.base.minimumZoomScale = minimumZoomScale
        return self
    }
    
    @discardableResult
    public func maximumZoomScale(_ maximumZoomScale: CGFloat) -> Self {
        self.base.maximumZoomScale = maximumZoomScale
        return self
    }
    
    @discardableResult
    public func zoomScale(_ zoomScale: CGFloat) -> Self {
        self.base.zoomScale = zoomScale
        return self
    }
    
    @discardableResult
    public func bouncesZoom(_ bouncesZoom: Bool) -> Self {
        self.base.bouncesZoom = bouncesZoom
        return self
    }
    
    @discardableResult
    public func scrollsToTop(_ scrollsToTop: Bool) -> Self {
        self.base.scrollsToTop = scrollsToTop
        return self
    }
    
    @discardableResult
    public func keyboardDismissMode(_ keyboardDismissMode: UIScrollView.KeyboardDismissMode) -> Self {
        self.base.keyboardDismissMode = keyboardDismissMode
        return self
    }
    
    @available(iOS 10.0, *)
    @discardableResult
    public func refreshControl(_ refreshControl: UIRefreshControl?) -> Self {
        self.base.refreshControl = refreshControl
        return self
    }
}
