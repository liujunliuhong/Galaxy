//
//  GLCusNavigationBarDemoViewController.swift
//  SwiftTool
//
//  Created by galaxy on 2020/10/25.
//  Copyright © 2020 yinhe. All rights reserved.
//

import UIKit

public class GLCusNavigationBarDemoViewController: GLBaseViewController {

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    public override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        
        self.cusNaviBar.hideNavigationBar = false
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let label = UILabel()
            label.text = "测试"
            label.textAlignment = .center
            let titleView = GLCusNaviBarTitle(view: label, layoutType: .center)
            self.cusNaviBar.title = titleView
            
            let space = GLCusNaviBarSpace(space: 20)
            
            
            let button = UIButton(type: .system)
            button.backgroundColor = .gray
            button.setTitle("button", for: .normal)
            let leftItem1 = GLCusNaviBarButtonItem(view: button, layoutType: .custom(y: 0, width: 80, height: self.cusNaviBar.barHeight))
            self.cusNaviBar.leftItems = [space, leftItem1]
            
            let graidentLayer = CAGradientLayer()
            graidentLayer.colors = [UIColor.red.cgColor, UIColor.orange.cgColor]
            graidentLayer.startPoint = CGPoint(x: 0, y: 0)
            graidentLayer.endPoint = CGPoint(x: 0, y: 1)
            self.cusNaviBar.backgroundLayer = graidentLayer
            
            
            self.cusNaviBar.toolHeight = 50.0
            self.cusNaviBar.hideToolBar = false
            self.cusNaviBar.toolView.backgroundColor = UIColor.cyan.withAlphaComponent(0.5)
            
            self.cusNaviBar.lineHeight = 2.0
            self.cusNaviBar.lineColor = .green
        }
    }
    
    public override var shouldAutorotate: Bool {
        return true
    }
}
