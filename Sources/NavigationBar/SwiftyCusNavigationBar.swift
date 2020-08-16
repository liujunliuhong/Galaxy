//
//  SwiftyCusNavigationBar.swift
//  SwiftTool
//
//  Created by liujun on 2020/6/9.
//  Copyright © 2020 galaxy. All rights reserved.
//

import UIKit

private struct SwiftyCusNavigationBarAssociatedKeys {
    static var layerKey = "com.galaxy.cusNavigationBar.backgroundLayer.key"
    static var viewKey = "com.galaxy.cusNavigationBar.backgroundView.key"
}

// ⚠️pod 'SnapKit'
// dependency 'UIKit'
open class SwiftyCusNavigationBar: UIView {
    deinit {
        #if DEBUG
        print("\(NSStringFromClass(self.classForCoder)) deinit")
        #endif
    }
    
    public lazy var barView: UIView = {
        let barView = UIView()
        barView.backgroundColor = .clear
        return barView
    }()
    
    public lazy var lineView: UIView = {
        let lineView = UIView()
        return lineView
    }()
    
    public lazy var toolView: UIView = {
        let toolView = UIView()
        toolView.backgroundColor = .clear
        return toolView
    }()
    
    
    public var barHeight: CGFloat = 44.0
    public var toolHeight: CGFloat = 0.0
    public var leftItems: [AnyObject]?
    public var rightItems: [AnyObject]?
    public var title: SwiftyCusNavigationBarTitle?
    public var backgroundLayer: CALayer?
    public var backgroundView: UIView?
    public var hideNavigationBar: Bool = true // contains all
    public var hideStatusBar: Bool = false
    public var hideBar: Bool = false
    public var hideToolBar: Bool = false
    
    public var lineColor: UIColor = UIColor(red: 162.0/255.0, green: 168.0/255.0, blue: 195.0/255.0, alpha: 0.7) {
        didSet {
            self.lineView.backgroundColor = lineColor
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    public init() {
        super.init(frame: .zero)
        self.setupUI()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SwiftyCusNavigationBar {
    private func setupUI() {
        self.addSubview(self.lineView)
        self.addSubview(self.barView)
        self.addSubview(self.toolView)
    }
}


extension SwiftyCusNavigationBar {
    public override func layoutSubviews() {
        super.layoutSubviews()
    }
}


extension SwiftyCusNavigationBar {
    public func reload(origin: CGPoint, barWidth: CGFloat) {
        if self.hideNavigationBar {
            self.barView.subviews.forEach { (v) in
                v.removeFromSuperview()
            }
            self.barView.isHidden = true
            self.toolView.isHidden = true
            self.lineView.isHidden = true
            self.barView.frame = .zero
            self.toolView.frame = .zero
            self.lineView.frame = .zero
            self.frame = .zero
            return
        }
        self.lineView.isHidden = false
        
        
        let o_x: CGFloat = origin.x
        let o_y: CGFloat = origin.y
        var sumHeight: CGFloat = 0.0
        
        
        // status bar
        if !self.hideStatusBar {
            if !UIApplication.shared.isStatusBarHidden {
                sumHeight +=  UIApplication.shared.statusBarFrame.size.height
            } else {
                sumHeight += UIDevice.YH_Fringe_Height
            }
        }
        
        
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
        if !self.hideToolBar {
            self.toolView.isHidden = false
            self.toolView.frame = CGRect(x: o_x, y: sumHeight, width: barWidth, height: self.toolHeight)
            sumHeight += self.toolHeight
        } else {
            self.toolView.isHidden = true
            self.toolView.frame = .zero
        }
        
        
        // self frame
        self.frame = CGRect(x: o_x, y: o_y, width: barWidth, height: sumHeight)
        
        
        // left items
        var leftDistance: CGFloat = .zero
        for (_, item) in (self.leftItems ?? []).enumerated() {
            if let item = item as? SwiftyCusNavigationBarButtonItem {
                switch item.layoutType {
                case .custom(let y, let width, let height):
                    item.view?.frame = CGRect(x: leftDistance, y: y, width: width, height: height)
                    leftDistance += width
                case .auto:
                    item.view?.sizeToFit() // size to fit
                    let w = item.view?.frame.width ?? 0.0
                    item.view?.frame = CGRect(x: leftDistance, y: 0, width: w, height: self.barHeight)
                    leftDistance += w
                }
                if let view = item.view {
                    self.barView.addSubview(view)
                }
            } else if let item = item as? SwiftyCusNavigationBarSpace {
                leftDistance += item.space
            }
        }
        
        
        // right items
        var rightDistance: CGFloat = .zero
        for (_, item) in (self.rightItems ?? []).enumerated().reversed() {
            if let item = item as? SwiftyCusNavigationBarButtonItem {
                switch item.layoutType {
                case .custom(let y, let width, let height):
                    item.view?.frame = CGRect(x: barWidth - rightDistance - width, y: y, width: width, height: height)
                    rightDistance += width
                case .auto:
                    item.view?.sizeToFit() // size to fit
                    let w = item.view?.frame.width ?? 0.0
                    item.view?.frame = CGRect(x: barWidth - rightDistance - w, y: 0, width: w, height: self.barHeight)
                    rightDistance += w
                }
                if let view = item.view {
                    self.barView.addSubview(view)
                }
            } else if let item = item as? SwiftyCusNavigationBarSpace {
                rightDistance += item.space
            }
        }
        
        
        // title view
        let maxTitleWidth: CGFloat = (barWidth / 2.0 - max(leftDistance, rightDistance)) * 2.0;
        if let title = self.title {
            switch title.layoutType {
            case .custom(let y, let width, let height):
                let h: CGFloat = height
                let w: CGFloat = width
                title.view?.center = CGPoint(x: self.barView.frame.width / 2.0, y: (self.barHeight / 2.0 + (y / 2.0)))
                title.view?.bounds = CGRect(x: 0, y: 0, width: w, height: h)
            case .fill:
                let h: CGFloat = self.barHeight
                let w: CGFloat = maxTitleWidth
                title.view?.center = CGPoint(x: self.barView.frame.width / 2.0, y: self.barHeight / 2.0)
                title.view?.bounds = CGRect(x: 0, y: 0, width: w, height: h)
            }
            if let titleView = title.view {
                self.barView.addSubview(titleView)
            }
        }
        
        
        // line view
        self.lineView.frame = CGRect(x: o_x, y: self.barView.frame.origin.y + self.barView.frame.size.height - 0.5, width: barWidth, height: 0.5)
        self.lineView.backgroundColor = self.lineColor
        
        // backgroundView
        let tmpBackgroundView = objc_getAssociatedObject(self, &SwiftyCusNavigationBarAssociatedKeys.viewKey) as? UIView
        tmpBackgroundView?.removeFromSuperview()
        if let backgroundView = self.backgroundView {
            objc_setAssociatedObject(self, &SwiftyCusNavigationBarAssociatedKeys.viewKey, backgroundView, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            backgroundView.frame = self.bounds
            self.insertSubview(backgroundView, at: 0)
        }
        // backgroundLayer
        let tmpBackgroundLayer = objc_getAssociatedObject(self, &SwiftyCusNavigationBarAssociatedKeys.layerKey) as? CALayer
        tmpBackgroundLayer?.removeFromSuperlayer()
        if let backgroundLayer = self.backgroundLayer {
            objc_setAssociatedObject(self, &SwiftyCusNavigationBarAssociatedKeys.layerKey, backgroundLayer, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            backgroundLayer.frame = self.bounds
            self.layer.insertSublayer(backgroundLayer, at: 0)
        }
    }
}
