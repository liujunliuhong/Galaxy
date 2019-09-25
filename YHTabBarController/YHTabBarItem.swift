//
//  YHTabBarItem.swift
//  FNDating
//
//  Created by apple on 2019/9/19.
//  Copyright © 2019 yinhe. All rights reserved.
//

import UIKit

open class YHTabBarItem: UITabBarItem {
    
    open var contentView: YHTabBatItemContentView?
    
    open override var title: String? {
        didSet {
            self.contentView?.title = title
        }
    }
    
    open override var image: UIImage? {
        didSet {
            self.contentView?.normalImage = image
        }
    }
    
    open override var selectedImage: UIImage? {
        didSet {
            self.contentView?.selectedImage = selectedImage
        }
    }
    
    open override var badgeValue: String? {
        didSet {
            self.contentView?.badgeValue = badgeValue as AnyObject?
        }
    }
    
    open var badgeImageValue: UIImage? {
        didSet {
            self.contentView?.badgeValue = badgeImageValue as AnyObject?
            self.badgeColor = .clear
        }
    }
    
    open override var titlePositionAdjustment: UIOffset {
        didSet {
            self.contentView?.titlePositionAdjustment = titlePositionAdjustment
        }
    }
    
    open var imagePositionAdjustment: UIOffset = UIOffset.zero {
        didSet {
            self.contentView?.imagePositionAdjustment = imagePositionAdjustment
        }
    }
    
    
    open override var badgeColor: UIColor? {
        get {
            return contentView?.badgeColor
        }
        set(newValue) {
            contentView?.badgeColor = newValue
        }
    }
    
    open var badgeContentColor: UIColor? {
        didSet {
            contentView?.badgeContentColor = badgeContentColor
        }
    }
    
    open override var tag: Int {
        didSet {
            self.contentView?.tag = tag
        }
    }
    
    @available(iOS, unavailable)
    public override init() {
        super.init()
    }
    
    public init(_ contentView: YHTabBatItemContentView = YHTabBatItemContentView(),
         title: String? = nil,
         normalImage: UIImage? = nil,
         selectedImage: UIImage? = nil,
         tag: Int = 0) {
        
        super.init()
        
        self.contentView = contentView
        
        set(title: title, image: normalImage, selectedImage: selectedImage, tag: tag)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension YHTabBarItem {
    open func set(title:String? = nil, image: UIImage? = nil, selectedImage: UIImage? = nil, tag: Int = 0) {
        self.title = title
        self.image = image
        self.selectedImage = selectedImage
        self.tag = tag
    }
}
