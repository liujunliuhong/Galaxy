//
//  SwiftyPickerTestViewController.swift
//  SwiftTool
//
//  Created by apple on 2020/5/13.
//  Copyright © 2020 yinhe. All rights reserved.
//

import UIKit
import SwiftyJSON

public class SwiftyPickerTestViewController: UIViewController {
    
    deinit {
        print("\(NSStringFromClass(self.classForCoder)) deinit")
    }
    
    private lazy var commonPickerButton: UIButton = {
        let commonPickerButton = UIButton(type: .system)
        commonPickerButton.setTitle("Common Picker", for: .normal)
        commonPickerButton.setTitleColor(.white, for: .normal)
        commonPickerButton.backgroundColor = .gray
        commonPickerButton.addTarget(self, action: #selector(commonPickerAction), for: .touchUpInside)
        return commonPickerButton
    }()
    
    private lazy var datePickerButton: UIButton = {
        let datePickerButton = UIButton(type: .system)
        datePickerButton.setTitle("Date Picker", for: .normal)
        datePickerButton.setTitleColor(.white, for: .normal)
        datePickerButton.backgroundColor = .gray
        datePickerButton.addTarget(self, action: #selector(datePickerAction), for: .touchUpInside)
        return datePickerButton
    }()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        let leftMargin: CGFloat = 50.0
        let width: CGFloat = UIScreen.main.bounds.width - leftMargin - leftMargin
        let height: CGFloat = 50.0
        
        
        self.commonPickerButton.frame = CGRect(x: leftMargin, y: 200.0, width: width, height: height)
        self.datePickerButton.frame = CGRect(x: leftMargin, y: self.commonPickerButton.frame.maxY + 50.0, width: width, height: height)
        self.view.addSubview(self.commonPickerButton)
        self.view.addSubview(self.datePickerButton)
        
        
        SwiftyCityPickerLoadCityData { (isSuccess, data) in
            print("\(isSuccess)")
            if let dataDic = data as? [[String: Any]] {
                //print("\(dataDic)")
                let ary = JSON(dataDic).arrayValue
                var models: [SwiftyCityModel] = []
                ary.forEach { (d) in
                    let model = SwiftyCityModel(with: d)
                    models.append(model)
                }
                
                
                models.forEach { (m) in
                    print(m.debugDescription)
                    print("\n")
                }
            }
        }
    }
}


extension SwiftyPickerTestViewController {
    @objc func commonPickerAction() {
        let pickerView = SwiftyPickerView()
        
        let toolBar = pickerView.toolBar
        toolBar.cancelButton.setTitle("Cancel", for: .normal)
        toolBar.sureButton.setTitle("Done", for: .normal)
        
        let titles: [[String]] = [["0 - 0",
                                   "0 - 1",
                                   "0 - 2",
                                   "0 - 3",
                                   "0 - 4",
                                   "0 - 5"],
                                  ["1 - 0",
                                   "1 - 1",
                                   "1 - 2",
                                   "1 - 3"]]
        pickerView.titlesForComponents = titles
        pickerView.setSelect(indexs: [1, 2], animation: true)
        pickerView.didSelectRowClosure = { [weak pickerView] (component, row) in
            if component == 0 {
                pickerView?.titlesForComponents?[1] = ["00", "11", "22", "33", "44", "55"]
                pickerView?.reload(component: 1)
                pickerView?.selectRow(0, inComponent: 1, animated: true)
            }
        }
        pickerView.show { (selectIndexs) in
            print("selectIndexs:\(selectIndexs)")
        }
    }
    
    @objc func datePickerAction() {
        let datePickerView = SwiftyDatePickerView()
        
        //datePickerView.toolBarHeight = 100.0
        
        
        let toolBar = datePickerView.toolBar
        toolBar.cancelButton.setTitle("Cancel", for: .normal)
        toolBar.sureButton.setTitle("Done", for: .normal)
        
        /*
         let toolBar = SwiftyPickerToolBar()
         toolBar.cancelButton.setTitle("Cancel", for: .normal)
         toolBar.sureButton.setTitle("Done", for: .normal)
         datePickerView.toolBar = toolBar
         */
        
        let datePicker = datePickerView.datePickerView
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        datePicker.minimumDate = Date(timeIntervalSinceNow: -7 * 24 * 60 * 60) // 7 days
        
        datePickerView.show { (selectDate) in
            print("selectDate:\(selectDate)")
        }
    }
}
