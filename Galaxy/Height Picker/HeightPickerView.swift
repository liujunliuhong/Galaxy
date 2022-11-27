//
//  HeightPickerView.swift
//  Galaxy
//
//  Created by galaxy on 2022/11/26.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx
import SnapKit

public final class HeightPickerView: UIView {
    
    private lazy var viewModel: HeightPickerViewModel = {
        let viewModel = HeightPickerViewModel()
        return viewModel
    }()
    
    private lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    public var font: UIFont = .boldSystemFont(ofSize: 17) {
        didSet {
            viewModel.currentUint.accept(viewModel.currentUint.value)
        }
    }
    
    public var color: UIColor = .black {
        didSet {
            viewModel.currentUint.accept(viewModel.currentUint.value)
        }
    }
    
    private let defaultWidth: CGFloat?
    private let defaultHeight: CGFloat?
    
    public let result = BehaviorRelay<HeightResult?>(value: nil)
    
    public init(defaultWidth: CGFloat?, defaultHeight: CGFloat?) {
        self.defaultWidth = defaultWidth
        self.defaultHeight = defaultHeight
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
        viewModel.currentUint
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] unit in
                guard let self = self else { return }
                
                self.getCurrentResult()
                
                self.pickerView.reloadAllComponents()
                
                switch unit {
                    case .cm:
                        self.pickerView.selectRow(self.viewModel.cmComponentsObject.selectedIndex, inComponent: 0, animated: true)
                        self.pickerView.selectRow(self.viewModel.unitComponentsObject.selectedIndex, inComponent: 1, animated: true)
                    case .in:
                        self.pickerView.selectRow(self.viewModel.ftComponentsObject.selectedIndex, inComponent: 0, animated: true)
                        self.pickerView.selectRow(self.viewModel.inComponentsObject.selectedIndex, inComponent: 2, animated: true)
                        self.pickerView.selectRow(self.viewModel.unitComponentsObject.selectedIndex, inComponent: 3, animated: true)
                    default:
                        break
                }
            }).disposed(by: rx.disposeBag)
        
        getCurrentResult()
    }
}

extension HeightPickerView {
    public func setDefault(cm: UInt64) {
        let cmHeight = CmHeight(cm: cm)
        viewModel.updateCmSelected(cmHeight: cmHeight)
        viewModel.updateUnitSelected(unit: .cm)
        viewModel.currentUint.accept(.cm)
    }
    
    public func setDefault(ft: UInt64, in: UInt64) {
        let ftHeight = FtHeight(ft: ft, in: `in`)
        viewModel.updateFtSelected(ftHeight: ftHeight)
        viewModel.updateUnitSelected(unit: .ft)
        viewModel.currentUint.accept(.ft)
    }
}

extension HeightPickerView {
    private func getCurrentResult() {
        let unit = viewModel.currentUint.value
        switch unit {
            case .cm:
                guard let cm = viewModel.cmComponentsObject.selectedObeject else {
                    self.result.accept(nil)
                    return
                }
                let cmHeight = CmHeight(cm: cm)
                let ftHeight = FtHeight(cmHeight: cmHeight)
                
                let result = HeightResult(cmHeight: cmHeight, ftHeight: ftHeight)
                self.result.accept(result)
            case .in:
                guard let ft = viewModel.ftComponentsObject.selectedObeject else {
                    self.result.accept(nil)
                    return
                }
                guard let `in` = viewModel.inComponentsObject.selectedObeject else {
                    self.result.accept(nil)
                    return
                }
                let ftHeight = FtHeight(ft: ft, in: `in`)
                let cmHeight = ftHeight.cmHeight
                let result = HeightResult(cmHeight: cmHeight, ftHeight: ftHeight)
                self.result.accept(result)
            default:
                break
        }
    }
}

extension HeightPickerView: UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        let unit = viewModel.currentUint.value
        switch unit {
            case .cm:
                return 2
            case .in:
                return 4
            default:
                return 0
        }
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let unit = viewModel.currentUint.value
        switch unit {
            case .cm:
                if component == 0 {
                    return viewModel.cmComponentsObject.datasource.count
                } else if component == 1 {
                    return viewModel.unitComponentsObject.datasource.count
                }
            case .in:
                if component == 0 {
                    return viewModel.ftComponentsObject.datasource.count
                } else if component == 1 {
                    return 1
                } else if component == 2 {
                    return viewModel.inComponentsObject.datasource.count
                } else if component == 3 {
                    return viewModel.unitComponentsObject.datasource.count
                }
            default:
                break
        }
        return 0
    }
}

extension HeightPickerView: UIPickerViewDelegate {
    public func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var title: String?
        
        let unit = viewModel.currentUint.value
        switch unit {
            case .cm:
                if component == 0 {
                    if row >= 0 && row <= viewModel.cmComponentsObject.datasource.count - 1 {
                        title = viewModel.cmComponentsObject.datasource[row].description
                    } else {
                        title = nil
                    }
                } else if component == 1 {
                    if row >= 0 && row <= viewModel.unitComponentsObject.datasource.count - 1 {
                        title = viewModel.unitComponentsObject.datasource[row].rawValue
                    } else {
                        title = nil
                    }
                }
            case .in:
                if component == 0 {
                    if row >= 0 && row <= viewModel.ftComponentsObject.datasource.count - 1 {
                        title = viewModel.ftComponentsObject.datasource[row].description + "’"
                    } else {
                        title = nil
                    }
                } else if component == 1 {
                    title = HeightUnit.ft.rawValue
                } else if component == 2 {
                    if row >= 0 && row <= viewModel.inComponentsObject.datasource.count - 1 {
                        title = viewModel.inComponentsObject.datasource[row].description + "“"
                    } else {
                        title = nil
                    }
                } else if component == 3 {
                    if row >= 0 && row <= viewModel.unitComponentsObject.datasource.count - 1 {
                        title = viewModel.unitComponentsObject.datasource[row].rawValue
                    } else {
                        title = nil
                    }
                }
            default:
                break
        }
        if title != nil {
            let atr = NSMutableAttributedString(string: title!, attributes: [.foregroundColor: color, .font: font])
            return atr
        } else {
            return nil
        }
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let unit = viewModel.currentUint.value
        switch unit {
            case .cm:
                if component == 0 {
                    if row >= 0 && row <= viewModel.cmComponentsObject.datasource.count - 1 {
                        viewModel.cmComponentsObject.selectedIndex = row
                        getCurrentResult()
                    }
                } else if component == 1 {
                    if row >= 0 && row <= viewModel.unitComponentsObject.datasource.count - 1 {
                        let selectedUnit = viewModel.unitComponentsObject.datasource[row]
                        
                        if selectedUnit == unit {
                            return
                        }
                        
                        let cm = viewModel.cmComponentsObject.datasource[viewModel.cmComponentsObject.selectedIndex]
                        let cmHeight = CmHeight(cm: cm)
                        viewModel.updateFtSelected(cmHeight: cmHeight)
                        
                        viewModel.updateUnitSelected(unit: selectedUnit)
                        
                        viewModel.currentUint.accept(selectedUnit)
                    }
                }
            case .in:
                if component == 0 {
                    if row >= 0 && row <= viewModel.ftComponentsObject.datasource.count - 1 {
                        viewModel.ftComponentsObject.selectedIndex = row
                        getCurrentResult()
                    }
                } else if component == 2 {
                    if row >= 0 && row <= viewModel.inComponentsObject.datasource.count - 1 {
                        viewModel.inComponentsObject.selectedIndex = row
                        getCurrentResult()
                    }
                } else if component == 3 {
                    if row >= 0 && row <= viewModel.unitComponentsObject.datasource.count - 1 {
                        let selectedUnit = viewModel.unitComponentsObject.datasource[row]
                        
                        if selectedUnit == unit {
                            return
                        }
                        
                        let ft = viewModel.ftComponentsObject.datasource[viewModel.ftComponentsObject.selectedIndex]
                        let `in` = viewModel.inComponentsObject.datasource[viewModel.inComponentsObject.selectedIndex]
                        let ftHeight = FtHeight(ft: ft, in: `in`)
                        viewModel.updateCmSelected(ftHeight: ftHeight)
                        
                        viewModel.updateUnitSelected(unit: selectedUnit)
                        
                        viewModel.currentUint.accept(selectedUnit)
                    }
                }
            default:
                break
        }
    }
}
