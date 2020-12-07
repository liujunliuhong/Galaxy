//
//  UICollectionViewCell+GLChain.swift
//  SwiftTool
//
//  Created by Yule on 2020/12/7.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import UIKit

extension GLChain where Base: UICollectionViewCell {
    
    @available(iOS 14.0, *)
    @discardableResult
    public func automaticallyUpdatesContentConfiguration(_ automaticallyUpdatesContentConfiguration: Bool) -> Self {
        self.base.automaticallyUpdatesContentConfiguration = automaticallyUpdatesContentConfiguration
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
