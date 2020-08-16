//
//  SwiftyCityPickerTestViewController.swift
//  SwiftTool
//
//  Created by liujun on 2020/5/16.
//  Copyright © 2020 galaxy. All rights reserved.
//

import UIKit
import SwiftyJSON

public class SwiftyCityPickerTestViewController: UIViewController {
    
    deinit {
        print("\(NSStringFromClass(self.classForCoder)) deinit")
    }
    
    private lazy var cityPickerButton: UIButton = {
        let cityPickerButton = UIButton(type: .system)
        cityPickerButton.setTitle("City Picker", for: .normal)
        cityPickerButton.setTitleColor(.white, for: .normal)
        cityPickerButton.backgroundColor = .gray
        cityPickerButton.addTarget(self, action: #selector(cityPickerAction), for: .touchUpInside)
        return cityPickerButton
    }()
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        let leftMargin: CGFloat = 50.0
        let width: CGFloat = UIScreen.main.bounds.width - leftMargin - leftMargin
        let height: CGFloat = 50.0
        
        self.cityPickerButton.frame = CGRect(x: leftMargin, y: 200.0, width: width, height: height)
        self.view.addSubview(self.cityPickerButton)
    }
}


extension SwiftyCityPickerTestViewController {
    @objc func cityPickerAction() {
        let type: SwiftyCityPickerType = .province_city_district
        
        let pickerView = SwiftyCityPickerView()
        pickerView.type = type
        
        let toolBar = pickerView.toolBar
        toolBar.cancelButton.setTitle("Cancel", for: .normal)
        toolBar.sureButton.setTitle("Done", for: .normal)
        
        pickerView.defaultSelectAreaNames = ["四川省", "绵阳市", "三台县"]
        
        pickerView.show { [weak pickerView] (selectIndexs) in
            print("selectIndexs:\(selectIndexs)")
            guard let pickerView = pickerView else { return }
            guard let currentSelectModel = pickerView.currentSelectModel else { return }
            
            
            switch type {
            case .province_city_district:
                //let firstIndex = selectIndexs[0]
                let secondIndex = selectIndexs[1]
                let thirdIndex = selectIndexs[2]
                
                let province = currentSelectModel.areaName
                
                let cityModel = currentSelectModel.nexts[secondIndex]
                let city = cityModel.areaName
                
                let districtModel = cityModel.nexts[thirdIndex]
                let district = districtModel.areaName
                
                print("\(province) - \(city) - \(district)")
            case .province_city:
                //let firstIndex = selectIndexs[0]
                let secondIndex = selectIndexs[1]
                
                let province = currentSelectModel.areaName
                
                let cityModel = currentSelectModel.nexts[secondIndex]
                let city = cityModel.areaName
                
                print("\(province) - \(city)")
            case .province:
                //let firstIndex = selectIndexs[0]
                
                let province = currentSelectModel.areaName
                
                print("\(province)")
            }  
        }
    }
}
