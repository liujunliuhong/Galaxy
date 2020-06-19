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
        
        //self.selectedBackgroundColor = .orange
        //self.insets = UIEdgeInsets(top: 0, left: 0, bottom: 34, right: 0)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateLayout() {
        super.updateLayout()
        
    }
}

fileprivate class TabBarItemPlusContainer: SwiftyTabBarItemContainer {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.normalIconColor = UIColor.white
        self.imageView.backgroundColor = UIColor.purple
//        self.imageView.layer.borderWidth = 3.0
//        self.imageView.layer.borderColor = UIColor(white: 235 / 255.0, alpha: 1.0).cgColor
//        self.imageView.layer.cornerRadius = 35
        
        
        self.insets = UIEdgeInsets.init(top: -32, left: 0, bottom: 0, right: 0)
        
        let transform = CGAffineTransform.identity
        self.imageView.transform = transform
        self.superview?.bringSubviewToFront(self)
        
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let p = CGPoint.init(x: point.x - imageView.frame.origin.x, y: point.y - imageView.frame.origin.y)
        return sqrt(pow(imageView.bounds.size.width / 2.0 - p.x, 2) + pow(imageView.bounds.size.height / 2.0 - p.y, 2)) < imageView.bounds.size.width / 2.0
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateLayout() {
        super.updateLayout()
        
        //self.imageView.sizeToFit()
        self.imageView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        self.imageView.center = CGPoint(x: self.bounds.size.width / 2.0, y: self.bounds.size.height / 2.0)
    }
}






fileprivate class TestViewController: UIViewController {
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let testImage: UIImage?
    init(testImage: UIImage?) {
        self.testImage = testImage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.backgroundColor = self.randomColor()
        self.view.backgroundColor = .white
        
        self.view.addSubview(self.imageView)
        self.imageView.frame = CGRect(x: 0, y: 0, width: 250, height: 250)
        self.imageView.center = CGPoint(x: self.view.frame.width / 2.0, y: self.view.frame.height / 2.0)
        self.imageView.backgroundColor = .purple
        self.imageView.image = self.testImage
    }
    
    func randomColor() -> UIColor {
        let R: CGFloat = CGFloat(arc4random() % 255)
        let G: CGFloat = CGFloat(arc4random() % 255)
        let B: CGFloat = CGFloat(arc4random() % 255)
        let A: CGFloat = 1.0
        return UIColor(red: (CGFloat(R) / 255.0), green: (CGFloat(G) / 255.0), blue: (CGFloat(B) / 255.0), alpha: A)
    }
}


public struct SwiftyTabBarDemoProvider {
    public static func demo(images: [UIImage?], selectImages: [UIImage?], titles: [String]) -> SwiftyTabBarController {
        let tabBarVC = SwiftyTabBarController()
        var vcs: [TestViewController] = []
        for (index, t) in titles.enumerated() {
//            if index == titles.count - 2 {
//                let item = UITabBarItem(title: t, image: images[index]?.withRenderingMode(.alwaysOriginal), selectedImage: selectImages[index]?.withRenderingMode(.alwaysOriginal))
//                let vc = TestViewController()
//                vc.tabBarItem = item
//                vcs.append(vc)
//            } else
            if (index == 1) {
                let item = SwiftyTabBarItem(containerView: TabBarItemPlusContainer(), title: nil, image: images[index], selectedImage: selectImages[index])
                let vc = TestViewController(testImage: images[index])
                vc.tabBarItem = item
                vcs.append(vc)
                
            } else {
                let item = SwiftyTabBarItem(containerView: TabBarItemContainer(), title: t, image: images[index], selectedImage: selectImages[index])
                let vc = TestViewController(testImage: nil)
                vc.tabBarItem = item
                vcs.append(vc)
            }
        }
        tabBarVC.viewControllers = vcs
        
//        tabBarVC.shouldHijackHandler = { (tabBarVC, vc, index) -> Bool in
//            if index == 1 {
//                return true
//            }
//            return false
//        }
        
        tabBarVC.didHijackHandler = { (tabBarVC, vc, index) in
            print("didHijackHandler - \(index)")
        }
        
//        (tabBarVC as? SwiftyTabBar)?.itemCustomPositioning = .system(position: .automatic)
//        (tabBarVC as? SwiftyTabBar)?.shadowColor = UIColor.clear
        
        return tabBarVC
    }
}
