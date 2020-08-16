//
//  SwiftyCusNavigationBarTestViewController.swift
//  SwiftTool
//
//  Created by apple on 2020/6/10.
//  Copyright © 2020 galaxy. All rights reserved.
//

import UIKit

public class SwiftyCusNavigationBarTestViewController: SwiftyBaseViewController {

    deinit {
        print("\(NSStringFromClass(self.classForCoder)) deinit")
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    let testImage: UIImage?
    init(testImage: UIImage?) {
        self.testImage = testImage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        
        let button = UIButton(type: .custom)
        button.setTitle("Button", for: .normal)
        button.backgroundColor = .cyan
        let item1 = SwiftyCusNavigationBarButtonItem()
        item1.layoutType = .auto
        item1.view = button
        
        let space1 = SwiftyCusNavigationBarSpace(space: 10.0)
        
        let imageView = UIImageView()
        imageView.image = self.testImage
        imageView.contentMode = .scaleAspectFit
        let item2 = SwiftyCusNavigationBarButtonItem()
        item2.layoutType = .auto
        item2.view = imageView
        
        
        let label = UILabel()
        label.text = "Title"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .orange
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        let titleView = SwiftyCusNavigationBarTitle()
        titleView.view = label
        titleView.layoutType = .fill
        
        
        let button4 = UIButton(type: .custom)
        button4.setTitle("44444444", for: .normal)
        button4.backgroundColor = .cyan
        let item3 = SwiftyCusNavigationBarButtonItem()
        item3.layoutType = .auto
        item3.view = button4
        
        let space2 = SwiftyCusNavigationBarSpace(space: 10.0)
        
        
        let label2 = UILabel()
        label2.text = "55"
        label2.font = UIFont.systemFont(ofSize: 20)
        label2.textColor = .orange
        label2.textAlignment = .center
        label2.adjustsFontSizeToFitWidth = true
        label2.backgroundColor = .red
        let item4 = SwiftyCusNavigationBarButtonItem()
        item4.layoutType = .auto
        item4.view = label2
        
        self.cusNaviBar.hideNavigationBar = false
        self.cusNaviBar.title = titleView
        //self.cusNaviBar.hideToolBar = false
        //self.cusNaviBar.toolHeight = 120
        self.cusNaviBar.toolView.backgroundColor = .purple
        self.cusNaviBar.leftItems = [item1, space1, item2]
        self.cusNaviBar.rightItems = [item3, item4, space2]
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
