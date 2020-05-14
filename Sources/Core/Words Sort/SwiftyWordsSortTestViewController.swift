//
//  SwiftyWordsSortTestViewController.swift
//  SwiftTool
//
//  Created by apple on 2020/5/14.
//  Copyright © 2020 yinhe. All rights reserved.
//

import UIKit

@objc fileprivate class Model: NSObject {
    @objc let title: String
    init(title: String) {
        self.title = title
        super.init()
    }
}

class SwiftyWordsSortTestViewController: UIViewController {
    
    private var dataSource: [[Model]] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        let model1 = Model(title: "😭")
        let model2 = Model(title: "haha")
        let model3 = Model(title: "lala")
        let model4 = Model(title: "asd")
        let model5 = Model(title: "fsdf")
        let model6 = Model(title: "ewr")
        let model7 = Model(title: "fcb")
        let model8 = Model(title: "dfs")
        let model9 = Model(title: "hgj")
        let model10 = Model(title: "sfsd")
        let model11 = Model(title: "bc")
        let model12 = Model(title: "/.,")
        
        
        let dataSource: [Model] = [model1,
                           model2,
                           model3,
                           model4,
                           model5,
                           model6,
                           model7,
                           model8,
                           model9,
                           model10,
                           model11,
                           model12]
        
//        let sort = YHChineseSort()
//        sort.sort(withModels: dataSource, key: "title", modelClass: Model.classForCoder()) { (list, sectionTitles) in
//            
//        }
    }
}
