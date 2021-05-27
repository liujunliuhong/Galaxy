//
//  NextViewController.swift
//  SwiftTool
//
//  Created by galaxy on 2020/10/25.
//  Copyright © 2020 yinhe. All rights reserved.
//

import UIKit

class NextViewController: NavigationBarController {

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
        
        
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            
            self.gl.navigationBar?.defaultTitleLabel.text = "lala"
            
            let buttonItem = NavigationBarButtonItem.button(width: .auto, height: .auto) { [weak self] (button) in
                guard let self = self else { return }
                button.backgroundColor = .gray
                button.setTitle("返回", for: .normal)
                button.addTarget(self, action: #selector(self.backAction), for: .touchUpInside)
            }
            self.gl.navigationBar?.leftItems = [.fixedSpace(20), buttonItem]
            
//            let graidentLayer = CAGradientLayer()
//            graidentLayer.colors = [UIColor.red.cgColor, UIColor.orange.cgColor]
//            graidentLayer.startPoint = CGPoint(x: 0, y: 0)
//            graidentLayer.endPoint = CGPoint(x: 0, y: 1)
//            self.gl.navigationBar?.backgroundLayer = graidentLayer
//            
//            self.gl.navigationBar?.toolHeight = 50.0
//            self.gl.navigationBar?.hideToolBar = false
//            self.gl.navigationBar?.toolView.backgroundColor = UIColor.cyan.withAlphaComponent(0.5)
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    @objc func backAction() {
        self.navigationController?.gl.pop(to: nil, animated: true)
    }
}
