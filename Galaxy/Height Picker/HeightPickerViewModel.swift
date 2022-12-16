//
//  HeightPickerViewModel.swift
//  Galaxy
//
//  Created by galaxy on 2022/11/27.
//

import Foundation

internal final class HeightPickerViewModel {
    
    let cmComponentsObject: HeightComponentsObject<UInt64>
    
    let ftComponentsObject: HeightComponentsObject<UInt64>
    let inComponentsObject: HeightComponentsObject<UInt64>
    
    let unitComponentsObject: HeightComponentsObject<HeightUnit>
    
    init(minimumHeight: Height, maximumHeight: Height) {
        do {
            self.unitComponentsObject = HeightComponentsObject(datasource: [.cm, .in])
        }
        do {
            let cmHeights: [UInt64] = (minimumHeight.cm...maximumHeight.cm).map{ UInt64($0) }
            self.cmComponentsObject = HeightComponentsObject(datasource: cmHeights)
        }
        do {
            let fts: [UInt64] = (minimumHeight.ft...maximumHeight.ft).map{ UInt64($0) }
            self.ftComponentsObject = HeightComponentsObject(datasource: fts)
            
            let ins = (0...11).map{ UInt64($0) }
            self.inComponentsObject = HeightComponentsObject(datasource: ins)
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
    
    func updateFtSelected(height: Height) {
        for (i, value) in ftComponentsObject.datasource.enumerated() {
            if height.ft == value {
                ftComponentsObject.selectedIndex = i
                
                for (i, value) in inComponentsObject.datasource.enumerated() {
                    if height.in == value {
                        inComponentsObject.selectedIndex = i
                        break
                    }
                }
                
                break
            }
        }
    }
    
    func updateCmSelected(height: Height) {
        for (i, value) in cmComponentsObject.datasource.enumerated() {
            if height.cm == value {
                cmComponentsObject.selectedIndex = i
                break
            }
        }
    }
}
