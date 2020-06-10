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
        button.setTitle("11", for: .normal)
        button.backgroundColor = .cyan
        let item1 = SwiftyNavigationBarButtonItem(itemType: .button(button: button, layoutType: .auto))
        
        let item2 = SwiftyNavigationBarButtonItem(itemType: .space(space: 10))
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "item_Image_1")
        imageView.contentMode = .scaleAspectFit
        let item3 = SwiftyNavigationBarButtonItem(itemType: .imageView(imageView: imageView, layoutType: .auto))
        
        
        let titleType = SwiftyNavigationBarTitleType.title(title: "Title", font: UIFont.systemFont(ofSize: 20), color: .orange, adjustsFontSizeToFitWidth: true, layoutType: .auto)
        let title = SwiftyNavigationBarTitle(titleType: titleType)
        
        
        self.cusNaviBar.hideNavigationBar = false
        self.cusNaviBar.hideToolBar = false
        self.cusNaviBar.title = title
        self.cusNaviBar.toolHeight = 120
        self.cusNaviBar.toolView.backgroundColor = .purple
        self.cusNaviBar.leftItems = [item1, item2, item3]
        self.cusNaviBar.reload(origin: .zero, barWidth: UIDevice.YH_Width)
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            UIView.animate(withDuration: 1) {
                self.cusNaviBar.barHeight = 100
                self.cusNaviBar.reload(origin: .zero, barWidth: UIDevice.YH_Width)
            }
            
        }
        
    }
}
