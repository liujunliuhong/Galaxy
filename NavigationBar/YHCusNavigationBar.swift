//
//  YHCusNavigationBar.swift
//  SwiftTool
//
//  Created by apple on 2019/5/9.
//  Copyright © 2019 yinhe. All rights reserved.
//

import UIKit
/*
 自定义导航栏需要注意些什么？
 
 1、耦合性要低。
 如果接手一个别人写的项目，那么就尽量不要去改动别人写的代码。如果别人接手我写的代码，那么别人可以在不改动我代码的情况下，加入自己的逻辑
 
 2、灵活
 
 */

class YHCusNavigationBarItem: NSObject {
    var view: UIView!
    @objc dynamic var width: CGFloat = 50.0
}

class YHCusNavigationSpaceItem: NSObject {
    var space: CGFloat = 0.0
}

class YHCusNavigationToolItem: NSObject {
    var item: UIView!
    var height: CGFloat = 0.0
}

/*
 继承自UIView
 对屏幕旋转已经做了适配
*/
class YHCusNavigationBar: UIView {
    
    deinit {
        YHDebugLog("\(NSStringFromClass(YHCusNavigationBar.classForCoder())) deinit")
        
        // Remove observe.
        for (_, item) in leftItems.enumerated() {
            if let item = item as? YHCusNavigationBarItem {
                item.removeObserver(self, forKeyPath: "width")
            }
        }
        for (_, item) in rightItems.enumerated() {
            if let item = item as? YHCusNavigationBarItem {
                item .removeObserver(self, forKeyPath: "width")
            }
        }
        if let toolItem = toolItem {
            toolItem.removeObserver(self, forKeyPath: "height")
        }
    }
    
    
    private let line: UIView!
    
    var gradientLayer: CAGradientLayer? {
        didSet {
            setupItems()
        }
    }
    
    // If is nil, toolItem will not be displayed.
    var toolItem: YHCusNavigationToolItem? {
        didSet {
            setupBar()
            setupItems()
        }
    }
    
    private let barHeight: CGFloat = 44.0
    
    var naviBarWidth: CGFloat {
        didSet {
            setupBar()
            setupItems()
        }
    }
    
    var isHideBar: Bool = false {
        didSet {
            setupBar()
            setupItems()
        }
    }
    
    var isHideNaviBar: Bool = true {
        didSet {
            setupBar()
            setupItems()
        }
    }
    
    
    var leftItems = [Any]() {
        didSet {
            setupItems()
        }
    }
    var rightItems = [Any]() {
        didSet {
            setupItems()
        }
    }
    
    private var statusBarHeight: CGFloat {
        if UIApplication.shared.isStatusBarHidden {
            return 0.0
        } else {
            return UIApplication.shared.statusBarFrame.size.height
        }
    }
    
    // If is nil, titleView will not be displayed.
    var titleView: UIView? {
        didSet {
            setupItems()
        }
    }
    
    var lineColor: UIColor = UIColor.YH_RGBA(R: 211, G: 210, B: 211) {
        didSet {
            self.line.backgroundColor = self.lineColor
        }
    }
    
    var isHideLine: Bool = false {
        didSet {
            self.line.isHidden = self.isHideLine
        }
    }
    
    init(with naviBarWidth: CGFloat = UIDevice.YH_Width()) {
        self.naviBarWidth = naviBarWidth
        
        self.line = UIView()
        self.line.backgroundColor = lineColor
        self.line.isHidden = isHideLine
        
        super.init(frame: .zero);
        
        backgroundColor = .purple
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.setupBar()
            self.setupItems()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(didChangeStatusBarFrame(noti:)), name: UIApplication.didChangeStatusBarFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didChangeStatusBarOrientation(noti:)), name: UIApplication.didChangeStatusBarOrientationNotification, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Notification
    @objc
    func didChangeStatusBarFrame(noti: Notification) {
        // Why delay 0.1 seconds? If there is no delay, the height of the status bar is not correct.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.naviBarWidth = UIDevice.YH_Width()
        }
    }
    
    @objc
    func didChangeStatusBarOrientation(noti: Notification) {
        // Why delay 0.1 seconds? If there is no delay, the height of the status bar is not correct.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.naviBarWidth = UIDevice.YH_Width()
        }
    }
    
    
    // MARK: - Methods
    func setupBar() {
        isHidden = isHideNaviBar
        if isHideNaviBar {
            return
        }
        
        let o_x: CGFloat = 0.0
        let o_y: CGFloat = 0.0
        let width: CGFloat = naviBarWidth
        var height: CGFloat = statusBarHeight + barHeight
        if let toolItem = toolItem {
            height += toolItem.height
        }

        frame = CGRect(x: o_x, y: o_y, width: width, height: height)
    }
    
    
    func setupItems() {
        // Remove.
        for (_, view) in subviews.enumerated() {
            view.removeFromSuperview()
        }
        if let gradientLayer = gradientLayer {
            gradientLayer.removeFromSuperlayer()
        }
        
        // Add Tool Item.
        if let toolItem = toolItem {
            toolItem.addObserver(self, forKeyPath: "height", options: [.new, .old], context: nil)
            addSubview(toolItem.item)
            toolItem.item.frame = CGRect(x: 0.0, y: frame.size.height - toolItem.height, width: frame.size.width, height: toolItem.height)
        }
        
        // Add Bar Item.
        if !isHideBar {
            var leftWidth: CGFloat = 0.0
            
            var toolHeight: CGFloat = 0.0
            if let toolItem = toolItem {
                toolHeight = toolItem.height
            }
            
            for (_, item) in leftItems.enumerated() {
                if let spaceItem = item as? YHCusNavigationSpaceItem {
                    leftWidth += spaceItem.space
                } else if let item = item as? YHCusNavigationBarItem {
                    item.addObserver(self, forKeyPath: "width", options: [.new, .old], context: nil)
                    addSubview(item.view)
                    
                    item.view.frame = CGRect(x: leftWidth, y: frame.size.height - barHeight - toolHeight, width: item.width, height: barHeight)
                    
                    leftWidth += item.width
                    
                    item.view.backgroundColor = UIColor.YH_RandomColor()
                }
            }
            
            var rightWidth: CGFloat = 0.0
            for (_, item) in rightItems.enumerated().reversed() {
                if let spaceItem = item as? YHCusNavigationSpaceItem {
                    rightWidth += spaceItem.space
                } else if let item = item as? YHCusNavigationBarItem {
                    item.addObserver(self, forKeyPath: "width", options: [.new, .old], context: nil)
                    addSubview(item.view)
                    
                    item.view.frame = CGRect(x: naviBarWidth - rightWidth - item.width, y: frame.size.height - barHeight - toolHeight, width: item.width, height: barHeight)
                    
                    rightWidth += item.width
                    
                    item.view.backgroundColor = UIColor.YH_RandomColor()
                }
            }
            
            let titleWidth = (naviBarWidth / 2.0 - max(leftWidth, rightWidth)) * 2;
            if titleWidth > 0, let titleView = titleView {
                addSubview(titleView)
                titleView.frame = CGRect(x: (naviBarWidth - titleWidth) / 2.0, y: frame.size.height - barHeight - toolHeight, width: titleWidth, height: barHeight)
            }
        }
        // Add Line.
        addSubview(line)
        line.frame = CGRect(x: 0, y: frame.size.height - 0.5, width: naviBarWidth, height: 0.5);
        
        // Add GradientLayer.
        if let gradientLayer = gradientLayer {
            gradientLayer.frame = self.bounds
            layer.insertSublayer(gradientLayer, at: 0)
        }
    }

    // KVO.
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "width", let item = object as? YHCusNavigationBarItem {
            item.removeObserver(self, forKeyPath: keyPath!)
            setupItems()
        } else if keyPath == "height", let toolItem = object as? YHCusNavigationToolItem {
            toolItem.removeObserver(self, forKeyPath: keyPath!)
            setupBar()
            setupItems()
        }
    }
}
