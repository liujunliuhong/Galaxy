//
//  HeightPickerView.swift
//  Galaxy
//
//  Created by galaxy on 2022/11/26.
//

import UIKit
import SnapKit

public protocol HeightPickerViewDelegate: NSObjectProtocol {
    func pickerView(_ pickerView: HeightPickerView, didSelect height: Height)
}

public final class HeightPickerView: UIView, UITableViewDelegate {
    
    private lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    public var font: UIFont = .boldSystemFont(ofSize: 17) {
        didSet {
            updateAll()
        }
    }
    
    public var color: UIColor = .black {
        didSet {
            updateAll()
        }
    }
    
    public var showsFtComponents: Bool = true {
        didSet {
            updateAll()
        }
    }
    
    public weak var delegate: HeightPickerViewDelegate? {
        didSet {
            getCurrentResult()
        }
    }
    
    private let defaultWidth: CGFloat?
    private let defaultHeight: CGFloat?
    private let viewModel: HeightPickerViewModel
    
    public init(defaultWidth: CGFloat? = nil,
                defaultHeight: CGFloat? = nil,
                minimumHeight: Height,
                maximumHeight: Height) {
        self.defaultWidth = defaultWidth
        self.defaultHeight = defaultHeight
        self.viewModel = HeightPickerViewModel(minimumHeight: minimumHeight, maximumHeight: maximumHeight)
        super.init(frame: .zero)
        initUI()
        setupUI()
        bindViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HeightPickerView {
    private func initUI() {
        
    }
    
    private func setupUI() {
        addSubview(pickerView)
        pickerView.snp.makeConstraints { make in
            make.left.top.equalToSuperview()
            if self.defaultWidth != nil {
                make.width.equalTo(self.defaultWidth!)
            }
            if self.defaultHeight != nil {
                make.height.equalTo(self.defaultHeight!)
            }
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func bindViewModel() {
        updateAll()
        getCurrentResult()
    }
}

extension HeightPickerView {
    public func setDefault(cm: UInt64) {
        let height = Height(cm: cm)
        viewModel.updateCmSelected(height: height)
        viewModel.updateUnitSelected(unit: .cm)
        updateAll()
        getCurrentResult()
    }
    
    public func setDefault(ft: UInt64, in: UInt64) {
        let height = Height(ft: ft, in: `in`)
        viewModel.updateFtSelected(height: height)
        viewModel.updateUnitSelected(unit: .ft)
        updateAll()
        getCurrentResult()
    }
}

extension HeightPickerView {
    private func updateAll() {
        guard let selectedUnit = viewModel.unitComponentsObject.selectedObeject else { return }
        
        pickerView.reloadAllComponents()
        
        switch selectedUnit {
            case .cm:
                pickerView.selectRow(viewModel.cmComponentsObject.selectedIndex, inComponent: 0, animated: true)
                pickerView.selectRow(viewModel.unitComponentsObject.selectedIndex, inComponent: 1, animated: false)
            case .in:
                if showsFtComponents {
                    pickerView.selectRow(viewModel.ftComponentsObject.selectedIndex, inComponent: 0, animated: true)
                    pickerView.selectRow(viewModel.inComponentsObject.selectedIndex, inComponent: 2, animated: true)
                    pickerView.selectRow(viewModel.unitComponentsObject.selectedIndex, inComponent: 3, animated: false)
                } else {
                    pickerView.selectRow(viewModel.ftComponentsObject.selectedIndex, inComponent: 0, animated: true)
                    pickerView.selectRow(viewModel.inComponentsObject.selectedIndex, inComponent: 1, animated: true)
                    pickerView.selectRow(viewModel.unitComponentsObject.selectedIndex, inComponent: 2, animated: false)
                }
            default:
                break
        }
    }
    
    private func getCurrentResult() {
        guard let selectedUnit = viewModel.unitComponentsObject.selectedObeject else { return }
        switch selectedUnit {
            case .cm:
                guard let cm = viewModel.cmComponentsObject.selectedObeject else { return }
                let height = Height(cm: cm)
                delegate?.pickerView(self, didSelect: height)
            case .in:
                guard let ft = viewModel.ftComponentsObject.selectedObeject else { return }
                guard let `in` = viewModel.inComponentsObject.selectedObeject else { return }
                let height = Height(ft: ft, in: `in`)
                delegate?.pickerView(self, didSelect: height)
            default:
                break
        }
    }
}

extension HeightPickerView: UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        guard let selectedUnit = viewModel.unitComponentsObject.selectedObeject else { return 0 }
        switch selectedUnit {
            case .cm:
                return 2
            case .in:
                if showsFtComponents {
                    return 4
                } else {
                    return 3
                }
            default:
                return 0
        }
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let selectedUnit = viewModel.unitComponentsObject.selectedObeject else { return 0 }
        switch selectedUnit {
            case .cm:
                if component == 0 {
                    return viewModel.cmComponentsObject.datasource.count
                } else if component == 1 {
                    return viewModel.unitComponentsObject.datasource.count
                }
            case .in:
                if showsFtComponents {
                    if component == 0 {
                        return viewModel.ftComponentsObject.datasource.count
                    } else if component == 1 {
                        return 1 // 显示`ft`
                    } else if component == 2 {
                        return viewModel.inComponentsObject.datasource.count
                    } else if component == 3 {
                        return viewModel.unitComponentsObject.datasource.count
                    }
                } else {
                    if component == 0 {
                        return viewModel.ftComponentsObject.datasource.count
                    } else if component == 1 {
                        return viewModel.inComponentsObject.datasource.count
                    } else if component == 2 {
                        return viewModel.unitComponentsObject.datasource.count
                    }
                }
            default:
                break
        }
        return 0
    }
}

extension HeightPickerView: UIPickerViewDelegate {
    public func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        guard let selectedUnit = viewModel.unitComponentsObject.selectedObeject else { return nil }
        
        var title: String?
        
        switch selectedUnit {
            case .cm:
                if component == 0 {
                    if row >= 0 && row <= viewModel.cmComponentsObject.datasource.count - 1 {
                        title = viewModel.cmComponentsObject.datasource[row].description
                    }
                } else if component == 1 {
                    if row >= 0 && row <= viewModel.unitComponentsObject.datasource.count - 1 {
                        title = viewModel.unitComponentsObject.datasource[row].rawValue
                    }
                }
            case .in:
                if showsFtComponents {
                    if component == 0 {
                        if row >= 0 && row <= viewModel.ftComponentsObject.datasource.count - 1 {
                            title = viewModel.ftComponentsObject.datasource[row].description + "’"
                        }
                    } else if component == 1 {
                        title = HeightUnit.ft.rawValue
                    } else if component == 2 {
                        if row >= 0 && row <= viewModel.inComponentsObject.datasource.count - 1 {
                            title = viewModel.inComponentsObject.datasource[row].description + "“"
                        }
                    } else if component == 3 {
                        if row >= 0 && row <= viewModel.unitComponentsObject.datasource.count - 1 {
                            title = viewModel.unitComponentsObject.datasource[row].rawValue
                        }
                    }
                } else {
                    if component == 0 {
                        if row >= 0 && row <= viewModel.ftComponentsObject.datasource.count - 1 {
                            title = viewModel.ftComponentsObject.datasource[row].description + "’"
                        }
                    } else if component == 1 {
                        if row >= 0 && row <= viewModel.inComponentsObject.datasource.count - 1 {
                            title = viewModel.inComponentsObject.datasource[row].description + "“"
                        }
                    } else if component == 2 {
                        if row >= 0 && row <= viewModel.unitComponentsObject.datasource.count - 1 {
                            title = viewModel.unitComponentsObject.datasource[row].rawValue
                        }
                    }
                }
            default:
                break
        }
        
        if title == nil { return nil }
        
        let atr = NSMutableAttributedString(string: title!, attributes: [.foregroundColor: color, .font: font])
        return atr
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let selectedUnit = viewModel.unitComponentsObject.selectedObeject else { return }
        
        switch selectedUnit {
            case .cm:
                if component == 0 {
                    if row < 0 || row >= viewModel.cmComponentsObject.datasource.count { return }
                    viewModel.cmComponentsObject.selectedIndex = row
                    getCurrentResult()
                } else if component == 1 {
                    if row < 0 || row >= viewModel.unitComponentsObject.datasource.count { return }
                    
                    let willSelectedUnit = viewModel.unitComponentsObject.datasource[row]
                    
                    if selectedUnit == willSelectedUnit { return }
                    
                    guard let cm = viewModel.cmComponentsObject.selectedObeject else { return }
                    
                    let height = Height(cm: cm)
                    viewModel.updateFtSelected(height: height)
                    
                    viewModel.updateUnitSelected(unit: willSelectedUnit)
                    
                    updateAll()
                    getCurrentResult()
                }
            case .in:
                func _updateFt() {
                    if row < 0 || row >= viewModel.ftComponentsObject.datasource.count { return }
                    viewModel.ftComponentsObject.selectedIndex = row
                    getCurrentResult()
                }
                func _updateIn() {
                    if row < 0 || row >= viewModel.inComponentsObject.datasource.count { return }
                    viewModel.inComponentsObject.selectedIndex = row
                    getCurrentResult()
                }
                func _updateUnit() {
                    if row < 0 || row >= viewModel.unitComponentsObject.datasource.count { return }
                    
                    let willSelectedUnit = viewModel.unitComponentsObject.datasource[row]
                    
                    if selectedUnit == willSelectedUnit { return }
                    
                    guard let ft = viewModel.ftComponentsObject.selectedObeject else { return }
                    
                    guard let `in` = viewModel.inComponentsObject.selectedObeject else { return }
                    
                    let height = Height(ft: ft, in: `in`)
                    viewModel.updateCmSelected(height: height)
                    
                    viewModel.updateUnitSelected(unit: willSelectedUnit)
                    
                    updateAll()
                    getCurrentResult()
                }
                
                if showsFtComponents {
                    if component == 0 {
                        _updateFt()
                    } else if component == 1 {
                        // nothing
                    } else if component == 2 {
                        _updateIn()
                    } else if component == 3 {
                        _updateUnit()
                    }
                } else {
                    if component == 0 {
                        _updateFt()
                    } else if component == 1 {
                        _updateIn()
                    } else if component == 2 {
                        _updateUnit()
                    }
                }
            default:
                break
        }
    }
}
