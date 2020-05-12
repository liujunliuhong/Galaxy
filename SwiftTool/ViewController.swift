//
//  ViewController.swift
//  SwiftTool
//
//  Created by apple on 2020/4/15.
//  Copyright © 2020 yinhe. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Demo"
        self.view.backgroundColor = .white
    }
}


extension ViewController {
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let vc = SwiftyMBHUDTestViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
