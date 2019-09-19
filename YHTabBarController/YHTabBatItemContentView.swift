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
//  ●━━━━━━─────── ⇆ ◁ ❚❚ ▷
