//
//  SwiftyWordsSortTestViewController.swift
//  SwiftTool
//
//  Created by apple on 2020/5/14.
//  Copyright © 2020 yinhe. All rights reserved.
//

import UIKit

fileprivate struct Model {
    let title: String
    init(title: String) {
        self.title = title
    }
}

class SwiftyWordsSortTestViewController: UIViewController {
    deinit {
        print("\(NSStringFromClass(self.classForCoder)) deinit")
    }
    
    private lazy var modelsSortButton: UIButton = {
        let modelsSortButton = UIButton(type: .system)
        modelsSortButton.setTitle("Models Sort", for: .normal)
        modelsSortButton.setTitleColor(.white, for: .normal)
        modelsSortButton.backgroundColor = .gray
        modelsSortButton.addTarget(self, action: #selector(modelsSort), for: .touchUpInside)
        return modelsSortButton
    }()
    
    private lazy var stringsSortButton: UIButton = {
        let stringsSortButton = UIButton(type: .system)
        stringsSortButton.setTitle("Strings Sort", for: .normal)
        stringsSortButton.setTitleColor(.white, for: .normal)
        stringsSortButton.backgroundColor = .gray
        stringsSortButton.addTarget(self, action: #selector(stringsSort), for: .touchUpInside)
        return stringsSortButton
    }()
    
    private var modelsDataSource: [Model] = []
    private var stringsDataSource: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        let leftMargin: CGFloat = 50.0
        let width: CGFloat = UIScreen.main.bounds.width - leftMargin - leftMargin
        let height: CGFloat = 50.0
        
        
        self.modelsSortButton.frame = CGRect(x: leftMargin, y: 200.0, width: width, height: height)
        self.stringsSortButton.frame = CGRect(x: leftMargin, y: self.modelsSortButton.frame.maxY + 50.0, width: width, height: height)
        self.view.addSubview(self.modelsSortButton)
        self.view.addSubview(self.stringsSortButton)
        
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
        
        
        self.modelsDataSource = [model1,
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
        
        self.stringsDataSource = self.modelsDataSource.map{ $0.title }
        
    }
}

extension SwiftyWordsSortTestViewController {
    @objc private func modelsSort() {
        let sort = SwiftyWordsSort<Model>()
        sort.sort(models: self.modelsDataSource, keyPath: "title") { (results) in
            results.forEach { (result) in
                print("\n")
                print("key:\(result.key)")
                print("\(result.models.map{ $0.title })")
            }
        }
    }
    
    @objc private func stringsSort() {
        let sort = SwiftyWordsSort<String>()
        sort.sort(models: self.stringsDataSource, keyPath: nil) { (results) in
            results.forEach { (result) in
                print("\n")
                print("key:\(result.key)")
                print("\(result.models)")
            }
        }
    }
}
