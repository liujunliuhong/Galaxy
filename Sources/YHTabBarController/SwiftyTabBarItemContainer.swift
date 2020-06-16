//
//  SwiftyTabBarItemContainer.swift
//  SwiftTool
//
//  Created by apple on 2020/6/16.
//  Copyright © 2020 yinhe. All rights reserved.
//

import UIKit

internal class _SwiftyTabBarItemWrapView: UIControl {

    @available(iOS, unavailable)
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    init(target: AnyObject?, tag: Int) {
        super.init(frame: .zero)
        self.backgroundColor = UIColor.clear
        self.tag = tag
        self.addTarget(target, action: #selector(YHTabBar.selectAction(_:)), for: .touchUpInside)
        self.addTarget(target, action: #selector(YHTabBar.highlightAction(_:)), for: .touchDown)
        self.addTarget(target, action: #selector(YHTabBar.highlightAction(_:)), for: .touchDragEnter)
        self.addTarget(target, action: #selector(YHTabBar.dehighlightAction(_:)), for: .touchDragExit)
        self.addTarget(target, action: #selector(YHTabBar.dehighlightAction(_:)), for: .touchUpOutside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        for subView in subviews {
            if let subView = subView as? SwiftyTabBarItemContainer {
                let inset = subView.wrapInsets
                subView.frame = CGRect(x: inset.left, y: inset.top, width: bounds.size.width - inset.left - inset.right, height: bounds.size.height - inset.top - inset.bottom)
                subView.updateDisplay()
                subView.updateLayout()
            }
        }
    }
    
    internal override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        var b = super.point(inside: point, with: event)
        if !b {
            for subView in subviews {
                if subView.point(inside: CGPoint(x: point.x - subView.frame.origin.x, y: point.y - subView.frame.origin.y), with: event) {
                    b = true
                }
            }
        }
        return b
    }
}






open class SwiftyTabBarItemContainer: UIView {
    
    open var wrapInsets = UIEdgeInsets.zero
    open var isSelected: Bool = false
    open var supportHighlight = true
    
    open var normalTextColor: UIColor = UIColor(white: 0.57254902, alpha: 1.0) {
        didSet {
            if !self.isSelected {
                self.titleLabel.textColor = normalTextColor
            }
        }
    }
    
    open var selectedTextColor: UIColor = UIColor(red: 0.0, green: 0.47843137, blue: 1.0, alpha: 1.0) {
        didSet {
            if self.isSelected {
                self.titleLabel.textColor = selectedTextColor
            }
        }
    }
    
    open var normalIconColor: UIColor = UIColor(white: 0.57254902, alpha: 1.0) {
        didSet {
            if !self.isSelected {
                self.imageView.tintColor = normalIconColor
            }
        }
    }
    
    open var selectedIconColor: UIColor = UIColor(red: 0.0, green: 0.47843137, blue: 1.0, alpha: 1.0) {
        didSet {
            if self.isSelected {
                self.imageView.tintColor = selectedIconColor
            }
        }
    }
    open var normalBackgroundColor: UIColor = UIColor.clear {
        didSet {
            if !self.isSelected {
                self.superview?.backgroundColor = normalBackgroundColor
            }
        }
    }
    
    open var selectedBackgroundColor: UIColor = UIColor.clear {
        didSet {
            if self.isSelected {
                self.superview?.backgroundColor = selectedBackgroundColor
            }
        }
    }
    
    open var title: String? {
        didSet {
            self.titleLabel.text = title
            self.updateLayout()
        }
    }
    
    open var iconRenderingMode: UIImage.RenderingMode = UIImage.RenderingMode.alwaysOriginal {
        didSet {
            self.updateDisplay()
        }
    }
    
    open var normalImage: UIImage? {
        didSet {
            if !self.isSelected {
                self.updateDisplay()
            }
        }
    }
    
    open var selectedImage: UIImage? {
        didSet {
            if self.isSelected {
                self.updateDisplay()
            }
        }
    }
    
    open var badgeView: SwiftyTabBarBadgeView = SwiftyTabBarBadgeView() {
        willSet {
            if let _ = badgeView.superview {
                badgeView.removeFromSuperview()
            }
        }
        didSet {
            if let _ = badgeView.superview {
                updateLayout()
            }
        }
    }
    
    open var badgeOffset: UIOffset = UIOffset(horizontal: 6.0, vertical: -22.0) {
        didSet {
            if badgeOffset != oldValue {
                self.updateLayout()
            }
        }
    }
    
    open var titlePositionAdjustment: UIOffset = UIOffset.zero {
        didSet {
            self.updateLayout()
        }
    }
    
    open var imagePositionAdjustment: UIOffset = UIOffset.zero {
        didSet {
            self.updateLayout()
        }
    }
    
    open var imageWidth: CGFloat = 23.0 {
        didSet {
            self.updateLayout()
        }
    }
    
    open var fontSize: CGFloat = 12.0 {
        didSet {
            self.updateLayout()
        }
    }
    
    public lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    public lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.backgroundColor = .clear
        titleLabel.textColor = .clear
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 1
        return titleLabel
    }()
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = false
        
        self.addSubview(self.imageView)
        self.addSubview(self.titleLabel)
        
        self.updateDisplay()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension SwiftyTabBarItemContainer {
    open func updateDisplay() {
        self.imageView.image = (self.isSelected ? (self.selectedImage ?? self.normalImage) : self.normalImage)?.withRenderingMode(self.iconRenderingMode)
        self.imageView.tintColor = self.isSelected ? self.selectedIconColor : self.normalIconColor
        self.titleLabel.textColor = self.isSelected ? self.selectedTextColor : self.normalTextColor
        self.backgroundColor = self.isSelected ? self.selectedBackgroundColor : self.normalBackgroundColor
    }
    
    open func updateLayout() {
        self.imageView.isHidden = (imageView.image == nil)
        self.titleLabel.isHidden = (titleLabel.text == nil)
        
        let w = self.bounds.size.width
        let h = self.bounds.size.height
        
        let statusBarOrientation = UIApplication.shared.statusBarOrientation
        let isLandscape = statusBarOrientation == .landscapeLeft || statusBarOrientation == .landscapeRight
        let isWide = isLandscape || traitCollection.horizontalSizeClass == .regular
        
        
        if !imageView.isHidden && !titleLabel.isHidden {
            titleLabel.font = UIFont.systemFont(ofSize: self.fontSize)
            titleLabel.sizeToFit()
            
            var titleWidth = self.titleLabel.bounds.size.width
            
            if #available(iOS 11, *), isWide {
                // 如果是iOS11，并且是横屏(图标和文字水平排列)
                let space: CGFloat = 5.0 // image and title space
                
                titleWidth = min(titleWidth, (w - self.imageWidth - space))
                
                let sumWidth: CGFloat = self.imageWidth + space + titleWidth
                
                self.imageView.frame = CGRect(x: (w - sumWidth) / 2.0 + self.imagePositionAdjustment.horizontal,
                                              y: (h - self.imageWidth) / 2.0 + self.imagePositionAdjustment.vertical,
                                              width: self.imageWidth,
                                              height: self.imageWidth)
                
                self.titleLabel.frame = CGRect(x: self.imageView.frame.maxX + space + self.titlePositionAdjustment.horizontal,
                                               y: (h - self.titleLabel.bounds.height) / 2.0 + self.titlePositionAdjustment.vertical,
                                               width: titleWidth,
                                               height: self.titleLabel.bounds.height)
                
            } else {
                titleWidth = min(titleWidth, w)
                
                self.titleLabel.frame = CGRect(x: (w - titleWidth) / 2.0 + self.titlePositionAdjustment.horizontal,
                                          y: h - self.titleLabel.bounds.height + self.titlePositionAdjustment.vertical,
                                          width: titleWidth,
                                          height: self.titleLabel.bounds.height)
                
                self.imageView.frame = CGRect(x: (w - self.imageWidth) / 2.0 + self.imagePositionAdjustment.horizontal,
                                         y: (h - self.imageWidth) / 2.0 - 6.0 + self.imagePositionAdjustment.vertical,
                                         width: self.imageWidth,
                                         height: self.imageWidth)
            }
        } else if !imageView.isHidden {
            self.imageView.frame = CGRect(x: (w - self.imageWidth) / 2.0 + self.imagePositionAdjustment.horizontal,
                                     y: (h - self.imageWidth) / 2.0 + self.imagePositionAdjustment.vertical,
                                     width: self.imageWidth,
                                     height: self.imageWidth)
            
        } else if !titleLabel.isHidden {
            self.titleLabel.font = UIFont.systemFont(ofSize: self.fontSize)
            self.titleLabel.sizeToFit()
            
            let titleWidth = min(self.titleLabel.bounds.size.width, w)
            
            titleLabel.frame = CGRect(x: (w - titleWidth) / 2.0 + self.titlePositionAdjustment.horizontal,
                                      y: (h - self.titleLabel.bounds.size.height) / 2.0 + self.titlePositionAdjustment.vertical,
                                      width: titleWidth,
                                      height: self.titleLabel.bounds.size.height)
        }
        
        
        
        
        // badgeView layout
        if let _ = badgeView.superview {
            
            let size = badgeView.sizeThatFits(self.frame.size)
            
            if #available(iOS 11.0, *), isWide {
                badgeView.frame = CGRect(x: imageView.frame.midX - 3 + badgeOffset.horizontal,
                                         y: imageView.frame.midY + 3 + badgeOffset.vertical,
                                         width: size.width,
                                         height: size.height)
            } else {
                badgeView.frame = CGRect(x: w / 2.0 + badgeOffset.horizontal,
                                         y: h / 2.0 + badgeOffset.vertical,
                                         width: size.width,
                                         height: size.height)
            }
            badgeView.setNeedsLayout()
        }
    }
}

extension SwiftyTabBarItemContainer {
    internal final func select(animated: Bool, completion: (() -> ())?) {
        self.isSelected = true
        self.updateDisplay()
        self.selectAnimation(animated: animated, completion: completion)
    }
    
    internal final func deselect(animated: Bool, completion: (() -> ())?) {
        self.isSelected = false
        self.updateDisplay()
        self.deselectAnimation(animated: animated, completion: completion)
    }
    
    internal final func reselect(animated: Bool, completion: (() -> ())?) {
        if self.isSelected == false {
            self.select(animated: animated, completion: completion)
        } else {
            self.reselectAnimation(animated: animated, completion: completion)
        }
    }
    
    internal func badgeChanged(animated: Bool, completion: (() -> ())?) {
        self.badgeChangedAnimation(animated: animated, completion: completion)
    }
    
    
    
    open func selectAnimation(animated: Bool, completion: (() -> ())?) {
        completion?()
    }
    
    open func deselectAnimation(animated: Bool, completion: (() -> ())?) {
        completion?()
    }
    
    open func reselectAnimation(animated: Bool, completion: (() -> ())?) {
        completion?()
    }
    
    open func badgeChangedAnimation(animated: Bool, completion: (() -> ())?) {
        completion?()
    }
}
