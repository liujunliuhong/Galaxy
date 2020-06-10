//
//  SwiftyCusNavigationBarTestViewController.swift
//  SwiftTool
//
//  Created by apple on 2020/6/10.
//  Copyright © 2020 yinhe. All rights reserved.
//

import UIKit

public class SwiftyCusNavigationBarTestViewController: SwiftyBaseViewController {

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
        
        
        let button = UIButton(type: .custom)
        button.setTitle("Button", for: .normal)
        button.backgroundColor = .cyan
        let item1 = SwiftyNavigationBarButtonItem(itemType: .button(button: button, layoutType: .auto))
        
        let item2 = SwiftyNavigationBarButtonItem(itemType: .space(space: 10))
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "item_Image_1")
        imageView.contentMode = .scaleAspectFit
        let item3 = SwiftyNavigationBarButtonItem(itemType: .imageView(imageView: imageView, layoutType: .auto))
        
        
        let titleType = SwiftyNavigationBarTitleType.title(title: "Title", font: UIFont.systemFont(ofSize: 20), color: .orange, adjustsFontSizeToFitWidth: true, layoutType: .auto)
        let title = SwiftyNavigationBarTitle(titleType: titleType)
        
        
        let button4 = UIButton(type: .custom)
        button4.setTitle("44444444", for: .normal)
        button4.backgroundColor = .cyan
        let item4 = SwiftyNavigationBarButtonItem(itemType: .button(button: button4, layoutType: .auto))
        
        let item5 = SwiftyNavigationBarButtonItem(itemType: .space(space: 10))
        
        
        let label = UILabel()
        label.text = "55"
        label.backgroundColor = .red
        let item6 = SwiftyNavigationBarButtonItem(itemType: .customView(view: label, layoutType: .auto))
        
        self.cusNaviBar.hideNavigationBar = false
        self.cusNaviBar.title = title
        //self.cusNaviBar.hideToolBar = false
        //self.cusNaviBar.toolHeight = 120
        self.cusNaviBar.toolView.backgroundColor = .purple
        self.cusNaviBar.leftItems = [item1, item2, item3]
        self.cusNaviBar.rightItems = [item6, item5, item4]
        self.cusNaviBar.reload(origin: .zero, barWidth: UIDevice.YH_Width)
    }
}

extension SwiftyCusNavigationBarTestViewController {
    public override func initData() {
        super.initData()
    }
    
    public override func setupUI() {
        super.setupUI()
    }
    
    public override func bindViewModel() {
        super.bindViewModel()
    }
    
    public override func other() {
        super.other()
    }
}
