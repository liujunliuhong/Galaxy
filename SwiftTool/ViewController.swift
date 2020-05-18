//
//  ViewController.swift
//  SwiftTool
//
//  Created by apple on 2020/4/15.
//  Copyright © 2020 yinhe. All rights reserved.
//

import UIKit

fileprivate class Model: NSObject {
    
}

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Demo"
        self.view.backgroundColor = .white
        
//
//
//        let sort = SwiftyWordsSort<Model>()
//        let result = SwiftyWordsSort.getFirstEnglishWords(string: " ,.,;'!@#$%^&*() 嘻嘻哈哈啦啦abc ")
//        print("\(result)")
    }
}


extension ViewController {
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let vc = SwiftyTagContainerTestViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
