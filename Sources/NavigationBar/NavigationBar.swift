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
    
    private lazy var seperateLineView: UIView = {
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
            refresh()
        }
    }
    /// 工具栏高度
    public var toolHeight: CGFloat = 0.0 {
        didSet {
            refresh()
        }
    }
    /// 左边的`items`
    public var leftItems: [NavigationBarButtonItem]? {
        didSet {
            refresh()
        }
    }
    /// 右边的items
    public var rightItems: [NavigationBarButtonItem]? {
        didSet {
            refresh()
        }
    }
    /// 导航栏标题
    public var titleItem: NavigationTitleItem? {
        didSet {
            refresh()
        }
    }
    /// 背景Layer
    public var backgroundLayer: CALayer? {
        didSet {
            refresh()
        }
    }
    /// 背景View
    public var backgroundView: UIView? {
        didSet {
            refresh()
        }
    }
    /// 是否隐藏整个自定义导航栏，默认false
    public var hideNavigationBar: Bool = false {
        didSet {
            refresh()
        }
    }
    
    /// 是否隐藏bar，默认false
    public var hideBar: Bool = false {
        didSet {
            refresh()
        }
    }
    /// 是否隐藏工具栏
    public var hideToolBar: Bool = false {
        didSet {
            refresh()
        }
    }
    
    public var seperateLineColor: UIColor = GL.rgba(R: 162, G: 168, B: 195, A: 0.7) {
        didSet {
            seperateLineView.backgroundColor = seperateLineColor
        }
    }
    
    public var seperateLineHeight: CGFloat = 0.5 {
        didSet {
            refresh()
        }
    }
    
    private var containerHeight: CGFloat = .zero
    private var containerWidth: CGFloat = .zero
    
    public private(set) weak var viewController: UIViewController?
    
    public convenience init(viewController: UIViewController) {
        self.init(frame: .zero)
        self.viewController = viewController
        containerWidth = viewController.view.bounds.width
        addNotification()
        setupUI()
    }
    
    private init() {
        super.init(frame: .zero)
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NavigationBar {
    private func setupUI() {
        addSubview(seperateLineView)
        addSubview(barView)
        addSubview(toolView)
        seperateLineView.backgroundColor = seperateLineColor
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
        refresh()
    }
}

extension NavigationBar {
    open override func layoutIfNeeded() {
        super.layoutIfNeeded()
        subviews.forEach { (view) in
            view.layoutIfNeeded()
        }
    }
    
    open override var intrinsicContentSize: CGSize {
        return CGSize(width: containerWidth, height: containerHeight)
    }
}

extension NavigationBar {
    private func reloadUI() {
        if hideNavigationBar || containerWidth.isLessThanOrEqualTo(.zero) {
            barView.subviews.forEach { (v) in
                v.removeFromSuperview()
            }
            toolView.subviews.forEach { (v) in
                v.removeFromSuperview()
            }
            barView.isHidden = true
            toolView.isHidden = true
            seperateLineView.isHidden = true
            barView.frame = .zero
            toolView.frame = .zero
            seperateLineView.frame = .zero
            return
        }
        //
        seperateLineView.isHidden = false
        //
        var sumHeight: CGFloat = GL.deviceStatusBarHeight
        // bar view
        barView.subviews.forEach { (view) in
            view.removeFromSuperview() // remove
        }
        if !hideBar && !barHeight.isLessThanOrEqualTo(.zero) {
            barView.isHidden = false
            barView.frame = CGRect(x: .zero, y: sumHeight, width: containerWidth, height: barHeight)
            sumHeight += barHeight
        } else {
            barView.isHidden = true
            barView.frame = .zero
        }
        // tool view
        toolView.subviews.forEach { (view) in
            view.removeFromSuperview() // remove
        }
        if !hideToolBar && !toolHeight.isLessThanOrEqualTo(.zero) {
            toolView.isHidden = false
            toolView.frame = CGRect(x: .zero, y: sumHeight, width: containerWidth, height: toolHeight)
            sumHeight += toolHeight
        } else {
            toolView.isHidden = true
            toolView.frame = .zero
        }
        containerHeight = sumHeight
        // bar
        setupBar()
        // line view
        setupSeperateLineView()
        // backgroundView
        setupBackgroundView()
    }
}

extension NavigationBar {
    private func setupBar() {
        if hideBar { return }
        // left items
        var leftDistance: CGFloat = .zero
        for (_, item) in (self.leftItems ?? []).enumerated() {
            if let customView = item.customView {
                let _size: CGSize = customView.intrinsicContentSize
                var _width: CGFloat = item.width
                var _height: CGFloat = item.height
                if item.width.isAuto {
                    _width = _size.width
                }
                if item.height.isAuto {
                    _height = _size.height
                }
                if _width.isLessThanOrEqualTo(.zero) {
                    _width = .zero
                }
                if barHeight.isLessThanOrEqualTo(_height) {
                    _height = barHeight
                }
                
                customView.frame = CGRect(x: leftDistance,
                                          y: (barHeight - _height) / 2.0,
                                          width: _width,
                                          height: _height)
                leftDistance += _width
                barView.addSubview(customView)
            } else {
                var _width: CGFloat = item.width
                if _width.isAuto {
                    _width = .zero
                }
                if _width.isLessThanOrEqualTo(.zero) {
                    _width = .zero
                }
                leftDistance += _width
            }
        }
        
        
        // right items
        var rightDistance: CGFloat = .zero
        for (_, item) in (self.rightItems ?? []).enumerated().reversed() {
            if let customView = item.customView {
                let _size: CGSize = customView.intrinsicContentSize
                var _width: CGFloat = item.width
                var _height: CGFloat = item.height
                if item.width.isAuto {
                    _width = _size.width
                }
                if item.height.isAuto {
                    _height = _size.height
                }
                if _width.isLessThanOrEqualTo(.zero) {
                    _width = .zero
                }
                if barHeight.isLessThanOrEqualTo(_height) {
                    _height = barHeight
                }
                customView.frame = CGRect(x: containerWidth - rightDistance - _width,
                                          y: (barHeight - _height) / 2.0,
                                          width: _width,
                                          height: _height)
                rightDistance += _width
                barView.addSubview(customView)
            } else {
                var _width: CGFloat = item.width
                if _width.isAuto {
                    _width = .zero
                }
                if _width.isLessThanOrEqualTo(.zero) {
                    _width = .zero
                }
                rightDistance += _width
            }
        }
        
        
        // title view
        let maxTitleWidth: CGFloat = (containerWidth / 2.0 - max(leftDistance, rightDistance)) * 2.0;
        
        if let titleItem = titleItem,
           let customView = titleItem.customView,
           !maxTitleWidth.isLessThanOrEqualTo(.zero) {
            switch titleItem.constraintsType {
                case .center(let width, let height):
                    let _size: CGSize = customView.intrinsicContentSize
                    var _width: CGFloat = width
                    var _height: CGFloat = height
                    if width.isAuto {
                        _width = _size.width
                    }
                    if height.isAuto {
                        _height = _size.height
                    }
                    if _width.isLessThanOrEqualTo(.zero) {
                        _width = .zero
                    }
                    if barHeight.isLessThanOrEqualTo(_height) {
                        _height = barHeight
                    }
                    if maxTitleWidth.isLessThanOrEqualTo(_width) {
                        _width = maxTitleWidth
                    }
                    customView.center = CGPoint(x: containerWidth / 2.0,
                                                y: barHeight / 2.0)
                    customView.bounds = CGRect(x: .zero,
                                               y: .zero,
                                               width: _width,
                                               height: _height)
                case .fill:
                    customView.frame = CGRect(x: leftDistance,
                                              y: .zero,
                                              width: containerWidth - leftDistance - rightDistance,
                                              height: barHeight)
            }
            barView.addSubview(customView)
        }
    }
    
    private func setupSeperateLineView() {
        if !hideBar {
            seperateLineView.frame = CGRect(x: .zero,
                                            y: barView.gl.bottom - seperateLineHeight / 2.0,
                                            width: containerWidth,
                                            height: seperateLineHeight)
        } else {
            seperateLineView.frame = .zero
        }
    }
    
    private func setupBackgroundView() {
        let tmpBackgroundView = objc_getAssociatedObject(self, &AssociatedKeys.viewKey) as? UIView
        tmpBackgroundView?.removeFromSuperview()
        if let backgroundView = backgroundView {
            objc_setAssociatedObject(self, &AssociatedKeys.viewKey, backgroundView, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            backgroundView.frame = CGRect(x: 0,
                                          y: 0,
                                          width: containerWidth,
                                          height: containerHeight)
            insertSubview(backgroundView, at: 0)
        }
        // backgroundLayer
        let tmpBackgroundLayer = objc_getAssociatedObject(self, &AssociatedKeys.layerKey) as? CALayer
        tmpBackgroundLayer?.removeFromSuperlayer()
        if let backgroundLayer = backgroundLayer {
            objc_setAssociatedObject(self, &AssociatedKeys.layerKey, backgroundLayer, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            backgroundLayer.frame = CGRect(x: 0,
                                           y: 0,
                                           width: containerWidth,
                                           height: containerHeight)
            layer.insertSublayer(backgroundLayer, at: 0)
        }
    }
}

extension NavigationBar {
    /// 刷新界面
    public func refresh() {
        invalidateIntrinsicContentSize()
        setNeedsLayout()
        layoutIfNeeded()
    }
}
