//
//  SwiftyTabBarBadgeView.swift
//  SwiftTool
//
//  Created by apple on 2020/6/16.
//  Copyright © 2020 yinhe. All rights reserved.
//

import UIKit

// default badge color
internal let defaultBadgeColor = UIColor(red: 255.0/255.0, green: 59.0/255.0, blue: 48.0/255.0, alpha: 1.0)
// default dot size
internal let defaultDotSize = CGSize(width: 8.0, height: 8.0)
// default badge height
internal let defaultBadgeHeight: CGFloat = 18.0

open class SwiftyTabBarBadgeView: UIView {
    
    open var badgeValue: String? {
        didSet {
            self.badgeLabel.text = badgeValue
        }
    }
    
    open var badgeColor: UIColor = defaultBadgeColor{
        didSet {
            self.backgroundColor = badgeColor
        }
    }
    
    open var badgeContentColor: UIColor = .white {
        didSet {
            self.badgeLabel.textColor = badgeContentColor
        }
    }
    
    open var dotSize: CGSize = defaultDotSize
    
    open var badgeHeight: CGFloat = defaultBadgeHeight
    
    open var badgeBorderWidth: CGFloat = .zero {
        didSet {
            self.layer.borderWidth = badgeBorderWidth
        }
    }
    
    open var badgeBorderColor: UIColor = .clear {
        didSet {
            self.layer.borderColor = badgeBorderColor.cgColor
        }
    }
    
    public lazy var badgeLabel: UILabel = {
        let badgeLabel = UILabel.init(frame: CGRect.zero)
        badgeLabel.backgroundColor = .clear
        badgeLabel.font = UIFont.systemFont(ofSize: 13.0)
        badgeLabel.textAlignment = .center
        badgeLabel.numberOfLines = 1
        return badgeLabel
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        //
        self.addSubview(self.badgeLabel)
        //
        self.backgroundColor = self.badgeColor
        self.badgeLabel.textColor = self.badgeContentColor
        self.layer.borderWidth = self.badgeBorderWidth
        self.layer.borderColor = self.badgeContentColor.cgColor
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension SwiftyTabBarBadgeView {
    open override func layoutSubviews() {
        super.layoutSubviews()
        guard let badgeValue = self.badgeValue else {
            self.badgeLabel.isHidden = true
            return
        }
        self.badgeLabel.isHidden = false
        if badgeValue == "" {
            self.badgeLabel.frame = self.bounds
        } else {
            self.badgeLabel.sizeToFit()
            self.badgeLabel.center = CGPoint(x: self.frame.width / 2.0, y: self.frame.height / 2.0)
        }
        self.layer.cornerRadius = self.frame.height / 2.0
        self.layer.borderWidth = self.badgeBorderWidth
        self.layer.borderColor = self.badgeBorderColor.cgColor
        self.layer.masksToBounds = true
    }
}

extension SwiftyTabBarBadgeView {
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        guard let badgeValue = self.badgeValue else {
            return .zero
        }
        if badgeValue == "" {
            return self.dotSize
        } else {
            let textSize = self.badgeLabel.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
            
            let height = max(textSize.height, self.badgeHeight)
            var width: CGFloat = textSize.width + 10.0
            if width.isLess(than: height) {
                width = height
            }
            return CGSize(width: width, height: height)
        }
    }
}
