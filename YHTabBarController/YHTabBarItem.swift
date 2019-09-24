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
    
    open override var badgeColor: UIColor? {
        get {
            return contentView?.badgeColor
        }
        set(newValue) {
            contentView?.badgeColor = newValue
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
         image: UIImage? = nil,
         selectedImage: UIImage? = nil,
         tag: Int = 0) {
        
        super.init()
        
        self.contentView = contentView
        
        set(title: title, image: image, selectedImage: selectedImage, tag: tag)
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
