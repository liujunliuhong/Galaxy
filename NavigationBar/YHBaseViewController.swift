//
//  YHBaseViewController.swift
//  SwiftTool
//
//  Created by apple on 2019/5/9.
//  Copyright © 2019 yinhe. All rights reserved.
//

import UIKit
import SnapKit


// 和YHCusNavigationBar耦合的一个BaseVC，包含一个cusNaviBar和safeAreaView，safeAreaView已经做了适配
// 主要处理了屏幕旋转相关的问题
// 也可以单独把YHCusNavigationBar拿出来用
class YHBaseViewController: UIViewController {
    public lazy var cusNaviBar: YHCusNavigationBar = {
        let cusNaviBar = YHCusNavigationBar()
        cusNaviBar.hideNaviBar = true // 默认隐藏整个导航栏，避免bug：如果设置为true，进入一个需要隐藏导航栏的界面时，导航栏会闪一下
        cusNaviBar.hideBar = false
        cusNaviBar.hideToolBar = true
        cusNaviBar.hideStatusBar = false
        return cusNaviBar
    }()
    
    public lazy var safeAreaView: UIView = {
        let safeView = UIView()
        return safeView
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(cusNaviBar)
        self.view.addSubview(safeAreaView)
        
        self.cusNaviBar.reloadUI(origin: .zero, width: self.view.frame.size.width)
        
        safeAreaView.snp.makeConstraints { (make) in
            make.top.equalTo(self.cusNaviBar.snp.bottom)
            if #available(iOS 11.0, *) {
                make.right.equalTo(self.view.safeAreaLayoutGuide)
                make.left.equalTo(self.view.safeAreaLayoutGuide)
                make.bottom.equalTo(self.view.safeAreaLayoutGuide)
            } else {
                make.right.equalTo(self.view)
                make.left.equalTo(self.view)
                make.bottom.equalTo(self.view)
            }
        }
    }
    
    // The status bar is not hidden by default.
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    // Screen default no rotation.
    override var shouldAutorotate: Bool {
        return false
    }
    
    // Default supports all screen rotation directions.
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .all
    }
    
    // Default Display Vertical Screen.
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
    
    // Default does not hide virtual home indicator.
    override var prefersHomeIndicatorAutoHidden: Bool{
        return false
    }

    // Set the default status bar style based on the values in info. plist.
    override var preferredStatusBarStyle: UIStatusBarStyle{
        let infoDic = Bundle.main.infoDictionary
        if let infoDic = infoDic, let style = infoDic["UIStatusBarStyle"] as? String, style == "UIStatusBarStyleLightContent" {
            return .lightContent
        }
        return .default
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .fade
    }
}




