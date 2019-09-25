//
//  YHTabBarItemBadgeView.swift
//  FNDating
//
//  Created by apple on 2019/9/19.
//  Copyright © 2019 yinhe. All rights reserved.
//

import UIKit

open class YHTabBarItemBadgeView: UIView {
    public static let defaultBadgeColor = UIColor.YH_RGBA(R: 255, G: 59, B: 48)
    public static let dotSize = CGSize(width: 8, height: 8)
    
    /// 可以是String或者是UIImage。空字符串：小圆点
    open var badgeValue: AnyObject? {
        didSet {
            guard let badgeValue = badgeValue else {
                imageView.image = nil
                badgeLabel.text = nil
                return
            }
            
            if let badgeStringValue = badgeValue as? String {
                imageView.image = nil
                badgeLabel.text = badgeStringValue
            }
            
            if let badgeImageValue = badgeValue as? UIImage {
                imageView.image = badgeImageValue
                badgeLabel.text = nil
            }
        }
    }
    
    
    /// 角标颜色，当角标内容为图片时，默认为透明，此属性无效
    open var badgeColor: UIColor? = YHTabBarItemBadgeView.defaultBadgeColor{
        didSet {
            imageView.backgroundColor = badgeColor
        }
    }
    
    
    /// 角标文本内容颜色
    open var badgeContentColor: UIColor? = .white {
        didSet {
            badgeLabel.textColor = badgeContentColor
        }
    }
    
    open lazy var imageView: UIImageView = {
        let imageView = UIImageView.init(frame: CGRect.zero)
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    open lazy var badgeLabel: UILabel = {
        let badgeLabel = UILabel.init(frame: CGRect.zero)
        badgeLabel.backgroundColor = .clear
        badgeLabel.font = UIFont.systemFont(ofSize: 13.0)
        badgeLabel.textAlignment = .center
        return badgeLabel
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    public init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension YHTabBarItemBadgeView {
    func setupUI() {
        addSubview(imageView)
        addSubview(badgeLabel)
        
        imageView.backgroundColor = YHTabBarItemBadgeView.defaultBadgeColor
        badgeLabel.textColor = badgeContentColor
    }
}


extension YHTabBarItemBadgeView {
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.isHidden = true
        badgeLabel.isHidden = true
        
        guard let badgeValue = badgeValue else {
            return
        }
        
        if let badgeStringValue = badgeValue as? String {
            imageView.isHidden = false
            badgeLabel.isHidden = false
            if badgeStringValue == "" {
                // 小圆点
                imageView.center = CGPoint(x: self.YH_Width / 2.0, y: self.YH_Height / 2.0)
                imageView.bounds = CGRect(x: 0, y: 0, width: YHTabBarItemBadgeView.dotSize.width, height: YHTabBarItemBadgeView.dotSize.height)
                
                imageView.layer.cornerRadius = YHTabBarItemBadgeView.dotSize.height / 2.0
                imageView.layer.masksToBounds = true
            } else {
                imageView.frame = bounds
                
                imageView.layer.cornerRadius = imageView.YH_Height / 2.0
                imageView.layer.masksToBounds = true
            }
            badgeLabel.sizeToFit()
            badgeLabel.center = imageView.center
            return
        }
        
        if let _ = badgeValue as? UIImage {
            badgeLabel.isHidden = true
            imageView.isHidden = false
            
            imageView.layer.cornerRadius = 0
            imageView.layer.masksToBounds = false
            imageView.frame = bounds
            return
        }
    }
    
    
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        guard let badgeValue = badgeValue else {
            return CGSize(width: 18, height: 18)
        }
        
        if let _ = badgeValue as? String {
            let textSize = badgeLabel.sizeThatFits(CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
            return CGSize(width: max(18.0, textSize.width + 10.0), height: 18.0)
        }
        
        if let badgeImageValue = badgeValue as? UIImage {
            let ratio = badgeImageValue.size.width / badgeImageValue.size.height
            if ratio >= 1.0 {
                let width = min(45.0, badgeImageValue.size.width)
                let height = badgeImageValue.size.height / badgeImageValue.size.width * width
                return CGSize(width: width, height: height)
            } else {
                let height = min(45.0, badgeImageValue.size.height)
                let width = badgeImageValue.size.width / badgeImageValue.size.height * height
                return CGSize(width: width, height: height)
            }
        }
        return .zero
    }
}
