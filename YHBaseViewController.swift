//
//  YHBaseViewController.swift
//  SwiftTool
//
//  Created by apple on 2019/5/9.
//  Copyright © 2019 yinhe. All rights reserved.
//

import UIKit
import SnapKit


/// 和YHCusNavigationBar耦合的一个BaseVC，包含一个cusNaviBar和safeAreaView，safeAreaView已经做了适配
class YHBaseViewController: UIViewController {

    //    let cusNaviBar: YHCusNavigationBar
    //    let safeAreaView: UIView
    //
    //    init() {
    //        self.cusNaviBar = YHCusNavigationBar()
    //        self.cusNaviBar.isHideNaviBar = false
    //
    //        self.safeAreaView = UIView()
    //
    //        super.init(nibName: nil, bundle: nil)
    //    }
    
    //    required init?(coder aDecoder: NSCoder) {
    //        fatalError("init(coder:) has not been implemented")
    //    }
    
    lazy var cusNaviBar: YHCusNavigationBar = {
        let cusBar = YHCusNavigationBar()
        cusBar.isHideNaviBar = true
        return cusBar
    }()
    
    lazy var safeAreaView: UIView = {
        let safeView = UIView()
        return safeView
    }()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(cusNaviBar)
        
        self.view.addSubview(safeAreaView)
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
        if let infoDic = infoDic,  let style = infoDic["UIStatusBarStyle"] as? String {
            if style == "UIStatusBarStyleLightContent" {
                return .lightContent
            }
        }
        return .default
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .fade
    }
}




