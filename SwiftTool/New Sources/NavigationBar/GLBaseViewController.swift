//
//  GLBaseViewController.swift
//  SwiftTool
//
//  Created by galaxy on 2020/10/25.
//  Copyright © 2020 yinhe. All rights reserved.
//

import UIKit
import SnapKit

open class GLBaseViewController: UIViewController {
    deinit {
        
    }
    
    public lazy var cusNaviBar: GLCusNavigationBar = {
        let cusNaviBar = GLCusNavigationBar()
        // By default, the entire navigation bar is hidden to avoid bugs. if set to true, the navigation bar will flash when entering an interface that needs to hide the navigation bar
        cusNaviBar.hideNavigationBar = true
        cusNaviBar.hideBar = false
        cusNaviBar.hideToolBar = true
        cusNaviBar.hideStatusBar = false
        return cusNaviBar
    }()
    
    public lazy var safeAreaView: UIView = {
        let safeView = UIView()
        return safeView
    }()
    
    override open func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(cusNaviBar)
        self.view.addSubview(safeAreaView)
        
        self.cusNaviBar.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
        }
        self.safeAreaView.snp.makeConstraints { (make) in
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
        
        self.initData()
        self.setupUI()
        self.bindViewModel()
        self.other()
    }
    
    // The status bar is not hidden by default.
    override open var prefersStatusBarHidden: Bool {
        return false
    }
    
    // Screen default no rotation.
    override open var shouldAutorotate: Bool {
        return false
    }
    
    // Default supports all screen rotation directions.
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .all
    }
    
    // Default Display Vertical Screen.
    override open var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
    
    // Default does not hide virtual home indicator.
    override open var prefersHomeIndicatorAutoHidden: Bool {
        return false
    }

    // Set the default status bar style based on the values in info. plist.
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        let infoDic = Bundle.main.infoDictionary
        if let infoDic = infoDic, let style = infoDic["UIStatusBarStyle"] as? String, style == "UIStatusBarStyleLightContent" {
            return .lightContent
        }
        return .default
    }
    
    override open var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .fade
    }
}

// MARK: - Override
extension GLBaseViewController {
    open func initData() {
        
    }
    
    open func setupUI() {
        
    }
    
    open func bindViewModel() {
        
    }
    
    open func other() {
        
    }
}
