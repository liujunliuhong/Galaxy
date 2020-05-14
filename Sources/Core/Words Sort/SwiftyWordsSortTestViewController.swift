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
        
        let model1 = Model(title: "😭吃饭")
        let model2 = Model(title: "😲洗澡")
        let model3 = Model(title: "☁️aa")
        let model4 = Model(title: "asd")
        let model5 = Model(title: "fsdf")
        let model6 = Model(title: "ewr")
        let model7 = Model(title: "fcb")
        let model8 = Model(title: "嘻嘻")
        let model9 = Model(title: "啦啦")
        let model10 = Model(title: "来了")
        let model11 = Model(title: "bc")
        let model12 = Model(title: "空腹")
        let model13 = Model(title: "1312")
        let model14 = Model(title: "申诉")
        let model15 = Model(title: "eee")
        let model16 = Model(title: "喷狗")
        let model17 = Model(title: "adas")
        let model18 = Model(title: "朝阳")
        let model19 = Model(title: "朝向")
        
        
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
                                   model12,
                                   model13,
                                   model14,
                                   model15,
                                   model16,
                                   model17,
                                   model18,
                                   model19]
        let sort = SwiftyWordsSort<Model>()
        sort.sort(models: dataSource, keyPath: "title") { (results) in
            results.forEach { (result) in
                print("\n")
                print("key:\(result.key)")
                print("\(result.models.map{ $0.title })")
            }
        }
    }
}
