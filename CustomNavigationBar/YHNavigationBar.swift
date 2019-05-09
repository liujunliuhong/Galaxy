//
//  YHNavigationBar.swift
//  SwiftTool
//
//  Created by apple on 2019/5/9.
//  Copyright © 2019 yinhe. All rights reserved.
//

import UIKit

class YHNavigationBar: UIView {
    
    var leftItems = [YHNavigationBarItem]() {
        didSet {
            setup()
        }
    }
    var rightItems = [YHNavigationBarItem]() {
        didSet {
            setup()
        }
    }
    
    
    var leftViews = [UIView]()
    var rightViews = [UIView]()
    
    let centerView = UIView()
    
    
    
    
    var leftHorizontalEdgeInsetWhenLandscape: CGFloat = 0.0
    var rightHorizontalEdgeInsetWhenLandscape: CGFloat = 0.0
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        
        
        
        
        
    }
    
    
    
    
    func setup() -> Void {
        self.leftViews.removeAll()
        self.rightViews.removeAll()
        
        for leftItem in self.leftItems {
            var frame = leftItem.view.frame
            frame.size.width = leftItem.width
            leftItem.view.frame = frame
            
            self.leftViews.append(leftItem.view)
        }
        
        for rightItem in self.rightItems {
            var frame = rightItem.view.frame
            frame.size.width = rightItem.width
            rightItem.view.frame = frame
            
            self.leftViews.append(rightItem.view)
        }
        
        
        
        var originX: CGFloat = 0.0
        for view in self.leftViews {
            view.frame = CGRect(x: originX, y: 0, width: view.frame.size.width, height: self.frame.size.height);
            originX += view.frame.size.width
        }
        
        
        
        
        
        
    }
    
    
    
    
    
    func isPortrait() -> Bool {
        let orientation = UIApplication.shared.statusBarOrientation
        return orientation == .portrait || orientation == .portraitUpsideDown
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
