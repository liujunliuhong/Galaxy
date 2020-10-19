//
//  Array+GLExtension.swift
//  SwiftTool
//
//  Created by galaxy on 2020/10/19.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation

extension Array {
    /// json encode
    public var gl_jsonEncode: String? {
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: []) else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    /// The array is randomly shuffled
    public var gl_shuffle: Array<Element> {
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

extension Array {
    /// 数组分组。根据每行数目对数组进行分组
    /// - Parameters:
    ///   - perRowCount: 每行数量
    ///   - isMakeUp: 是否补齐。如果`defaultValue`为`nil`，`isMakeUp`无效
    ///   - defaultValue: 如果需要补齐，此时的默认值
    /// - Returns: 处理好的数组
    public func gl_group(perRowCount: Int, isMakeUp: Bool, defaultValue: Element?) -> [[Element]] {
        assert(perRowCount > 0, "perRowCount must be greater than 0")
        var results: [[Element]] = []
        let row: Int = self.count / perRowCount
        for i in 0..<row {
            var subResults: [Element] = []
            for j in 0..<perRowCount {
                let index = i * perRowCount + j
                subResults.append(self[index])
            }
            results.append(subResults)
        }
        let remain: Int = self.count % perRowCount
        if remain <= 0 {
            return results
        }
        var subResults: [Element] = []
        for i in 0..<perRowCount {
            let index = row * perRowCount + i
            subResults.append(self[index])
        }
        if !isMakeUp {
            results.append(subResults)
            return results
        }
        guard let defaultValue = defaultValue else {
            results.append(subResults)
            return results
        }
        for _ in 0..<(perRowCount - remain) {
            subResults.append(defaultValue)
        }
        results.append(subResults)
        return results
    }
}
