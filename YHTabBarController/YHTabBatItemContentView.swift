//
//  YHTabBatItemContentView.swift
//  FNDating
//
//  Created by apple on 2019/9/19.
//  Copyright © 2019 yinhe. All rights reserved.
//

import UIKit

open class YHTabBatItemContentView: UIView {
    
    // 偏移量
    open var insets: UIEdgeInsets = UIEdgeInsets.zero
    
    /// 是否被选中
    open var selected: Bool = false
    
    /// 是否处于高亮状态
    open var highlighted: Bool = false
    
    /// 是否支持高亮
    open var highlightEnabled: Bool = true

    
    /// 正常状态下文本颜色
    open var normalTextColor: UIColor = UIColor(white: 0.57254902, alpha: 1.0) {
        didSet {
            if !selected {
                titleLabel.textColor = normalTextColor
            }
        }
    }
    
    /// 选中时文本颜色
    open var selectedTextColor: UIColor = UIColor(red: 0.0, green: 0.47843137, blue: 1.0, alpha: 1.0) {
        didSet {
            if selected {
                titleLabel.textColor = selectedTextColor
            }
        }
    }
    
    /// 正常状态下Icon颜色
    open var normalIconColor: UIColor = UIColor(white: 0.57254902, alpha: 1.0) {
        didSet {
            if !selected {
                imageView.tintColor = normalIconColor
            }
        }
    }
    
    /// 选中状态下Icon颜色
    open var selectedIconColor: UIColor = UIColor(red: 0.0, green: 0.47843137, blue: 1.0, alpha: 1.0) {
        didSet {
            if selected {
                imageView.tintColor = selectedIconColor
            }
        }
    }
    
    /// 正常状态下背景颜色
    open var normalBackgroundColor: UIColor = UIColor.clear {
        didSet {
            if !selected {
                superview?.backgroundColor = normalBackgroundColor
            }
        }
    }

    /// 选中状态下背景颜色
    open var selectedBackgroundColor: UIColor = UIColor.clear {
        didSet {
            if selected {
                superview?.backgroundColor = selectedBackgroundColor
            }
        }
    }

    /// 文本内容
    open var title: String? {
        didSet {
            titleLabel.text = title
            updateDisplay()
        }
    }
    
    
    /// 正常情况下的图标
    open var normalImage: UIImage? {
        didSet {
            if !selected {
                updateDisplay()
            }
        }
    }
    
    /// 选中状态下的图标
    open var selectedImage: UIImage? {
        didSet {
            if selected {
                updateDisplay()
            }
        }
    }
    
    /// Icon渲染类型
    open var iconRenderingMode: UIImage.RenderingMode = UIImage.RenderingMode.alwaysOriginal {
        didSet {
            updateDisplay()
        }
    }
    
    /// 角标
    open var badgeValue: AnyObject? {
        didSet {
            if let _badgeValue = badgeValue {
                badgeView.badgeValue = _badgeValue
                addSubview(badgeView)
                updateLayout()
            } else {
                badgeView.removeFromSuperview()
            }
            badgeChanged(animation: true, completion: nil)
        }
    }
    
    /// 角标背景颜色
    open var badgeColor: UIColor? {
        didSet {
            if let _badgeColor = badgeColor {
                badgeView.badgeColor = _badgeColor
            } else {
                badgeView.badgeColor = YHTabBarItemBadgeView.defaultBadgeColor
            }
        }
    }
    
    /// 角标偏移量
    open var badgeOffset: UIOffset = UIOffset(horizontal: 6.0, vertical: -22.0) {
        didSet {
            if badgeOffset != oldValue {
                updateLayout()
            }
        }
    }
    
    /// 角标文本内容颜色
    open var badgeContentColor: UIColor? {
        didSet {
            badgeView.badgeContentColor = badgeContentColor
        }
    }
    
    /// 赋值角标View
    open var badgeView: YHTabBarItemBadgeView = YHTabBarItemBadgeView() {
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
    
    open var titlePositionAdjustment: UIOffset = UIOffset.zero {
        didSet {
            updateLayout()
        }
    }
    
    open var imagePositionAdjustment: UIOffset = UIOffset.zero {
        didSet {
            updateLayout()
        }
    }
    
    open lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    open lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.backgroundColor = .clear
        titleLabel.textColor = .clear
        titleLabel.textAlignment = .center
        // titleLabel.numberOfLines = 0 // 不能设置numberOfLines为0，否则屏幕旋转时会出问题
        return titleLabel
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
    }
    
    public init() {
        super.init(frame: .zero)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension YHTabBatItemContentView {
    internal func setup() {
        addSubview(imageView)
        addSubview(titleLabel)
        
        titleLabel.textColor = normalTextColor
        imageView.tintColor = normalIconColor
        
        backgroundColor = .clear
        isUserInteractionEnabled = false // 设置为false，否则点击无响应
    }
}

extension YHTabBatItemContentView {
    @objc open func updateDisplay() {
        imageView.image = (selected ? (selectedImage ?? normalImage) : normalImage)?.withRenderingMode(iconRenderingMode)
        imageView.tintColor = selected ? selectedIconColor : normalIconColor
        titleLabel.textColor = selected ? selectedTextColor : normalTextColor
        superview?.backgroundColor = selected ? selectedBackgroundColor : normalBackgroundColor
    }
}

extension YHTabBatItemContentView {
    @objc open func updateLayout() {
        
        imageView.isHidden = (imageView.image == nil)
        titleLabel.isHidden = (titleLabel.text == nil)
        
        
        let w = self.bounds.size.width
        let h = self.bounds.size.height
        
        let statusBarOrientation = UIApplication.shared.statusBarOrientation
        let isLandscape = statusBarOrientation == .landscapeLeft || statusBarOrientation == .landscapeRight
        let isWide = isLandscape || traitCollection.horizontalSizeClass == .regular
        
        var imageWidth: CGFloat = 23.0
        var fontSize: CGFloat = 10.0
        
        if #available(iOS 11.0, *), isWide {
            imageWidth = UIScreen.main.scale == 3.0 ? 23.0 : 20.0
            fontSize = UIScreen.main.scale == 3.0 ? 13.0 : 12.0
        }
        
        
        // titleLabel和iamgeView的布局
        if !imageView.isHidden && !titleLabel.isHidden {
            titleLabel.font = UIFont.systemFont(ofSize: fontSize)
            titleLabel.sizeToFit()
            
            let titleWidth = titleLabel.bounds.size.width
            
            if #available(iOS 11, *), isWide {
                // 如果是iOS11，并且是横屏(图标和文字水平排列)
                titleLabel.frame = CGRect(x: (w - titleWidth) / 2.0 + (UIScreen.main.scale == 3.0 ? 14.25 : 12.25) + titlePositionAdjustment.horizontal,
                                          y: (h - titleLabel.bounds.size.height) / 2.0 + titlePositionAdjustment.vertical,
                                          width: titleWidth,
                                          height: titleLabel.bounds.size.height)
                imageView.frame = CGRect(x: titleLabel.frame.origin.x - imageWidth - (UIScreen.main.scale == 3.0 ? 6.0 : 5.0) + imagePositionAdjustment.horizontal,
                                         y: (h - imageWidth) / 2.0 + imagePositionAdjustment.vertical,
                                         width: imageWidth,
                                         height: imageWidth)
            } else {
                titleLabel.frame = CGRect(x: (w - titleWidth) / 2.0 + titlePositionAdjustment.horizontal,
                                          y: h - titleLabel.bounds.size.height + titlePositionAdjustment.vertical,
                                          width: titleWidth,
                                          height: titleLabel.bounds.size.height)
                imageView.frame = CGRect(x: (w - imageWidth) / 2.0 + imagePositionAdjustment.horizontal,
                                         y: (h - imageWidth) / 2.0 - 6.0 + imagePositionAdjustment.vertical,
                                         width: imageWidth,
                                         height: imageWidth)
            }
        } else if !imageView.isHidden {
            imageView.frame = CGRect(x: (w - imageWidth) / 2.0 + imagePositionAdjustment.horizontal,
                                     y: (h - imageWidth) / 2.0 + imagePositionAdjustment.vertical,
                                     width: imageWidth,
                                     height: imageWidth)
        } else if !titleLabel.isHidden {
            titleLabel.font = UIFont.systemFont(ofSize: fontSize)
            titleLabel.sizeToFit()
            
            let titleWidth = min(titleLabel.bounds.size.width, w)
            
            titleLabel.frame = CGRect(x: (w - titleWidth) / 2.0 + titlePositionAdjustment.horizontal,
                                      y: (h - titleLabel.bounds.size.height) / 2.0 + titlePositionAdjustment.vertical,
                                      width: titleWidth,
                                      height: titleLabel.bounds.size.height)
        }
        
        // badgeView的布局
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

extension YHTabBatItemContentView {
    internal func select(animation: Bool, completion: (() -> ())?) {
        selected = true
        if highlightEnabled && highlighted {
            // 如果当前处于高亮状态、允许高亮
            highlighted = false
            dehighlightAnimation(animated: animation) { [weak self] in
                self?.updateDisplay()
                self?.selectAnimation(animation: animation, completion: completion)
            }
        } else {
            updateDisplay()
            selectAnimation(animation: animation, completion: completion)
        }
    }
    
    internal func deselect(animation: Bool, completion: (() -> ())?) {
        selected = false
        updateDisplay()
        deselectAnimation(animated: animation, completion: completion)
    }
    
    internal func reselect(animation: Bool, completion: (() -> ())?) {
        if !selected {
            select(animation: animation, completion: completion)
        } else {
            if highlightEnabled && highlighted {
                highlighted = false
                dehighlightAnimation(animated: animation) { [weak self] in
                    self?.reselectAnimation(animated: animation, completion: completion)
                }
            } else {
                reselectAnimation(animated: animation, completion: completion)
            }
        }
    }
    
    internal func highlight(animation: Bool, completion: (() -> ())?) {
        if !highlightEnabled {
            return
        }
        if highlighted {
            return
        }
        highlighted = true
        highlightAnimation(animated: animation, completion: completion)
    }
    
    internal func dehighlight(animation: Bool, completion: (() -> ())?) {
        if !highlightEnabled {
            return
        }
        if !highlighted {
            return
        }
        highlighted = false
        dehighlightAnimation(animated: animation, completion: completion)
    }
    
    internal func badgeChanged(animation: Bool, completion: (() -> ())?) {
        badgeChangedAnimation(animated: animation, completion: completion)
    }
}

extension YHTabBatItemContentView {
    @objc open func selectAnimation(animation: Bool, completion: (() -> ())?) {
        completion?()
    }
    
    @objc open func deselectAnimation(animated: Bool, completion: (() -> ())?) {
        completion?()
    }
    
    @objc open func reselectAnimation(animated: Bool, completion: (() -> ())?) {
        completion?()
    }
    
    @objc open func highlightAnimation(animated: Bool, completion: (() -> ())?) {
        completion?()
    }
    
    @objc open func dehighlightAnimation(animated: Bool, completion: (() -> ())?) {
        completion?()
    }
    
    @objc open func badgeChangedAnimation(animated: Bool, completion: (() -> ())?) {
        completion?()
    }
}
