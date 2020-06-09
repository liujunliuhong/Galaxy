//
//  Array+SwiftyExtension.swift
//  SwiftTool
//
//  Created by apple on 2020/5/20.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation

extension Array {
    /// json encode
    public var YH_jsonEnCode: String? {
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: []) else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    /// The array is randomly shuffled
    public var YH_shuffle: Array<Element> {
        var list = self
        for index in 0..<list.count {
            let newIndex = Int(arc4random_uniform(UInt32(list.count-index))) + index
            if index != newIndex {
                list.swapAt(index, newIndex)
            }
        }
        return list
    }
}

public extension Array where Element: NSObject {
    /// A certain number of collections are grouped. The elements in the collection must inherit from `NSObject`. If the last line is less than `perRowCount`, use the default initialization
    /// - Parameter perRowCount: perRowCount
    /// - Returns: grouped
    func YH_group(perRowCount: Int) -> [[Element]] {
        var allValues: [Element] = []
        //
        let remainCount = self.count % perRowCount // The remaining amount is not full
        for (_, value) in self.enumerated() {
            allValues.append(value)
        }
        // Remaining fill
        if remainCount > 0 {
            for _ in 0..<(perRowCount - remainCount) {
                allValues.append(Element.init())
            }
        }
        //
        var finalAllValues: [[Element]] = []
        // Now the number of `allValues` must be an integer multiple of `perRowCount`
        let rowCount = allValues.count / perRowCount // Rows full
        for i in 0..<rowCount {
            var subValues: [Element] = []
            for j in 0..<perRowCount {
                let index = i * perRowCount + j
                subValues.append(allValues[index])
            }
            finalAllValues.append(subValues)
        }
        return finalAllValues
    }
}
