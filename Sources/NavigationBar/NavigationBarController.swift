//
//  NavigationBarController.swift
//  SwiftTool
//
//  Created by galaxy on 2021/5/27.
//  Copyright © 2021 yinhe. All rights reserved.
//

import UIKit
import SnapKit

/// 1、设置`Info.plist`中`View controller-based status bar appearance`为 YES
/// 2、`TARGETS`设置支持所有方向
/// 3、`TARGETS`的`Main Interfac`e里面的`Main`去掉(很重要，否则会出现界面没旋转，但是状态栏旋转的情况)
/// 4、接下来就可以根据页面结构设置旋转了
open class NavigationBarController: UIViewController {
    
    public lazy var safeAreaView: UIView = {
        let safeView = UIView()
        return safeView
    }()
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        //
        gl.addNavigationBar()
        //
        view.addSubview(safeAreaView)
        safeAreaView.snp.makeConstraints { (make) in
            make.top.equalTo(self.gl.navigationBar!.snp.bottom)
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
        
        initData()
        setupUI()
        bindViewModel()
        other()
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
extension NavigationBarController {
    @objc open func initData() { }
    @objc open func setupUI() { }
    @objc open func bindViewModel() { }
    @objc open func other() { }
}
