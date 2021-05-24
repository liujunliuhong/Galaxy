//
//  CityPickerView.swift
//  SwiftTool
//
//  Created by liujun on 2021/5/24.
//  Copyright © 2021 yinhe. All rights reserved.
//

import Foundation
import UIKit

fileprivate struct _SelectionLocation {
    let firstSelectedIndex: Int
    let secondSelectedIndex: Int
    let thirdSelectedIndex: Int
}

public final class CityPickerView: UIView {
    deinit {
        removeNotification()
        #if DEBUG
        print("\(NSStringFromClass(self.classForCoder)) deinit")
        #endif
    }
    
    public enum PickerType {
        case province_city_district  /// 省、市、区
        case province_city           /// 省、市
        case province                /// 省
    }
    
    /// 选择类型
    public var cityPickerType: CityPickerView.PickerType = .province_city_district
    
    /// 默认选中的地区名字集合
    public var defaultSelectAreaNames: [String]?
    
    /// 默认选中的地区`ID`集合
    public var defaultSelectAreaIds: [String]?
    
    /// 数据源
    public private(set) var cityModels: [CityModel] = []
    
    /// 当前选中`Model`
    public private(set) var currentSelectModel: CityModel?
    
    /// DEBUG模式下是否开启日志打印
    public var enableDebugLog: Bool = false
    
    /// 数据源
    ///
    /// 数据源的设置要在其他属性设置的最前面
    public var titlesForComponents: [[String]]?
    
    /// 文本颜色
    ///
    /// 当`titlesForComponents`不为空时，有效
    public var titleColor: UIColor = .black
    
    /// 文本字体
    ///
    /// 当`titlesForComponents`不为空时，有效
    public var titleFont: UIFont = UIFont.boldSystemFont(ofSize: 17)
    
    /// 分割线颜色
    ///
    /// `iOS 14`之后，`UIPickerView`没有分割线了，取而代之的是显示在中间的一个选中背景`view`
    public var separatorLineColor: UIColor = UIColor.gray.withAlphaComponent(0.4) {
        didSet {
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    /// `toolBar`
    ///
    /// 可以传入自定义的`view`，当为`nil`时，将使用`defaultToolBar`
    public var toolBar: UIView?
    
    /// 框架默认的`toolBar`
    public private(set) lazy var defaultToolBar: PickerToolBar = {
        let toolBar = PickerToolBar()
        return toolBar
    }()
    
    /// 工具栏高度
    public var toolBarHeight: CGFloat = 49.0 {
        didSet {
            invalidateIntrinsicContentSize()
            AlertEngine.default.refresh()
        }
    }
    
    private lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        return pickerView
    }()
    
    /// `UIPickerView`实时变化的回调
    private var currentSelectRowClosure: (([Int])->())? {
        didSet {
            self.currentSelectRowClosure?(self.currentSelectIndexs)
        }
    }
    
    /// 手动触发`UIPickerView`滚动结束停止后的回调
    public var didSelectRowClosure: ((Int, Int)->())?
    
    
    private var doneClosure: (([Int])->())?
    private var currentSelectIndexs: [Int] = []
    
    private var beforeSelectIndexs: [Int] = []
    
    public init() {
        super.init(frame: .zero)
        addNotification()
        setupUI()
        addAction()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        addNotification()
        setupUI()
        addAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        if #available(iOS 13.4, *) {
            //
        } else {
            self.pickerView.subviews.forEach { (view) in
                if view.isKind(of: UIPickerView.classForCoder()) {
                    view.subviews.forEach({ (view1) in
                        if view1.frame.height.isLessThanOrEqualTo(1.0) {
                            view1.backgroundColor = self.separatorLineColor
                        }
                    })
                }
            }
        }
    }
    
    public override var intrinsicContentSize: CGSize {
        self.pickerView.sizeToFit()
        let height = self.toolBarHeight + self.pickerView.bounds.height
        
        return CGSize(width: GL.deviceWidth, height: height)
    }
}

extension CityPickerView {
    private func setupUI() {
        backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1) // 白色
        if let toolBar = toolBar {
            addSubview(toolBar)
            addSubview(pickerView)
            toolBar.snp.makeConstraints { make in
                make.left.top.right.equalToSuperview()
                make.height.equalTo(toolBarHeight)
            }
            pickerView.snp.makeConstraints { make in
                make.left.right.equalTo(toolBar)
                make.bottom.equalToSuperview()
                make.top.equalTo(toolBar.snp.bottom)
            }
        } else {
            addSubview(defaultToolBar)
            addSubview(pickerView)
            defaultToolBar.snp.makeConstraints { make in
                make.left.top.equalToSuperview()
                make.width.equalTo(GL.deviceWidth)
                make.height.equalTo(toolBarHeight)
            }
            pickerView.snp.makeConstraints { make in
                make.left.right.equalTo(defaultToolBar)
                make.bottom.equalToSuperview()
                make.top.equalTo(defaultToolBar.snp.bottom)
            }
        }
    }
    
    private func addAction() {
        self.defaultToolBar.cancelButton.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        self.defaultToolBar.sureButton.addTarget(self, action: #selector(sureAction), for: .touchUpInside)
    }
    
    private func handleDatasource(dataSource: [[String: Any]]) {
        self.cityModels.removeAll()
        //
        dataSource.forEach { (d) in
            let model = CityModel(with: d)
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
                self.currentSelectIndexs = [0, 0, 0]
                self.reloadAllComponents()
                self.selectRow(location.firstSelectedIndex, inComponent: 0, animated: true)
                self.selectRow(location.secondSelectedIndex, inComponent: 1, animated: true)
                self.selectRow(location.thirdSelectedIndex, inComponent: 2, animated: true)
                self.reloadAllComponents()
                self.beforeSelectIndexs = [location.firstSelectedIndex, location.secondSelectedIndex, location.thirdSelectedIndex]
            case .province_city:
                self.titlesForComponents = [firstTitles, secondTitles]
                self.currentSelectIndexs = [0, 0]
                self.reloadAllComponents()
                self.selectRow(location.firstSelectedIndex, inComponent: 0, animated: true)
                self.selectRow(location.secondSelectedIndex, inComponent: 1, animated: true)
                self.reloadAllComponents()
                self.beforeSelectIndexs = [location.firstSelectedIndex, location.secondSelectedIndex]
            case .province:
                self.titlesForComponents = [firstTitles]
                self.currentSelectIndexs = [0]
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
    
    private func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(orientationDidChange), name: UIApplication.didChangeStatusBarOrientationNotification, object: nil)
    }
    
    private func removeNotification() {
        NotificationCenter.default.removeObserver(self, name: UIApplication.didChangeStatusBarOrientationNotification, object: nil)
    }
    
    private func update() {
        if let toolBar = toolBar {
            toolBar.snp.remakeConstraints { make in
                make.left.top.equalToSuperview()
                make.width.equalTo(GL.deviceWidth)
                make.height.equalTo(toolBarHeight)
            }
            pickerView.snp.remakeConstraints { make in
                make.left.right.equalTo(toolBar)
                make.bottom.equalToSuperview()
                make.top.equalTo(toolBar.snp.bottom)
            }
        } else {
            defaultToolBar.snp.remakeConstraints { make in
                make.left.top.equalToSuperview()
                make.width.equalTo(GL.deviceWidth)
                make.height.equalTo(toolBarHeight)
            }
            pickerView.snp.remakeConstraints { make in
                make.left.right.equalTo(defaultToolBar)
                make.bottom.equalToSuperview()
                make.top.equalTo(defaultToolBar.snp.bottom)
            }
        }
    }
    
    private func getResult() {
        var results: [Int] = []
        for component in 0..<self.pickerView.numberOfComponents {
            let selectRow = self.pickerView.selectedRow(inComponent: component)
            results.append(selectRow)
        }
        self.currentSelectIndexs = results
        self.currentSelectRowClosure?(self.currentSelectIndexs)
        self.doneClosure?(results)
    }
}

extension CityPickerView {
    /// 显示城市选择器
    ///
    ///     let cityPickerView = CityPickerView()
    ///     cityPickerView.enableDebugLog = true
    ///     cityPickerView.cityPickerType = .province_city_district
    ///     cityPickerView.defaultSelectAreaNames = ["四川省", "成都市", "双流县"]
    ///     cityPickerView.show { [weak cityPickerView] selectIndexs in
    ///         print("selectIndexs:\(selectIndexs)")
    ///         guard let cityPickerView = cityPickerView else { return }
    ///         guard let currentSelectModel = cityPickerView.currentSelectModel else { return }
    ///         switch cityPickerView.cityPickerType {
    ///             case .province_city_district:
    ///                 let secondIndex = selectIndexs[1]
    ///                 let thirdIndex = selectIndexs[2]
    ///                 let province = currentSelectModel.areaName
    ///                 let cityModel = currentSelectModel.nexts[secondIndex]
    ///                 let city = cityModel.areaName
    ///                 let districtModel = cityModel.nexts[thirdIndex]
    ///                 let district = districtModel.areaName
    ///                 print("\(province) - \(city) - \(district)")
    ///             case .province_city:
    ///                 let secondIndex = selectIndexs[1]
    ///                 let province = currentSelectModel.areaName
    ///                 let cityModel = currentSelectModel.nexts[secondIndex]
    ///                 let city = cityModel.areaName
    ///                 print("\(province) - \(city)")
    ///             case .province:
    ///                 let province = currentSelectModel.areaName
    ///                 print("\(province)")
    ///         }
    ///     } currentSelectRowClosure: { indexes in
    ///         print("indexes: \(indexes)")
    ///     }
    public func show(doneClosure: (([Int])->())?, currentSelectRowClosure: (([Int])->())? = nil) {
        guard let window = UIApplication.shared.keyWindow else { return }
        //
        guard let datas = CityData.gl.jsonDecode as? [[String: Any]] else { return }
        self.handleDatasource(dataSource: datas)
        //
        self.doneClosure = doneClosure
        self.currentSelectRowClosure = currentSelectRowClosure
        //
        let options = AlertEngine.Options()
        options.fromPosition = .bottomCenter(top: .zero)
        options.toPosition = .bottomCenter(bottom: .zero)
        options.dismissPosition = .bottomCenter(top: .zero)
        options.translucentColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0).withAlphaComponent(0.4)
        //
        AlertEngine.default.show(parentView: window, alertView: self, options: options)
    }
}

extension CityPickerView {
    @objc private func sureAction() {
        getResult()
        AlertEngine.default.dismiss()
    }
    
    @objc private func cancelAction() {
        AlertEngine.default.dismiss()
    }
    
    @objc private func orientationDidChange() {
        invalidateIntrinsicContentSize()
        update()
    }
}

extension CityPickerView {
    /// 刷新所有列
    public func reloadAllComponents() {
        pickerView.reloadAllComponents()
    }
    
    /// 刷新某一列
    public func reload(component: Int) {
        pickerView.reloadComponent(component)
    }
    
    /// 选中某一列的某一行
    ///
    /// 该方法不会执行`didSelectRow`方法。已经对`row`和`component`进行了纠错处理
    public func selectRow(_ row: Int, inComponent component: Int, animated: Bool) {
        var row = row
        var component = component
        if component < 0 {
            component = 0
        } else if let titlesForComponents = titlesForComponents,
                  component >= titlesForComponents.count {
            component = titlesForComponents.count - 1
        }
        
        if let titlesForComponents = titlesForComponents {
            let rows = titlesForComponents[component]
            if row < 0 {
                row = 0
            } else if row >= rows.count {
                row = rows.count - 1
            }
        }
        
        if titlesForComponents == nil {
            return
        }
        if let titlesForComponents = titlesForComponents,
           titlesForComponents.count <= 0 {
            return
        }
        
        pickerView.selectRow(row, inComponent: component, animated: animated)
        
        if let titlesForComponents = titlesForComponents {
            if currentSelectIndexs.count < titlesForComponents.count {
                return
            }
        }
        
        if component <= currentSelectIndexs.count {
            currentSelectIndexs[component] = row
        }
        self.currentSelectRowClosure?(currentSelectIndexs)
    }
}

extension CityPickerView: UIPickerViewDataSource, UIPickerViewDelegate {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if let titlesForComponents = self.titlesForComponents {
            return titlesForComponents.count
        }
        return 0
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if let titlesForComponents = self.titlesForComponents {
            return titlesForComponents[component].count
        }
        return 0
    }
    
    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        if let titlesForComponents = self.titlesForComponents {
            let title = titlesForComponents[component][row]
            label.textAlignment = .center
            label.textColor = self.titleColor
            label.font = self.titleFont
            label.text = title
            label.adjustsFontSizeToFitWidth = true
        }
        return label
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //print(" component:\(component) -- row: \(row)")
        if component <= self.currentSelectIndexs.count {
            self.currentSelectIndexs[component] = row
        }
        self.currentSelectRowClosure?(self.currentSelectIndexs)
        
        self.didSelectRowClosure?(component, row)
    }
}
