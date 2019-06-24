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

    let cusNaviBar: YHCusNavigationBar
    let safeAreaView: UIView
    
    init() {
        self.cusNaviBar = YHCusNavigationBar()
        self.cusNaviBar.isHideNaviBar = false
        
        self.safeAreaView = UIView()
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
}
