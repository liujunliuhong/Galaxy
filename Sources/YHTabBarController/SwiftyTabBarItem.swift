//
//  SwiftyTabBarItem.swift
//  SwiftTool
//
//  Created by apple on 2020/6/16.
//  Copyright © 2020 yinhe. All rights reserved.
//

import UIKit

/*
 
 */
public class SwiftyTabBarItem: UITabBarItem {
    
    public var containerView: SwiftyTabBarItemContainer?
    
    public override var title: String? {
        didSet {
            self.containerView?.title = title
        }
    }
    
    public override var image: UIImage? {
        didSet {
            self.containerView?.normalImage = image
        }
    }
    
    public override var selectedImage: UIImage? {
        didSet {
            self.containerView?.selectedImage = selectedImage
        }
    }
    
    public override var badgeValue: String? {
        didSet {
            
        }
    }
    
    public override var badgeColor: UIColor? {
        didSet {
            
        }
    }
    
    public override var tag: Int {
        didSet {
            self.containerView?.tag = tag
        }
    }
    
    public override var titlePositionAdjustment: UIOffset {
        didSet {
            self.containerView?.titlePositionAdjustment = titlePositionAdjustment
        }
    }
    
    public init(containerView: SwiftyTabBarItemContainer, title: String? = nil, image: UIImage? = nil, selectedImage: UIImage? = nil, tag: Int = 0) {
        super.init()
        self.containerView = containerView
        self.setTitle(title: title, image: image, selectedImage: selectedImage, tag: tag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension SwiftyTabBarItem {
    internal func setTitle(title: String?, image: UIImage?, selectedImage: UIImage?, tag: Int) {
        self.title = title
        self.image = image
        self.selectedImage = selectedImage
        self.tag = tag
    }
}
