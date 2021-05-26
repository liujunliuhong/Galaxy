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
    
    private var containerHeight: CGFloat = .zero
    private var containerWidth: CGFloat = .zero
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        addNotification()
        setupUI()
    }
    
    public private(set) weak var viewController: UIViewController?
    
    public init(viewController: UIViewController) {
        super.init(frame: .zero)
        viewController = viewController
        containerWidth = viewController.view.bounds.width
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
        let o_x: CGFloat = .zero
        var leftDistance: CGFloat = .zero
        for (_, item) in (self.leftItems ?? []).enumerated() {
            if let customView = item.customView {
                switch item.constraintsType {
                case .auto:
                    let _size: CGSize = customView.intrinsicContentSize
                    var _width: CGFloat = _size.width
                    var _height: CGFloat = _size.height
                    if _width.isLessThanOrEqualTo(.zero) {
                        _width = .zero
                    }
                    if barHeight.isLessThanOrEqualTo(_height) {
                        _height = self.barHeight
                    }
                    customView.frame = CGRect(x: leftDistance, y: (barHeight - _height) / 2.0, width: _width, height: _height)
                    leftDistance += _width
                    barView.addSubview(customView)
                case .size(let width, let height):
                    print("2")
                    
                }
            } else {
                switch item.constraintsType {
                case .auto:
                    print("1")
                case .size(let width, let height):
                    print("2")
                }
            }
            
            
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
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
}
