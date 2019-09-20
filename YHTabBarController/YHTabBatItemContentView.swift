//
//  YHTabBatItemContentView.swift
//  FNDating
//
//  Created by apple on 2019/9/19.
//  Copyright © 2019 yinhe. All rights reserved.
//

import UIKit

class YHTabBatItemContentView: UIView {

    
    /// 是否被选中
    var selected: Bool = false
    
    
    /// 是否处于高亮状态
    var highlighted: Bool = false
    
    
    /// 是否支持高亮
    var highlightEnabled: Bool = true

    
    /// 正常状态下文本颜色
    var normalTextColor: UIColor = UIColor(white: 0.57254902, alpha: 1.0) {
        didSet {
            if !selected {
                titleLabel.textColor = normalTextColor
            }
        }
    }
    
    /// 高亮时文本颜色
    var highlightTextColor: UIColor = UIColor(red: 0.0, green: 0.47843137, blue: 1.0, alpha: 1.0) {
        didSet {
            if selected {
                titleLabel.textColor = highlightIconColor
            }
        }
    }
    
    /// 正常状态下Icon颜色
    var normalIconColor: UIColor = UIColor(white: 0.57254902, alpha: 1.0) {
        didSet {
            if !selected {
                imageView.tintColor = normalIconColor
            }
        }
    }
    
    
    /// 高亮状态下Icon颜色
    var highlightIconColor: UIColor = UIColor(red: 0.0, green: 0.47843137, blue: 1.0, alpha: 1.0) {
        didSet {
            if selected {
                imageView.tintColor = highlightIconColor
            }
        }
    }
    
    var normalBackgroundColor: UIColor = UIColor.clear {
        didSet {
            
        }
    }
    
    var highlightBackgroundColor: UIColor = UIColor.clear {
        didSet {
            
        }
    }
    
    
    /// 文本内容
    var title: String? {
        didSet {
            titleLabel.text = title
            updateDisplay()
        }
    }
    
    
    /// 正常情况下的图标
    var normalImage: UIImage? {
        didSet {
            if !selected {
                updateDisplay()
            }
        }
    }
    
    
    /// 高亮状态下的图标
    var selectedImage: UIImage? {
        didSet {
            if selected {
                updateDisplay()
            }
        }
    }
    
    
    /// Icon渲染类型
    var iconRenderingMode: UIImage.RenderingMode = UIImage.RenderingMode.alwaysTemplate {
        didSet {
            updateDisplay()
        }
    }
    
    
    /// 角标
    var badgeValue: AnyObject? {
        didSet {
            if let _badgeValue = badgeValue {
                badgeView.badgeValue = _badgeValue
                addSubview(badgeView)
                updateLayout()
            } else {
                badgeView.removeFromSuperview()
            }
            badgeChangedAnimation(animated: true, completion: nil)
        }
    }
    
    
    /// 角标背景颜色
    var badgeColor: UIColor? {
        didSet {
            if let _badgeColor = badgeColor {
                badgeView.badgeColor = _badgeColor
            } else {
                badgeView.badgeColor = YHTabBarItemBadgeView.defaultBadgeColor
            }
        }
    }
    
    
    /// 角标偏移量
    var badgeOffset: UIOffset = UIOffset(horizontal: 6.0, vertical: -22.0) {
        didSet {
            if badgeOffset != oldValue {
                updateLayout()
            }
        }
    }
    
    
    /// 赋值角标View
    var badgeView: YHTabBarItemBadgeView = YHTabBarItemBadgeView() {
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
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.backgroundColor = .clear
        titleLabel.textColor = .clear
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
    }
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension YHTabBatItemContentView {
    func setup() {
        addSubview(imageView)
        addSubview(titleLabel)
        backgroundColor = UIColor.clear
    }
}

extension YHTabBatItemContentView {
    func updateDisplay() {
        imageView.image = (selected ? (selectedImage ?? normalImage) : normalImage)?.withRenderingMode(iconRenderingMode)
        imageView.tintColor = selected ? highlightIconColor : normalIconColor
        titleLabel.textColor = selected ? highlightTextColor : normalTextColor
    }
}

extension YHTabBatItemContentView {
    func updateLayout() {
        
        imageView.isHidden = (imageView.image == nil)
        titleLabel.isHidden = (titleLabel.text == nil)
        
        
        let w = self.bounds.size.width
        let h = self.bounds.size.height
        
        let statusBarOrientation = UIApplication.shared.statusBarOrientation
        let isLandscape = statusBarOrientation == .landscapeLeft || statusBarOrientation == .landscapeRight
        
        var imageWidth: CGFloat = 23.0
        var fontSize: CGFloat = 12.0
        
        if #available(iOS 11.0, *), isLandscape {
            imageWidth = UIScreen.main.scale == 3.0 ? 23.0 : 20.0
            fontSize = UIScreen.main.scale == 3.0 ? 13.0 : 12.0
        }
        
        
        
        if !imageView.isHidden && !titleLabel.isHidden {
            titleLabel.font = UIFont.systemFont(ofSize: fontSize)
            titleLabel.sizeToFit()
            
            if #available(iOS 11, *), isLandscape {
                // 如果是iOS11，并且是横屏(图标和文字水平排列)
                titleLabel.frame = CGRect(x: (w - titleLabel.bounds.size.width) / 2.0 + (UIScreen.main.scale == 3.0 ? 14.25 : 12.25),
                                          y: (h - titleLabel.bounds.size.height) / 2.0,
                                          width: titleLabel.bounds.size.width,
                                          height: titleLabel.bounds.size.height)
                imageView.frame = CGRect(x: titleLabel.frame.origin.x - imageWidth - (UIScreen.main.scale == 3.0 ? 6.0 : 5.0),
                                         y: (h - imageWidth) / 2.0,
                                         width: imageWidth,
                                         height: imageWidth)
            } else {
                titleLabel.frame = CGRect(x: (w - titleLabel.bounds.size.width) / 2.0,
                                          y: h - titleLabel.bounds.size.height,
                                          width: titleLabel.bounds.size.width,
                                          height: titleLabel.bounds.size.height)
                imageView.frame = CGRect(x: (w - imageWidth) / 2.0,
                                         y: (h - imageWidth) / 2.0 - 6.0,
                                         width: imageWidth,
                                         height: imageWidth)
            }
        } else if !imageView.isHidden {
            imageView.frame = CGRect(x: (w - imageWidth) / 2.0,
                                     y: (h - imageWidth) / 2.0,
                                     width: imageWidth,
                                     height: imageWidth)
        } else if !titleLabel.isHidden {
            titleLabel.font = UIFont.systemFont(ofSize: fontSize)
            titleLabel.sizeToFit()
            titleLabel.frame = CGRect(x: (w - titleLabel.bounds.size.width) / 2.0,
                                      y: (h - titleLabel.bounds.size.height) / 2.0,
                                      width: titleLabel.bounds.size.width,
                                      height: titleLabel.bounds.size.height)
        }
        
        if let _ = badgeView.superview {
            let size = badgeView.sizeThatFits(self.frame.size)
            if #available(iOS 11.0, *), isLandscape {
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
    func select(animation: Bool, completion: (() -> ())?) {
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
    
    func deselect(animation: Bool, completion: (() -> ())?) {
        selected = false
        updateDisplay()
        deselectAnimation(animated: animation, completion: completion)
    }
    
    func reselect(animation: Bool, completion: (() -> ())?) {
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
    
    func highlight(animation: Bool, completion: (() -> ())?) {
        if !highlightEnabled {
            return
        }
        if highlighted {
            return
        }
        highlighted = true
        highlightAnimation(animated: animation, completion: completion)
    }
    
    func dehighlight(animation: Bool, completion: (() -> ())?) {
        if !highlightEnabled {
            return
        }
        if !highlighted {
            return
        }
        highlighted = false
        dehighlightAnimation(animated: animation, completion: completion)
    }
    
    func badgeChanged(animation: Bool, completion: (() -> ())?) {
        badgeChangedAnimation(animated: animation, completion: completion)
    }
}

extension YHTabBatItemContentView {
    open func selectAnimation(animation: Bool, completion: (() -> ())?) {
        completion?()
    }
    
    open func deselectAnimation(animated: Bool, completion: (() -> ())?) {
        completion?()
    }
    
    open func reselectAnimation(animated: Bool, completion: (() -> ())?) {
        completion?()
    }
    
    open func highlightAnimation(animated: Bool, completion: (() -> ())?) {
        completion?()
    }
    
    open func dehighlightAnimation(animated: Bool, completion: (() -> ())?) {
        completion?()
    }
    
    open func badgeChangedAnimation(animated: Bool, completion: (() -> ())?) {
        completion?()
    }
}
