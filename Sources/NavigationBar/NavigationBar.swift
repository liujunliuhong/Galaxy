//
//  NavigationBar.swift
//  SwiftTool
//
//  Created by liujun on 2021/5/24.
//  Copyright © 2021 yinhe. All rights reserved.
//

import UIKit
import SnapKit

private struct AssociatedKeys {
    static var layerKey = "com.galaxy.navigationBar.backgroundLayer.key"
    static var viewKey = "com.galaxy.navigationBar.backgroundView.key"
}


/// 自定义导航栏
/// 支持AutoLayout和Frame布局。注意：必须设置宽度
open class NavigationBar: UIView {
    deinit {
        removeNotification()
        #if DEBUG
        print("\(NSStringFromClass(self.classForCoder)) deinit")
        #endif
        
    }
    
    public private(set) lazy var barView: UIView = {
        let barView = UIView()
        barView.backgroundColor = .clear
        return barView
    }()
    
    public private(set) lazy var seperateLineView: UIView = {
        let lineView = UIView()
        return lineView
    }()
    
    public private(set) lazy var toolView: UIView = {
        let toolView = UIView()
        toolView.backgroundColor = .clear
        return toolView
    }()
    
    /// bar的高度，系统的永远是44.0，可以手动更改此高度
    public var barHeight: CGFloat = 44.0 {
        didSet {
            self.refresh()
        }
    }
    /// 工具栏高度
    public var toolHeight: CGFloat = 0.0 {
        didSet {
            self.refresh()
        }
    }
    /// 左边的`items`
    public var leftItems: [NavigationBarButtonItem]? {
        didSet {
            self.refresh()
        }
    }
    /// 右边的items
    public var rightItems: [NavigationBarButtonItem]? {
        didSet {
            self.refresh()
        }
    }
    /// 导航栏标题
    public var title: NavigationTitleItem? {
        didSet {
            self.refresh()
        }
    }
    /// 背景Layer
    public var backgroundLayer: CALayer? {
        didSet {
            self.refresh()
        }
    }
    /// 背景View
    public var backgroundView: UIView? {
        didSet {
            self.refresh()
        }
    }
    /// 是否隐藏整个自定义导航栏，默认true
    public var hideNavigationBar: Bool = true {  // contains all
        didSet {
            self.refresh()
        }
    }
    
    /// 是否隐藏bar，默认false
    public var hideBar: Bool = false {
        didSet {
            self.refresh()
        }
    }
    /// 是否隐藏工具栏
    public var hideToolBar: Bool = false {
        didSet {
            self.refresh()
        }
    }
    
    public var seperateLineColor: UIColor = GL.rgba(R: 162, G: 168, B: 195, A: 0.7) {
        didSet {
            self.seperateLineView.backgroundColor = seperateLineColor
        }
    }
    
    public var seperateLineHeight: CGFloat = 0.5 {
        didSet {
            self.refresh()
        }
    }
    
    /// `contentSize`
    private var contentSize: CGSize = .zero
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        addNotification()
        setupUI()
    }
    
    public init() {
        super.init(frame: .zero)
        addNotification()
        setupUI()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NavigationBar {
    private func setupUI() {
        self.addSubview(self.seperateLineView)
        self.addSubview(self.barView)
        self.addSubview(self.toolView)
        self.seperateLineView.backgroundColor = self.seperateLineColor
    }
    
    private func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(orientationDidChange), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    private func removeNotification() {
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }
}

extension NavigationBar {
    @objc private func orientationDidChange() {
        self.refresh()
    }
}

extension NavigationBar {
    open override func layoutIfNeeded() {
        super.layoutIfNeeded()
        self.subviews.forEach { (view) in
            view.layoutIfNeeded()
        }
    }
    
    open override var intrinsicContentSize: CGSize {
        return self.contentSize
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.contentSize = self.reloadUI()
        self.invalidateIntrinsicContentSize()
    }
}

extension NavigationBar {
    @discardableResult
    private func reloadUI() -> CGSize {
        if self.hideNavigationBar || self.bounds.width.isLessThanOrEqualTo(.zero) {
            self.barView.subviews.forEach { (v) in
                v.removeFromSuperview()
            }
            self.barView.isHidden = true
            self.toolView.isHidden = true
            self.lineView.isHidden = true
            self.barView.frame = .zero
            self.toolView.frame = .zero
            self.lineView.frame = .zero
            return .zero
        }
        
        self.lineView.isHidden = false
        
        let o_x: CGFloat = .zero
        let barWidth: CGFloat = self.bounds.width
        var sumHeight: CGFloat = GL.deviceStatusBarHeight
        
        
        // bar view
        
        self.barView.subviews.forEach { (view) in
            view.removeFromSuperview() // remove
        }
        if !self.hideBar {
            self.barView.isHidden = false
            self.barView.frame = CGRect(x: o_x, y: sumHeight, width: barWidth, height: self.barHeight)
            sumHeight += self.barHeight
        } else {
            self.barView.isHidden = true
            self.barView.frame = .zero
        }
        
        
        // tool view
        self.toolView.subviews.forEach { (view) in
            view.removeFromSuperview() // remove
        }
        if !self.hideToolBar && !self.toolHeight.isLessThanOrEqualTo(.zero) {
            self.toolView.isHidden = false
            self.toolView.frame = CGRect(x: o_x, y: sumHeight, width: barWidth, height: self.toolHeight)
            sumHeight += self.toolHeight
        } else {
            self.toolView.isHidden = true
            self.toolView.frame = .zero
        }
        
        let size = CGSize(width: self.bounds.width, height: sumHeight)
        
        
        if !self.hideBar {
            // left items
            var leftDistance: CGFloat = .zero
            for (_, item) in (self.leftItems ?? []).enumerated() {
                if let item = item as? GLCusNaviBarButtonItem, let view = item.view {
                    switch item.layoutType {
                        case .custom(let width, let height):
                            let y = (self.barHeight - height) / 2.0
                            view.frame = CGRect(x: leftDistance, y: y, width: width, height: height)
                            leftDistance += width
                        case .auto:
                            let _size: CGSize = view.intrinsicContentSize
                            var _width: CGFloat = _size.width
                            var _height: CGFloat = _size.height
                            if _width.isLessThanOrEqualTo(.zero) {
                                _width = .zero
                            }
                            if self.barHeight.isLessThanOrEqualTo(_height) {
                                _height = self.barHeight
                            }
                            // item垂直居中显示。如果item的高度高于了`barHeight`，则取`barHeight`的高度
                            view.frame = CGRect(x: leftDistance, y: (self.barHeight - _height) / 2.0, width: _width, height: _height)
                            leftDistance += _width
                    }
                    self.barView.addSubview(view)
                } else if let item = item as? GLCusNaviBarSpace {
                    leftDistance += item.space
                }
            }
            
            
            // right items
            var rightDistance: CGFloat = .zero
            for (_, item) in (self.rightItems ?? []).enumerated().reversed() {
                if let item = item as? GLCusNaviBarButtonItem, let view = item.view {
                    switch item.layoutType {
                        case .custom(let width, let height):
                            let y = (self.barHeight - height) / 2.0
                            view.frame = CGRect(x: barWidth - rightDistance - width, y: y, width: width, height: height)
                            rightDistance += width
                        case .auto:
                            let _size: CGSize = view.intrinsicContentSize
                            var _width: CGFloat = _size.width
                            var _height: CGFloat = _size.height
                            if _width.isLessThanOrEqualTo(.zero) {
                                _width = .zero
                            }
                            if self.barHeight.isLessThanOrEqualTo(_height) {
                                _height = self.barHeight
                            }
                            // item垂直居中显示。如果item的高度高于了`barHeight`，则取`barHeight`的高度
                            view.frame = CGRect(x: barWidth - rightDistance - _width, y: (self.barHeight - _height) / 2.0, width: _width, height: _height)
                            rightDistance += _width
                    }
                    
                    self.barView.addSubview(view)
                    
                } else if let item = item as? GLCusNaviBarSpace {
                    rightDistance += item.space
                }
            }
            
            
            // title view
            let maxTitleWidth: CGFloat = (barWidth / 2.0 - max(leftDistance, rightDistance)) * 2.0;
            if let title = self.title, let view = title.view, !maxTitleWidth.isLessThanOrEqualTo(.zero) {
                switch title.layoutType {
                    case .center:
                        let h: CGFloat = self.barHeight
                        let w: CGFloat = maxTitleWidth
                        view.center = CGPoint(x: barWidth / 2.0, y: (self.barHeight / 2.0))
                        view.bounds = CGRect(x: 0, y: 0, width: w, height: h)
                    case .fill:
                        view.frame = CGRect(x: leftDistance, y: 0, width: barWidth - leftDistance - rightDistance, height: self.barHeight)
                }
                self.barView.addSubview(view)
            }
        }
        
        // line view
        if !self.hideBar {
            self.lineView.frame = CGRect(x: o_x, y: self.barView.gl.bottom - self.lineHeight, width: barWidth, height: self.lineHeight)
        }
        
        
        // backgroundView
        let tmpBackgroundView = objc_getAssociatedObject(self, &GLCusNavigationBarAssociatedKeys.viewKey) as? UIView
        tmpBackgroundView?.removeFromSuperview()
        if let backgroundView = self.backgroundView {
            objc_setAssociatedObject(self, &GLCusNavigationBarAssociatedKeys.viewKey, backgroundView, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            backgroundView.frame = self.bounds
            self.insertSubview(backgroundView, at: 0)
        }
        // backgroundLayer
        let tmpBackgroundLayer = objc_getAssociatedObject(self, &GLCusNavigationBarAssociatedKeys.layerKey) as? CALayer
        tmpBackgroundLayer?.removeFromSuperlayer()
        if let backgroundLayer = self.backgroundLayer {
            objc_setAssociatedObject(self, &GLCusNavigationBarAssociatedKeys.layerKey, backgroundLayer, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            backgroundLayer.frame = self.bounds
            self.layer.insertSublayer(backgroundLayer, at: 0)
        }
        
        return size
    }
}

extension NavigationBar {
    /// 刷新界面
    public func refresh() {
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
}
