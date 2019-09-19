//
//  YHTabBarItem.swift
//  FNDating
//
//  Created by apple on 2019/9/19.
//  Copyright © 2019 yinhe. All rights reserved.
//

import UIKit

class YHTabBarItem: NSObject {
    
    var contentView: YHTabBatItemContentView?
    
    var title: String? {
        didSet {
            
        }
    }
    
    var image: UIImage? {
        didSet {
            
        }
    }
    
    var selectImage: UIImage? {
        didSet {
            
        }
    }
    
    var badgeValue: AnyObject? {
        didSet {
            
        }
    }
    
    var badgeColor: UIColor? {
        didSet {
            
        }
    }
    
    init(_ contentView: YHTabBatItemContentView = YHTabBatItemContentView(),
         title: String? = nil,
         image: UIImage? = nil,
         selectedImage: UIImage? = nil) {
        
        super.init()
        
        self.contentView = contentView
    }
}

extension YHTabBarItem {
    func set(title:String? = nil, image: UIImage? = nil, selectedImage: UIImage? = nil) {
        self.title = title
        self.image = image
        self.selectImage = selectedImage
    }
}
