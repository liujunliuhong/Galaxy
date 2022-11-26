//
//  HeightPickerView.swift
//  Galaxy
//
//  Created by galaxy on 2022/11/26.
//

import UIKit


public final class HeightPickerView: UIView {

    private lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()

    
}

extension HeightPickerView {
    
}

extension HeightPickerView: UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 1
    }
}

extension HeightPickerView: UIPickerViewDelegate {
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
}
