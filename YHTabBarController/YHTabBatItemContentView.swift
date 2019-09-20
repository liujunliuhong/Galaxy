//
//  YHTabBatItemContentView.swift
//  FNDating
//
//  Created by apple on 2019/9/19.
//  Copyright © 2019 yinhe. All rights reserved.
//

import UIKit

class YHTabBatItemContentView: UIView {

    var selected: Bool = false
    var highlighted: Bool = false
    var highlightEnabled: Bool = true

    var normalTextColor: UIColor = UIColor(white: 0.57254902, alpha: 1.0) {
        didSet {
            
        }
    }
    
    var highlightTextColor: UIColor = UIColor(red: 0.0, green: 0.47843137, blue: 1.0, alpha: 1.0) {
        didSet {
            
        }
    }
    
    var normalIconColor: UIColor = UIColor(white: 0.57254902, alpha: 1.0) {
        didSet {
            
        }
    }
    
    var highlightIconColor: UIColor = UIColor(red: 0.0, green: 0.47843137, blue: 1.0, alpha: 1.0) {
        didSet {
            
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
    
    var title: String? {
        didSet {
            
        }
    }
    
    var normalImage: UIImage? {
        didSet {
            
        }
    }
    
    var selectedImage: UIImage? {
        didSet {
            
        }
    }
    
    var iconRenderingMode: UIImage.RenderingMode = UIImage.RenderingMode.alwaysTemplate {
        didSet {
            
        }
    }
    
    var badgeValue: AnyObject? {
        didSet {
            if let _badgeValue = badgeValue {
                
            } else {
                
            }
        }
    }
    
    var badgeColor: UIColor? {
        didSet {
            
        }
    }
    
    var badgeOffset: UIOffset = UIOffset(horizontal: 6.0, vertical: -22.0) {
        didSet {
            if badgeOffset != oldValue {
                updateLayout()
            }
        }
    }
    
    var badgeView: YHTabBarItemBadgeView = YHTabBarItemBadgeView() {
        willSet {
            if let _ = badgeView.superview {
                badgeView.removeFromSuperview()
            }
        }
        didSet {
            
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
    }
    
    init() {
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension YHTabBatItemContentView {
    func setup() {
        addSubview(imageView)
        addSubview(titleLabel)
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
        
        
        let imageWidth: CGFloat = 23.0
        let fontSize: CGFloat = 10.0
        
        
        if !imageView.isHidden && !titleLabel.isHidden {
            titleLabel.font = UIFont.systemFont(ofSize: fontSize)
            titleLabel.sizeToFit()
            
            if #available(iOS 11, *), isLandscape {
                // 如果是iOS11，并且是横屏
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
}

extension YHTabBatItemContentView {
    func selectAnimation(animation: Bool, completion: (() -> ())?) {
        completion?()
    }
    
    func deselectAnimation(animated: Bool, completion: (() -> ())?) {
        completion?()
    }
    
    func reselectAnimation(animated: Bool, completion: (() -> ())?) {
        completion?()
    }
    
    func highlightAnimation(animated: Bool, completion: (() -> ())?) {
        completion?()
    }
    
    func dehighlightAnimation(animated: Bool, completion: (() -> ())?) {
        completion?()
    }
    
    func badgeChangedAnimation(animated: Bool, completion: (() -> ())?) {
        completion?()
    }
}
