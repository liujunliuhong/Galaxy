//
//  GLWordsSortDemoViewController.swift
//  SwiftTool
//
//  Created by galaxy on 2020/10/20.
//  Copyright © 2020 yinhe. All rights reserved.
//

import UIKit


fileprivate struct Model {
    let title: String
    init(title: String) {
        self.title = title
    }
}

public class GLWordsSortDemoViewController: UIViewController {
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
    
    private lazy var errorSortButton1: UIButton = {
        let errorSortButton1 = UIButton(type: .system)
        errorSortButton1.setTitle("Error Sort 1", for: .normal)
        errorSortButton1.setTitleColor(.white, for: .normal)
        errorSortButton1.backgroundColor = .gray
        errorSortButton1.addTarget(self, action: #selector(errorSort1), for: .touchUpInside)
        return errorSortButton1
    }()
    
    private lazy var errorSortButton2: UIButton = {
        let errorSortButton2 = UIButton(type: .system)
        errorSortButton2.setTitle("Error Sort 2", for: .normal)
        errorSortButton2.setTitleColor(.white, for: .normal)
        errorSortButton2.backgroundColor = .gray
        errorSortButton2.addTarget(self, action: #selector(errorSort1), for: .touchUpInside)
        return errorSortButton2
    }()
    
    private var modelsDataSource: [Model] = []
    private var stringsDataSource: [String] = []
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        let leftMargin: CGFloat = 50.0
        let width: CGFloat = UIScreen.main.bounds.width - leftMargin - leftMargin
        let height: CGFloat = 50.0
        
        
        self.modelsSortButton.frame = CGRect(x: leftMargin, y: 200.0, width: width, height: height)
        self.stringsSortButton.frame = CGRect(x: leftMargin, y: self.modelsSortButton.frame.maxY + 50.0, width: width, height: height)
        self.errorSortButton1.frame = CGRect(x: leftMargin, y: self.stringsSortButton.frame.maxY + 50.0, width: width, height: height)
        self.errorSortButton2.frame = CGRect(x: leftMargin, y: self.errorSortButton1.frame.maxY + 50.0, width: width, height: height)
        self.view.addSubview(self.modelsSortButton)
        self.view.addSubview(self.stringsSortButton)
        self.view.addSubview(self.errorSortButton1)
        self.view.addSubview(self.errorSortButton2)
        
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

extension GLWordsSortDemoViewController {
    @objc private func modelsSort() {
        let sort = GLWordsSort<Model>()
        sort.sort(models: self.modelsDataSource, keyPath: "title") { (results) in
            results.forEach { (result) in
                print("\n")
                print("key:\(result.key)")
                print("\(result.models.map{ $0.title })")
            }
        }
    }
    
    @objc private func stringsSort() {
        let sort = GLWordsSort<String>()
        sort.sort(models: self.stringsDataSource, keyPath: nil) { (results) in
            results.forEach { (result) in
                print("\n")
                print("key:\(result.key)")
                print("\(result.models)")
            }
        }
    }
    
    @objc private func errorSort1() {
        // models排序，但是keyPath错误
        let sort = GLWordsSort<Model>()
        sort.sort(models: self.modelsDataSource, keyPath: "title1234") { (results) in
            results.forEach { (result) in
                print("\n")
                print("key:\(result.key)")
                print("\(result.models.map{ $0.title })")
            }
        }
    }
    
    @objc private func errorSort2() {
        // 字符串数组排序，但是填写了keyPath
        let sort = GLWordsSort<String>()
        sort.sort(models: self.stringsDataSource, keyPath: "title") { (results) in
            results.forEach { (result) in
                print("\n")
                print("key:\(result.key)")
                print("\(result.models)")
            }
        }
    }
}
