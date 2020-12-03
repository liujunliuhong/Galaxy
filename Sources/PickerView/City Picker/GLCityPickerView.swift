//
//  GLCityPickerView.swift
//  PickerView
//
//  Created by galaxy on 2020/10/25.
//

import UIKit

public func GLCityPickerLoadCityData(closure: ((Bool, Any?)->())?) {
    DispatchQueue.global().async {
        guard let path = Bundle(for: GLCityPickerView.classForCoder()).path(forResource: "GLCity", ofType: "bundle") else {
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


public enum GLCityPickerType {
    case province_city_district  // 省、市、区
    case province_city           // 省、市
    case province                // 省
}

fileprivate struct _SelectionLocation {
    let firstSelectedIndex: Int
    let secondSelectedIndex: Int
    let thirdSelectedIndex: Int
}


public class GLCityPickerView: GLPickerView {
    
    /// 选择类型
    public var cityPickerType: GLCityPickerType = .province_city_district
    
    /// 默认选中的地区名字集合
    public var defaultSelectAreaNames: [String]?
    
    /// 默认选中的地区ID集合
    public var defaultSelectAreaIds: [String]?
    
    /// 数据源
    public private(set) var cityModels: [GLCityModel] = []
    
    /// 当前选中Model
    public private(set) var currentSelectModel: GLCityModel?
    
    /// DEBUG模式下是否开启日志打印
    public var enableDebugLog: Bool = false
    
    private var beforeSelectIndexs: [Int] = []
    
    /// loading view
    public private(set) lazy var loadingView: UIActivityIndicatorView = {
        let loadingView = UIActivityIndicatorView(style: .gray)
        loadingView.hidesWhenStopped = true
        return loadingView
    }()
}


extension GLCityPickerView {
    public override func show(doneClosure: GLPickerDoneClosure?) {
        super.show(doneClosure: doneClosure)
        
        self.pickerView.isHidden = true
        self.toolBar?.isHidden = true
        
        self.addSubview(self.loadingView)
        self.loadingView.frame = self.bounds
        self.loadingView.startAnimating()
        
        
        GLCityPickerLoadCityData { [weak self] (isSuccess, cityData) in
            guard let self = self else { return }
            //
            self.loadingView.stopAnimating()
            //
            if let datas = cityData as? [[String: Any]], isSuccess {
                //
                self.pickerView.isHidden = false
                self.toolBar?.isHidden = false
                //
                self.handleDatasource(dataSource: datas)
            } else {
                self.pickerView.isHidden = true
                self.toolBar?.isHidden = true
                self.dismiss()
            }
        }
    }
    
    public override func dismiss() {
        super.dismiss()
        self.loadingView.removeFromSuperview()
        self.cityModels.removeAll()
    }
}


extension GLCityPickerView {
    private func handleDatasource(dataSource: [[String: Any]]) {
        self.cityModels.removeAll()
        //
        dataSource.forEach { (d) in
            let model = GLCityModel(with: d)
            self.cityModels.append(model)
        }
        if self.enableDebugLog {
            self.printCityData()
        }
        //
        let location = self.check()
        self.currentSelectModel = self.cityModels[location.firstSelectedIndex]
        let firstTitles = self.cityModels.map{ "\($0.areaName)" }
        
        let secondModels = self.currentSelectModel?.nexts ?? []
        let secondTitles = secondModels.map{ "\($0.areaName)" }
        
        let thirdModels = secondModels[location.secondSelectedIndex].nexts
        let thirdTitles = thirdModels.map{ "\($0.areaName)" }
        
        switch self.cityPickerType {
            case .province_city_district:
                self.titlesForComponents = [firstTitles, secondTitles, thirdTitles]
                self.reloadAllComponents()
                self.selectRow(location.firstSelectedIndex, inComponent: 0, animated: true)
                self.selectRow(location.secondSelectedIndex, inComponent: 1, animated: true)
                self.selectRow(location.thirdSelectedIndex, inComponent: 2, animated: true)
                self.reloadAllComponents()
                self.beforeSelectIndexs = [location.firstSelectedIndex, location.secondSelectedIndex, location.thirdSelectedIndex]
            case .province_city:
                self.titlesForComponents = [firstTitles, secondTitles]
                self.reloadAllComponents()
                self.selectRow(location.firstSelectedIndex, inComponent: 0, animated: true)
                self.selectRow(location.secondSelectedIndex, inComponent: 1, animated: true)
                self.reloadAllComponents()
                self.beforeSelectIndexs = [location.firstSelectedIndex, location.secondSelectedIndex]
            case .province:
                self.titlesForComponents = [firstTitles]
                self.reloadAllComponents()
                self.selectRow(location.firstSelectedIndex, inComponent: 0, animated: true)
                self.reloadAllComponents()
                self.beforeSelectIndexs = [location.firstSelectedIndex]
        }
        
        self.didSelectRowClosure = { [weak self] (component, row) in
            guard let self = self else { return }
            
            if self.beforeSelectIndexs[component] == row {
                return
            }
            self.beforeSelectIndexs[component] = row
            
            self.reloadWhenSelect(component: component, row: row)
        }
    }
    
    
    private func reloadWhenSelect(component: Int, row: Int) {
        switch self.cityPickerType {
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
    
    private func check() -> _SelectionLocation {
        var defaultFirstSelectedIndex: Int = 0
        var defaultSecondSelectedIndex: Int = 0
        var defaultThirdSelectedIndex: Int = 0
        //
        if let defaultSelectAreaNames = self.defaultSelectAreaNames {
            switch self.cityPickerType {
                case .province_city_district:
                    if defaultSelectAreaNames.count != 3 {
                        return _SelectionLocation(firstSelectedIndex: defaultFirstSelectedIndex, secondSelectedIndex: defaultSecondSelectedIndex, thirdSelectedIndex: defaultThirdSelectedIndex)
                    }
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
                case .province_city:
                    if defaultSelectAreaNames.count != 2 {
                        return _SelectionLocation(firstSelectedIndex: defaultFirstSelectedIndex, secondSelectedIndex: defaultSecondSelectedIndex, thirdSelectedIndex: defaultThirdSelectedIndex)
                    }
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
                    
                case .province:
                    if defaultSelectAreaNames.count != 1 {
                        return _SelectionLocation(firstSelectedIndex: defaultFirstSelectedIndex, secondSelectedIndex: defaultSecondSelectedIndex, thirdSelectedIndex: defaultThirdSelectedIndex)
                    }
                    for (i, m1) in self.cityModels.enumerated() {
                        if m1.areaName == defaultSelectAreaNames[0] {
                            defaultFirstSelectedIndex = i
                            break
                        }
                    }
            }
        } else if let defaultSelectAreaIds = self.defaultSelectAreaIds {
            switch self.cityPickerType {
                case .province_city_district:
                    if defaultSelectAreaIds.count != 3 {
                        return _SelectionLocation(firstSelectedIndex: defaultFirstSelectedIndex, secondSelectedIndex: defaultSecondSelectedIndex, thirdSelectedIndex: defaultThirdSelectedIndex)
                    }
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
                    
                case .province_city:
                    if defaultSelectAreaIds.count != 2 {
                        return _SelectionLocation(firstSelectedIndex: defaultFirstSelectedIndex, secondSelectedIndex: defaultSecondSelectedIndex, thirdSelectedIndex: defaultThirdSelectedIndex)
                    }
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
                case .province:
                    if defaultSelectAreaIds.count != 1 {
                        return _SelectionLocation(firstSelectedIndex: defaultFirstSelectedIndex, secondSelectedIndex: defaultSecondSelectedIndex, thirdSelectedIndex: defaultThirdSelectedIndex)
                    }
                    for (i, m1) in self.cityModels.enumerated() {
                        if m1.areaId == defaultSelectAreaIds[0] {
                            defaultFirstSelectedIndex = i
                            break
                        }
                    }
            }
        }
        return _SelectionLocation(firstSelectedIndex: defaultFirstSelectedIndex, secondSelectedIndex: defaultSecondSelectedIndex, thirdSelectedIndex: defaultThirdSelectedIndex)
    }
    
    private func printCityData() {
        var infos: [[String: Any]] = []
        for (_, model) in self.cityModels.enumerated() {
            infos.append(model.info())
        }
        let objct = NSString(format: "%@", infos as NSArray)
        print("\(objct)")
    }
}



/*
 let cityPickerView = GLCityPickerView()
 cityPickerView.enableDebugLog = true
 cityPickerView.cityPickerType = .province_city_district
 cityPickerView.show { [weak cityPickerView] (selectIndexs) in
     print("selectIndexs:\(selectIndexs)")
     guard let cityPickerView = cityPickerView else { return }
     guard let currentSelectModel = cityPickerView.currentSelectModel else { return }
     switch cityPickerView.cityPickerType {
         case .province_city_district:
             let secondIndex = selectIndexs[1]
             let thirdIndex = selectIndexs[2]
             
             let province = currentSelectModel.areaName
             
             let cityModel = currentSelectModel.nexts[secondIndex]
             let city = cityModel.areaName
             
             let districtModel = cityModel.nexts[thirdIndex]
             let district = districtModel.areaName
             
             print("\(province) - \(city) - \(district)")
         case .province_city:
             let secondIndex = selectIndexs[1]
             
             let province = currentSelectModel.areaName
             
             let cityModel = currentSelectModel.nexts[secondIndex]
             let city = cityModel.areaName
             
             print("\(province) - \(city)")
         case .province:
             let province = currentSelectModel.areaName
             
             print("\(province)")
     }
 }
 */
