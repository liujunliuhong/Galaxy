//
//  SwiftyCityPickerView.swift
//  SwiftTool
//
//  Created by liujun on 2020/5/16.
//  Copyright © 2020 yinhe. All rights reserved.
//

import UIKit
import SwiftyJSON

public func SwiftyCityPickerLoadCityData(closure: ((Bool, Any?)->())?) {
    DispatchQueue.global().async {
        guard let path = Bundle(for: SwiftyCityPickerView.classForCoder()).path(forResource: "SwiftyCity", ofType: "bundle") else {
            DispatchQueue.main.async {
                closure?(false, nil)
            }
            return
        }
        guard let bundle = Bundle(path: path) else {
            DispatchQueue.main.async {
                closure?(false, nil)
            }
            return
        }
        guard let cityPath = bundle.path(forResource: "city", ofType: "json") else {
            DispatchQueue.main.async {
                closure?(false, nil)
            }
            return
        }
        let fileURLWithPath = URL(fileURLWithPath: cityPath)
        
        guard let cityData = try? Data(contentsOf: fileURLWithPath) else {
            DispatchQueue.main.async {
                closure?(false, nil)
            }
            return
        }
        
        guard let cityDatas = try? JSONSerialization.jsonObject(with: cityData, options: .mutableContainers) else {
            DispatchQueue.main.async {
                closure?(false, nil)
            }
            return
        }
        DispatchQueue.main.async {
            closure?(true, cityDatas)
        }
    }
}


public enum SwiftyCityPickerType {
    case province_city_district
    case province_city
    case province
}



/// ⚠️pod 'SwiftyJSON'
/// ⚠️dependency 'Picker'
class SwiftyCityPickerView: SwiftyPickerView {
    
    /// type
    public var type: SwiftyCityPickerType = .province_city_district
    
    /// default select area names
    public var defaultSelectAreaNames: [String]?
    
    /// default select area ids
    public var defaultSelectAreaIds: [String]?
    
    /// city models
    public private(set) var cityModels: [SwiftyCityModel] = []
    
    /// current select model
    public private(set) var currentSelectModel: SwiftyCityModel?
    
    /// loading view
    public lazy var loadingView: UIActivityIndicatorView = {
        let loadingView = UIActivityIndicatorView(style: .gray)
        loadingView.hidesWhenStopped = true
        return loadingView
    }()
}


extension SwiftyCityPickerView {
    @discardableResult override func show(doneClosure: SwiftyPickerDoneClosure?) -> Bool {
        super.show(doneClosure: doneClosure)
        
        self.pickerView.isHidden = true
        self.toolBar.isHidden = true
        
        self.addSubview(self.loadingView)
        self.loadingView.frame = self.bounds
        self.loadingView.startAnimating()
        
        SwiftyCityPickerLoadCityData { [weak self] (isSuccess, cityData) in
            guard let self = self else { return }
            //
            self.loadingView.stopAnimating()
            //
            if let datas = cityData as? [[String: Any]], isSuccess {
                //
                self.pickerView.isHidden = false
                self.toolBar.isHidden = false
                //
                self.handleDatasource(dataSource: datas)
            } else {
                self.pickerView.isHidden = true
                self.toolBar.isHidden = true
                self.dismiss()
            }
        }
        return true
    }
    
    override func dismiss() {
        super.dismiss()
        self.loadingView.removeFromSuperview()
        self.cityModels.removeAll()
    }
}


extension SwiftyCityPickerView {
    private func handleDatasource(dataSource: [[String: Any]]) {
        self.cityModels.removeAll()
        //
        let ary = JSON(dataSource).arrayValue
        ary.forEach { (d) in
            let model = SwiftyCityModel(with: d)
            self.cityModels.append(model)
        }
        //
        var defaultFirstSelectedIndex: Int = 0
        var defaultSecondSelectedIndex: Int = 0
        var defaultThirdSelectedIndex: Int = 0
        //
        if let defaultSelectAreaNames = self.defaultSelectAreaNames {
            switch self.type {
            case .province_city_district:
                if defaultSelectAreaNames.count == 3 {
                    for (i, m1) in self.cityModels.enumerated() {
                        if m1.areaName == defaultSelectAreaNames[0] {
                            defaultFirstSelectedIndex = i
                            for (j, m2) in m1.nexts.enumerated() {
                                if m2.areaName == defaultSelectAreaNames[1] {
                                    defaultSecondSelectedIndex = j
                                    for (k, m3) in m2.nexts.enumerated() {
                                        if m3.areaName == defaultSelectAreaNames[2] {
                                            defaultThirdSelectedIndex = k
                                            break
                                        }
                                    }
                                    break
                                }
                            }
                            break
                        }
                    }
                }
            case .province_city:
                if defaultSelectAreaNames.count == 2 {
                    for (i, m1) in self.cityModels.enumerated() {
                        if m1.areaName == defaultSelectAreaNames[0] {
                            defaultFirstSelectedIndex = i
                            for (j, m2) in m1.nexts.enumerated() {
                                if m2.areaName == defaultSelectAreaNames[1] {
                                    defaultSecondSelectedIndex = j
                                    break
                                }
                            }
                            break
                        }
                    }
                }
            case .province:
                if defaultSelectAreaNames.count == 1 {
                    for (i, m1) in self.cityModels.enumerated() {
                        if m1.areaName == defaultSelectAreaNames[0] {
                            defaultFirstSelectedIndex = i
                            break
                        }
                    }
                }
            }
        } else if let defaultSelectAreaIds = self.defaultSelectAreaIds {
            switch self.type {
            case .province_city_district:
                if defaultSelectAreaIds.count == 3 {
                    for (i, m1) in self.cityModels.enumerated() {
                        if m1.areaId == defaultSelectAreaIds[0] {
                            defaultFirstSelectedIndex = i
                            for (j, m2) in m1.nexts.enumerated() {
                                if m2.areaId == defaultSelectAreaIds[1] {
                                    defaultSecondSelectedIndex = j
                                    for (k, m3) in m2.nexts.enumerated() {
                                        if m3.areaId == defaultSelectAreaIds[2] {
                                            defaultThirdSelectedIndex = k
                                            break
                                        }
                                    }
                                    break
                                }
                            }
                            break
                        }
                    }
                }
            case .province_city:
                if defaultSelectAreaIds.count == 2 {
                    for (i, m1) in self.cityModels.enumerated() {
                        if m1.areaId == defaultSelectAreaIds[0] {
                            defaultFirstSelectedIndex = i
                            for (j, m2) in m1.nexts.enumerated() {
                                if m2.areaId == defaultSelectAreaIds[1] {
                                    defaultSecondSelectedIndex = j
                                    break
                                }
                            }
                            break
                        }
                    }
                }
            case .province:
                if defaultSelectAreaIds.count == 1 {
                    for (i, m1) in self.cityModels.enumerated() {
                        if m1.areaId == defaultSelectAreaIds[0] {
                            defaultFirstSelectedIndex = i
                            break
                        }
                    }
                }
            }
        }
        
        self.currentSelectModel = self.cityModels[defaultFirstSelectedIndex]
        let firstTitles = self.cityModels.map{ "\($0.areaName)" }
        
        let secondModels = self.currentSelectModel?.nexts ?? []
        let secondTitles = secondModels.map{ "\($0.areaName)" }
        
        let thirdModels = secondModels[defaultSecondSelectedIndex].nexts
        let thirdTitles = thirdModels.map{ "\($0.areaName)" }
        
        switch self.type {
        case .province_city_district:
            self.titlesForComponents = [firstTitles, secondTitles, thirdTitles]
            self.reloadAllComponents()
            self.selectRow(defaultFirstSelectedIndex, inComponent: 0, animated: true)
            self.selectRow(defaultSecondSelectedIndex, inComponent: 1, animated: true)
            self.selectRow(defaultThirdSelectedIndex, inComponent: 2, animated: true)
            self.reloadAllComponents()
        case .province_city:
            self.titlesForComponents = [firstTitles, secondTitles]
            self.reloadAllComponents()
            self.selectRow(defaultFirstSelectedIndex, inComponent: 0, animated: true)
            self.selectRow(defaultSecondSelectedIndex, inComponent: 1, animated: true)
            self.reloadAllComponents()
        case .province:
            self.titlesForComponents = [firstTitles]
            self.reloadAllComponents()
            self.selectRow(defaultFirstSelectedIndex, inComponent: 0, animated: true)
            self.reloadAllComponents()
        }
        
        self.didSelectRowClosure = { [weak self] (component, row) in
            guard let self = self else { return }
            self.reloadWhenSelect(component: component, row: row)
        }
    }
    
    
    private func reloadWhenSelect(component: Int, row: Int) {
        switch self.type {
        case .province_city_district:
            switch component {
            case 0:
                self.currentSelectModel = self.cityModels[row]
                let secondModels = self.currentSelectModel?.nexts ?? []
                let secondTitles = secondModels.map{ "\($0.areaName)" }
                
                let thirdModels = secondModels.first?.nexts ?? []
                let thirdTitles = thirdModels.map{ "\($0.areaName)" }
                
                self.titlesForComponents?[1] = secondTitles
                self.titlesForComponents?[2] = thirdTitles
                self.selectRow(0, inComponent: 1, animated: true)
                self.selectRow(0, inComponent: 2, animated: true)
                self.reload(component: 1)
                self.reload(component: 2)
            case 1:
                let secondModel = self.currentSelectModel?.nexts[row]
                let thirdTitles = secondModel?.nexts.map{ "\($0.areaName)" }
                self.titlesForComponents?[2] = thirdTitles ?? []
                self.selectRow(0, inComponent: 2, animated: true)
                self.reload(component: 2)
            default:
                break
            }
        case .province_city:
            switch component {
            case 0:
                self.currentSelectModel = self.cityModels[row]
                let secondModels = self.currentSelectModel?.nexts ?? []
                let secondTitles = secondModels.map{ "\($0.areaName)" }
                
                self.titlesForComponents?[1] = secondTitles
                self.selectRow(0, inComponent: 1, animated: true)
                self.reload(component: 1)
            default:
                break
            }
        default:
            break
        }
    }
}
