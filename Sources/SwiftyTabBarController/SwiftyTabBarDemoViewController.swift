//
//  SwiftyTabBarDemoViewController.swift
//  SwiftTool
//
//  Created by apple on 2020/6/18.
//  Copyright © 2020 yinhe. All rights reserved.
//

import UIKit


fileprivate class TabBarItemContainer: SwiftyTabBarItemContainer {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.normalTextColor = UIColor.orange
        self.selectedTextColor = UIColor.red
        
        self.normalIconColor = UIColor.orange
        self.selectedIconColor = UIColor.red
        
        self.selectedBackgroundColor = .orange
        
        self.insets = UIEdgeInsets(top: 0, left: 0, bottom: 34, right: 0)
        
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateLayout() {
        super.updateLayout()
        
    }
}

fileprivate class TestViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.backgroundColor = self.randomColor()
        self.view.backgroundColor = .white
    }
    
    func randomColor() -> UIColor {
        let R: CGFloat = CGFloat(arc4random() % 255)
        let G: CGFloat = CGFloat(arc4random() % 255)
        let B: CGFloat = CGFloat(arc4random() % 255)
        let A: CGFloat = 1.0
        return UIColor(red: (CGFloat(R) / 255.0), green: (CGFloat(G) / 255.0), blue: (CGFloat(B) / 255.0), alpha: A)
    }
}



public class SwiftyTabBarDemoViewController: SwiftyTabBarController {
    
    let images: [UIImage?]
    let selectImages: [UIImage?]
    let titles: [String]
    init(images: [UIImage?], selectImages: [UIImage?], titles: [String]) {
        self.images = images
        self.selectImages = selectImages
        self.titles = titles
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        var vcs: [TestViewController] = []
        for (index, t) in self.titles.enumerated() {
            if index == self.titles.count - 1 {
                let item = UITabBarItem(title: t, image: self.images[index]?.withRenderingMode(.alwaysOriginal), selectedImage: self.selectImages[index]?.withRenderingMode(.alwaysOriginal))
                let vc = TestViewController()
                vc.tabBarItem = item
                vcs.append(vc)
            } else {
                let item = SwiftyTabBarItem(containerView: TabBarItemContainer(), title: t, image: self.images[index], selectedImage: self.selectImages[index])
                let vc = TestViewController()
                vc.tabBarItem = item
                vcs.append(vc)
            }
        }
        self.viewControllers = vcs
        

        (self.tabBar as? SwiftyTabBar)?.itemCustomPositioning = .fillUp
        (self.tabBar as? SwiftyTabBar)?.shadowColor = UIColor.clear
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
    }
}

