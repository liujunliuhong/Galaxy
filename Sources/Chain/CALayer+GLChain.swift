//
//  CALayer+GLChain.swift
//  SwiftTool
//
//  Created by Yule on 2020/12/4.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import UIKit

extension GLChain where Base: CALayer {
    
    @discardableResult
    public func bounds(_ bounds: CGRect) -> Self {
        self.base.bounds = bounds
        return self
    }
    
    @discardableResult
    public func borderWidth(_ borderWidth: CGFloat) -> Self {
        self.base.borderWidth = borderWidth
        return self
    }
    
    @discardableResult
    public func borderColor(_ borderColor: UIColor?) -> Self {
        self.base.borderColor = borderColor?.cgColor
        return self
    }
    
    @discardableResult
    public func shadowColor(_ shadowColor: UIColor?) -> Self {
        self.base.shadowColor = shadowColor?.cgColor
        return self
    }
    
    @discardableResult
    public func shadowRadius(_ shadowRadius: CGFloat) -> Self {
        self.base.shadowRadius = shadowRadius
        return self
    }
    
    @discardableResult
    public func shadowOffset(_ shadowOffset: CGSize) -> Self {
        self.base.shadowOffset = shadowOffset
        return self
    }
    
    @discardableResult
    public func shadowOpacity(_ shadowOpacity: Float) -> Self {
        self.base.shadowOpacity = shadowOpacity
        return self
    }
    
    @discardableResult
    public func shadowPath(_ shadowPath: CGPath?) -> Self {
        self.base.shadowPath = shadowPath
        return self
    }
    
    @discardableResult
    public func position(_ position: CGPoint) -> Self {
        self.base.position = position
        return self
    }
    
    @discardableResult
    public func zPosition(_ zPosition: CGFloat) -> Self {
        self.base.zPosition = zPosition
        return self
    }
    
    @discardableResult
    public func anchorPoint(_ anchorPoint: CGPoint) -> Self {
        self.base.anchorPoint = anchorPoint
        return self
    }
    
    @discardableResult
    public func anchorPointZ(_ anchorPointZ: CGFloat) -> Self {
        self.base.anchorPointZ = anchorPointZ
        return self
    }
    
    @discardableResult
    public func transform(_ transform: CATransform3D) -> Self {
        self.base.transform = transform
        return self
    }
    
    @discardableResult
    public func frame(_ frame: CGRect) -> Self {
        self.base.frame = frame
        return self
    }
    
    @discardableResult
    public func isHidden(_ isHidden: Bool) -> Self {
        self.base.isHidden = isHidden
        return self
    }
    
    @discardableResult
    public func isDoubleSided(_ isDoubleSided: Bool) -> Self {
        self.base.isDoubleSided = isDoubleSided
        return self
    }
    
    @discardableResult
    public func isGeometryFlipped(_ isGeometryFlipped: Bool) -> Self {
        self.base.isGeometryFlipped = isGeometryFlipped
        return self
    }
    
    @discardableResult
    public func mask(_ mask: CALayer?) -> Self {
        self.base.mask = mask
        return self
    }
    
    @discardableResult
    public func masksToBounds(_ masksToBounds: Bool) -> Self {
        self.base.masksToBounds = masksToBounds
        return self
    }
    
    @discardableResult
    public func contents(_ contents: Any?) -> Self {
        self.base.contents = contents
        return self
    }
    
    @discardableResult
    public func contentsRect(_ contentsRect: CGRect) -> Self {
        self.base.contentsRect = contentsRect
        return self
    }
    
    @discardableResult
    public func contentsGravity(_ contentsGravity: CALayerContentsGravity) -> Self {
        self.base.contentsGravity = contentsGravity
        return self
    }
    
    @discardableResult
    public func contentsScale(_ contentsScale: CGFloat) -> Self {
        self.base.contentsScale = contentsScale
        return self
    }
    
    @discardableResult
    public func contentsCenter(_ contentsCenter: CGRect) -> Self {
        self.base.contentsCenter = contentsCenter
        return self
    }
    
    @available(iOS 10.0, *)
    @discardableResult
    public func contentsFormat(_ contentsFormat: CALayerContentsFormat) -> Self {
        self.base.contentsFormat = contentsFormat
        return self
    }
    
    @discardableResult
    public func minificationFilter(_ minificationFilter: CALayerContentsFilter) -> Self {
        self.base.minificationFilter = minificationFilter
        return self
    }
    
    
    @discardableResult
    public func magnificationFilter(_ magnificationFilter: CALayerContentsFilter) -> Self {
        self.base.magnificationFilter = magnificationFilter
        return self
    }
    
    @discardableResult
    public func minificationFilterBias(_ minificationFilterBias: Float) -> Self {
        self.base.minificationFilterBias = minificationFilterBias
        return self
    }
    
    @discardableResult
    public func isOpaque(_ isOpaque: Bool) -> Self {
        self.base.isOpaque = isOpaque
        return self
    }
    
    @discardableResult
    public func needsDisplayOnBoundsChange(_ needsDisplayOnBoundsChange: Bool) -> Self {
        self.base.needsDisplayOnBoundsChange = needsDisplayOnBoundsChange
        return self
    }
    
    @discardableResult
    public func drawsAsynchronously(_ drawsAsynchronously: Bool) -> Self {
        self.base.drawsAsynchronously = drawsAsynchronously
        return self
    }
    
    @discardableResult
    public func edgeAntialiasingMask(_ edgeAntialiasingMask: CAEdgeAntialiasingMask) -> Self {
        self.base.edgeAntialiasingMask = edgeAntialiasingMask
        return self
    }
    
    @discardableResult
    public func allowsEdgeAntialiasing(_ allowsEdgeAntialiasing: Bool) -> Self {
        self.base.allowsEdgeAntialiasing = allowsEdgeAntialiasing
        return self
    }
    
    @discardableResult
    public func backgroundColor(_ backgroundColor: UIColor?) -> Self {
        self.base.backgroundColor = backgroundColor?.cgColor
        return self
    }
    
    @discardableResult
    public func cornerRadius(_ cornerRadius: CGFloat) -> Self {
        self.base.cornerRadius = cornerRadius
        return self
    }
    
    @available(iOS 11.0, *)
    @discardableResult
    public func maskedCorners(_ maskedCorners: CACornerMask) -> Self {
        self.base.maskedCorners = maskedCorners
        return self
    }
    
    @available(iOS 13.0, *)
    @discardableResult
    public func maskedCorners(_ cornerCurve: CALayerCornerCurve) -> Self {
        self.base.cornerCurve = cornerCurve
        return self
    }
    
    @discardableResult
    public func opacity(_ opacity: Float) -> Self {
        self.base.opacity = opacity
        return self
    }
    
    @discardableResult
    public func allowsGroupOpacity(_ allowsGroupOpacity: Bool) -> Self {
        self.base.allowsGroupOpacity = allowsGroupOpacity
        return self
    }
    
    @discardableResult
    public func compositingFilter(_ compositingFilter: Any?) -> Self {
        self.base.compositingFilter = compositingFilter
        return self
    }
    
    @discardableResult
    public func filters(_ filters: [Any]?) -> Self {
        self.base.filters = filters
        return self
    }
    
    @discardableResult
    public func backgroundFilters(_ backgroundFilters: [Any]?) -> Self {
        self.base.backgroundFilters = backgroundFilters
        return self
    }
    
    @discardableResult
    public func shouldRasterize(_ shouldRasterize: Bool) -> Self {
        self.base.shouldRasterize = shouldRasterize
        return self
    }
    
    @discardableResult
    public func rasterizationScale(_ rasterizationScale: CGFloat) -> Self {
        self.base.rasterizationScale = rasterizationScale
        return self
    }
    
    @discardableResult
    public func actions(_ actions: [String : CAAction]?) -> Self {
        self.base.actions = actions
        return self
    }
    
    @discardableResult
    public func name(_ name: String?) -> Self {
        self.base.name = name
        return self
    }
    
    @discardableResult
    public func delegate(_ delegate: CALayerDelegate?) -> Self {
        self.base.delegate = delegate
        return self
    }
    
    @discardableResult
    public func style(_ style: [AnyHashable : Any]?) -> Self {
        self.base.style = style
        return self
    }
}
