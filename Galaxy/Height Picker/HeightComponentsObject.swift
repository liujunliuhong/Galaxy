//
//  HeightComponentsObject.swift
//  Galaxy
//
//  Created by galaxy on 2022/12/16.
//

import Foundation

internal class HeightComponentsObject<T> {
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
