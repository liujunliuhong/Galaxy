//
//  SwiftyCusNavigationBar.swift
//  SwiftTool
//
//  Created by liujun on 2020/6/9.
//  Copyright © 2020 yinhe. All rights reserved.
//

import UIKit

// bar button item type
// auto: Get the width of the control itself by calling `sizeToFit`
// custom: Custom width and height
public enum SwiftyNavigationBarButtonItemType {
    case button(button: UIButton, layoutType: SwiftyNavigationBarButtonItemLayoutType)
    case imageView(imageView: UIImageView, layoutType: SwiftyNavigationBarButtonItemLayoutType)
    case customView(view: UIView, layoutType: SwiftyNavigationBarButtonItemLayoutType)
    case space(space: CGFloat)
}

// title type
// auto: Fill the remaining space
// custom: Custom width and height
public enum SwiftyNavigationBarTitleType {
    case title(title: String?, font: UIFont?, color: UIColor, adjustsFontSizeToFitWidth: Bool, layoutType: SwiftyNavigationBarButtonItemLayoutType)
    case imageView(imageView: UIImageView, layoutType: SwiftyNavigationBarButtonItemLayoutType)
    case customView(view: UIView, layoutType: SwiftyNavigationBarButtonItemLayoutType)
}

// layout type
public enum SwiftyNavigationBarButtonItemLayoutType {
    case custom(y: CGFloat, width: CGFloat, height: CGFloat)
    case auto
}

// bar button item
public class SwiftyNavigationBarButtonItem: NSObject {
    public var itemType: SwiftyNavigationBarButtonItemType?
    
    public override init() {
        super.init()
    }
    
    public convenience init(itemType: SwiftyNavigationBarButtonItemType) {
        self.init()
        self.itemType = itemType
    }
}

// title
public class SwiftyNavigationBarTitle: NSObject {
    public var titleType: SwiftyNavigationBarTitleType?
    
    public override init() {
        super.init()
    }
    
    public convenience init(titleType: SwiftyNavigationBarTitleType) {
        self.init()
        self.titleType = titleType
    }
}


private struct SwiftyCusNavigationBarAssociatedKeys {
    static var gradientKey = "com.yinhe.SwiftyCusNavigationBar.gradientLayer.key"
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
    public var leftItems: [SwiftyNavigationBarButtonItem]?
    public var rightItems: [SwiftyNavigationBarButtonItem]?
    public var title: SwiftyNavigationBarTitle?
    public var gradientLayer: CAGradientLayer?
    public var hideNavigationBar: Bool = true
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
        self.setup()
    }
    
    public init() {
        super.init(frame: .zero)
        self.setup()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SwiftyCusNavigationBar {
    private func setup() {
        self.addSubview(self.barView)
        self.addSubview(self.lineView)
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
            view.removeFromSuperview()
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
            view.removeFromSuperview()
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
            switch item.itemType {
            case .space(let space):
                leftDistance += space
            case .button(let button, let layoutType):
                switch layoutType {
                case .auto:
                    button.sizeToFit()
                    let w = button.frame.width
                    button.frame = CGRect(x: leftDistance, y: 0, width: w, height: self.barHeight)
                    leftDistance += w
                case .custom(let y, let width, let height):
                    button.frame = CGRect(x: leftDistance, y: y, width: width, height: height)
                    leftDistance += width
                }
                self.barView.addSubview(button)
            case .imageView(let imageView, let layoutType):
                switch layoutType {
                case .auto:
                    imageView.sizeToFit()
                    let w = imageView.frame.width
                    imageView.frame = CGRect(x: leftDistance, y: 0, width: w, height: self.barHeight)
                    leftDistance += w
                case .custom(let y, let width, let height):
                    imageView.frame = CGRect(x: leftDistance, y: y, width: width, height: height)
                    leftDistance += width
                }
                self.barView.addSubview(imageView)
            case .customView(let view, let layoutType):
                switch layoutType {
                case .auto:
                    view.sizeToFit()
                    let w = view.frame.width
                    view.frame = CGRect(x: leftDistance, y: 0, width: w, height: self.barHeight)
                    leftDistance += w
                case .custom(let y, let width, let height):
                    view.frame = CGRect(x: leftDistance, y: y, width: width, height: height)
                    leftDistance += width
                }
                self.barView.addSubview(view)
            case .none:
                break
            }
        }
        
        
        // right items
        var rightDistance: CGFloat = .zero
        for (_, item) in (self.rightItems ?? []).enumerated().reversed() {
            switch item.itemType {
            case .space(let space):
                rightDistance += space
            case .button(let button, let layoutType):
                switch layoutType {
                case .auto:
                    button.sizeToFit()
                    let w = button.frame.width
                    button.frame = CGRect(x: barWidth - rightDistance - w, y: 0, width: w, height: self.barHeight)
                    rightDistance += w
                case .custom(let y, let width, let height):
                    button.frame = CGRect(x: barWidth - rightDistance - width, y: y, width: width, height: height)
                    rightDistance += width
                }
                self.barView.addSubview(button)
            case .imageView(let imageView, let layoutType):
                switch layoutType {
                case .auto:
                    imageView.sizeToFit()
                    let w = imageView.frame.width
                    imageView.frame = CGRect(x: barWidth - rightDistance - w, y: 0, width: w, height: self.barHeight)
                    rightDistance += w
                case .custom(let y, let width, let height):
                    imageView.frame = CGRect(x: barWidth - rightDistance - width, y: y, width: width, height: height)
                    rightDistance += width
                }
                self.barView.addSubview(imageView)
            case .customView(let view, let layoutType):
                switch layoutType {
                case .auto:
                    view.sizeToFit()
                    let w = view.frame.width
                    view.frame = CGRect(x: barWidth - rightDistance - w, y: 0, width: w, height: self.barHeight)
                    rightDistance += w
                case .custom(let y, let width, let height):
                    view.frame = CGRect(x: barWidth - rightDistance - width, y: y, width: width, height: height)
                    rightDistance += width
                }
                self.barView.addSubview(view)
            case .none:
                break
            }
        }
        
        
        // title view
        let titleWidth: CGFloat = (barWidth / 2.0 - max(leftDistance, rightDistance)) * 2.0;
        if let title = self.title, let titleType = title.titleType {
            switch titleType {
            case .title(let title, let font, let color, let adjustsFontSizeToFitWidth, let layoutType):
                let label = UILabel()
                label.text = title
                label.font = font
                label.textColor = color
                label.textAlignment = .center
                label.adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth
                self.barView.addSubview(label)
                switch layoutType {
                case .auto:
                    let h: CGFloat = self.barHeight
                    let w: CGFloat = titleWidth
                    label.center = CGPoint(x: self.barView.frame.width / 2.0, y: self.barHeight / 2.0)
                    label.bounds = CGRect(x: 0, y: 0, width: w, height: h)
                case .custom(let y, let width, let height):
                    let h: CGFloat = height
                    let w: CGFloat = width
                    label.center = CGPoint(x: self.barView.frame.width / 2.0, y: (self.barHeight / 2.0 + (y / 2.0)))
                    label.bounds = CGRect(x: 0, y: 0, width: w, height: h)
                }
            case .imageView(let imageView, let layoutType):
                self.barView.addSubview(imageView)
                switch layoutType {
                case .auto:
                    let h: CGFloat = self.barHeight
                    let w: CGFloat = titleWidth
                    imageView.center = CGPoint(x: self.barView.frame.width / 2.0, y: self.barHeight / 2.0)
                    imageView.bounds = CGRect(x: 0, y: 0, width: w, height: h)
                case .custom(let y, let width, let height):
                    let h: CGFloat = height
                    let w: CGFloat = width
                    imageView.center = CGPoint(x: self.barView.frame.width / 2.0, y: (self.barHeight / 2.0 + (y / 2.0)))
                    imageView.bounds = CGRect(x: 0, y: 0, width: w, height: h)
                }
            case .customView(let view, let layoutType):
                self.barView.addSubview(view)
                switch layoutType {
                case .auto:
                    let h: CGFloat = self.barHeight
                    let w: CGFloat = titleWidth
                    view.center = CGPoint(x: self.barView.frame.width / 2.0, y: self.barHeight / 2.0)
                    view.bounds = CGRect(x: 0, y: 0, width: w, height: h)
                case .custom(let y, let width, let height):
                    let h: CGFloat = height
                    let w: CGFloat = width
                    view.center = CGPoint(x: self.barView.frame.width / 2.0, y: (self.barHeight / 2.0 + (y / 2.0)))
                    view.bounds = CGRect(x: 0, y: 0, width: w, height: h)
                }
            }
        }
        
        
        // line view
        self.lineView.frame = CGRect(x: o_x, y: self.barView.frame.origin.y + self.barView.frame.size.height - 0.5, width: barWidth, height: 0.5)
        self.lineView.backgroundColor = self.lineColor
        
        
        // CAGradientLayer
        let tmpGradientLayer = objc_getAssociatedObject(self, &SwiftyCusNavigationBarAssociatedKeys.gradientKey)
        if let tmpGradientLayer = tmpGradientLayer as? CAGradientLayer {
            tmpGradientLayer.removeFromSuperlayer()
        }
        if let gradientLayer = self.gradientLayer {
            objc_setAssociatedObject(self, &SwiftyCusNavigationBarAssociatedKeys.gradientKey, gradientLayer, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            gradientLayer.frame = self.bounds
            self.layer.insertSublayer(gradientLayer, at: 0)
        }
    }
}
