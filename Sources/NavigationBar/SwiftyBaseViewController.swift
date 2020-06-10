//
//  SwiftyBaseViewController.swift
//  SwiftTool
//
//  Created by apple on 2020/6/10.
//  Copyright © 2020 yinhe. All rights reserved.
//

import UIKit
import SnapKit

@objc public class SwiftyBaseViewController: UIViewController {
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIApplication.didChangeStatusBarOrientationNotification, object: nil)
    }
    
    @objc public lazy var cusNaviBar: SwiftyCusNavigationBar = {
        let cusNaviBar = SwiftyCusNavigationBar()
        cusNaviBar.hideNavigationBar = true // By default, the entire navigation bar is hidden to avoid bugs. if set to true, the navigation bar will flash when entering an interface that needs to hide the navigation bar
        cusNaviBar.hideBar = false
        cusNaviBar.hideToolBar = true
        cusNaviBar.hideStatusBar = false
        return cusNaviBar
    }()
    
    @objc public lazy var safeAreaView: UIView = {
        let safeView = UIView()
        return safeView
    }()
    

    override public func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(cusNaviBar)
        self.view.addSubview(safeAreaView)
        
        // reload
        self.cusNaviBar.reload(origin: .zero, barWidth: UIDevice.YH_Width)
        
        // safeAreaView
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(deviceRotaion), name: UIApplication.didChangeStatusBarOrientationNotification, object: nil)
        
        self.initData()
        self.setupUI()
        self.bindViewModel()
        self.other()
    }
    
    // The status bar is not hidden by default.
    @objc override public var prefersStatusBarHidden: Bool {
        return false
    }
    
    // Screen default no rotation.
    @objc override public var shouldAutorotate: Bool {
        return false
    }
    
    // Default supports all screen rotation directions.
    @objc override public var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .all
    }
    
    // Default Display Vertical Screen.
    @objc override public var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
    
    // Default does not hide virtual home indicator.
    @objc override public var prefersHomeIndicatorAutoHidden: Bool{
        return false
    }

    // Set the default status bar style based on the values in info. plist.
    @objc override public var preferredStatusBarStyle: UIStatusBarStyle{
        let infoDic = Bundle.main.infoDictionary
        if let infoDic = infoDic, let style = infoDic["UIStatusBarStyle"] as? String, style == "UIStatusBarStyleLightContent" {
            return .lightContent
        }
        return .default
    }
    
    @objc override public var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .fade
    }
}

extension SwiftyBaseViewController {
    @objc public func initData() {
        
    }
    
    @objc public func setupUI() {
        
    }
    
    @objc public func bindViewModel() {
        
    }
    
    @objc public func other() {
        
    }
}



@objc public extension SwiftyBaseViewController {
    @objc func deviceRotaion() {
        self.cusNaviBar.reload(origin: .zero, barWidth: UIDevice.YH_Width)
    }
}
