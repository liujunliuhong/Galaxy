//
//  UIPageControl+GLChain.swift
//  SwiftTool
//
//  Created by Yule on 2020/12/4.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import UIKit

extension GLChain where Base: UIPageControl {
    @discardableResult
    public func numberOfPages(_ numberOfPages: Int) -> Self {
        self.base.numberOfPages = numberOfPages
        return self
    }
    
    @discardableResult
    public func currentPage(_ currentPage: Int) -> Self {
        self.base.currentPage = currentPage
        return self
    }
    
    @discardableResult
    public func hidesForSinglePage(_ hidesForSinglePage: Bool) -> Self {
        self.base.hidesForSinglePage = hidesForSinglePage
        return self
    }
    
    @discardableResult
    public func pageIndicatorTintColor(_ pageIndicatorTintColor: UIColor?) -> Self {
        self.base.pageIndicatorTintColor = pageIndicatorTintColor
        return self
    }
    
    @discardableResult
    public func currentPageIndicatorTintColor(_ currentPageIndicatorTintColor: UIColor?) -> Self {
        self.base.currentPageIndicatorTintColor = currentPageIndicatorTintColor
        return self
    }
    
    @available(iOS 14.0, *)
    @discardableResult
    public func backgroundStyle(_ backgroundStyle: UIPageControl.BackgroundStyle) -> Self {
        self.base.backgroundStyle = backgroundStyle
        return self
    }
    
    @available(iOS 14.0, *)
    @discardableResult
    public func allowsContinuousInteraction(_ allowsContinuousInteraction: Bool) -> Self {
        self.base.allowsContinuousInteraction = allowsContinuousInteraction
        return self
    }
    
    @available(iOS 14.0, *)
    @discardableResult
    public func preferredIndicatorImage(_ preferredIndicatorImage: UIImage?) -> Self {
        self.base.preferredIndicatorImage = preferredIndicatorImage
        return self
    }
    
    @available(iOS 14.0, *)
    @discardableResult
    public func setIndicatorImage(_ image: UIImage?, forPage page: Int) -> Self {
        self.base.setIndicatorImage(image, forPage: page)
        return self
    }
}
