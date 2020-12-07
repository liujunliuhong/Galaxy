//
//  NextViewController.swift
//  SwiftTool
//
//  Created by galaxy on 2020/10/25.
//  Copyright © 2020 yinhe. All rights reserved.
//

import UIKit

class NextViewController: GLBaseViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        
        self.cusNaviBar.hideNavigationBar = false
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let label = UILabel()
            label.text = "测试"
            label.textAlignment = .center
            let titleView = GLCusNaviBarTitle(view: label, layoutType: .fill)
            self.cusNaviBar.title = titleView
            
            let space = GLCusNaviBarSpace(space: 20)
            
            
            let button = UIButton(type: .system)
            button.backgroundColor = .gray
            button.setTitle("button", for: .normal)
            let leftItem1 = GLCusNaviBarButtonItem(view: button, layoutType: .custom(width: 80, height: self.cusNaviBar.barHeight))
            self.cusNaviBar.leftItems = [space, leftItem1]
            
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
}
