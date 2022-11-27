//
//  HeightPickerViewModel.swift
//  Galaxy
//
//  Created by galaxy on 2022/11/27.
//

import Foundation
import RxSwift
import RxCocoa

internal class ComponentsObject<T> {
    let datasource: [T]
    var selectedIndex: Int = 0
    
    init(datasource: [T]) {
        self.datasource = datasource
    }
    
    var selectedObeject: T? {
        if selectedIndex >= 0 && selectedIndex <= datasource.count - 1 {
            return datasource[selectedIndex]
        }
        return nil
    }
}



internal final class HeightPickerViewModel {
    
    let cmComponentsObject: ComponentsObject<UInt64>
    
    let ftComponentsObject: ComponentsObject<UInt64>
    let inComponentsObject: ComponentsObject<UInt64>
    
    let unitComponentsObject: ComponentsObject<HeightUnit>
    
    let currentUint = BehaviorRelay<HeightUnit>(value: .cm)
    
    init() {
        do {
            self.unitComponentsObject = ComponentsObject(datasource: [.cm, .in])
        }
        do {
            let cmHeights: [UInt64] = (40...280).map{ UInt64($0) }
            self.cmComponentsObject = ComponentsObject(datasource: cmHeights)
        }
        do {
            let fts: [UInt64] = (3...9).map{ UInt64($0) }
            self.ftComponentsObject = ComponentsObject(datasource: fts)
            
            let ins = (0...11).map{ UInt64($0) }
            self.inComponentsObject = ComponentsObject(datasource: ins)
        }
    }
}

extension HeightPickerViewModel {
    func updateUnitSelected(unit: HeightUnit) {
        for (i, value) in unitComponentsObject.datasource.enumerated() {
            if value == unit {
                unitComponentsObject.selectedIndex = i
                break
            }
        }
    }
    
    func updateFtSelected(cmHeight: CmHeight?) {
        var ftHeight: FtHeight?
        if let cmHeight = cmHeight {
            ftHeight = FtHeight(cmHeight: cmHeight)
        }
        updateFtSelected(ftHeight: ftHeight)
    }
    
    func updateFtSelected(ftHeight: FtHeight?) {
        for (i, value) in ftComponentsObject.datasource.enumerated() {
            if ftHeight?.ft == value {
                ftComponentsObject.selectedIndex = i
                
                for (i, value) in inComponentsObject.datasource.enumerated() {
                    if ftHeight?.in == value {
                        inComponentsObject.selectedIndex = i
                        break
                    }
                }
                
                break
            }
        }
    }
    
    func updateCmSelected(ftHeight: FtHeight?) {
        var cmHeight: CmHeight?
        if let ftHeight = ftHeight {
            cmHeight = ftHeight.cmHeight
        }
        updateCmSelected(cmHeight: cmHeight)
    }
    
    func updateCmSelected(cmHeight: CmHeight?) {
        for (i, value) in cmComponentsObject.datasource.enumerated() {
            if cmHeight?.cm == value {
                cmComponentsObject.selectedIndex = i
                break
            }
        }
    }
}
