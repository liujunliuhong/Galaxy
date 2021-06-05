//
//  Collection+Extension.swift
//  SwiftTool
//
//  Created by liujun on 2021/5/15.
//  Copyright © 2021 yinhe. All rights reserved.
//

import Foundation

extension GL where Base: MutableCollection {
    /// 数组打乱顺序
    public var shuffle: Base {
        var list = base
        for index in 0..<list.count {
            let newIndex = Int(arc4random_uniform(UInt32(list.count-index))) + index
            if index != newIndex {
                list.swapAt(index as! Base.Index, newIndex as! Base.Index)
            }
        }
        
        return list
    }
    
    /// 根据每行数目对数组进行分组
    /// - Parameters:
    ///   - perRowCount: 每行数量
    ///   - isMakeUp: 是否补齐。如果`defaultValue`为`nil`，`isMakeUp`无效
    ///   - defaultValueClosure: 如果需要补齐，此时的默认值
    /// - Returns: 处理好的数组
    public func makeGroups(perRowCount: Int, isMakeUp: Bool, defaultValueClosure: (()->(Base.Element))?) -> [[Base.Element]] {
        assert(perRowCount > 0, "perRowCount must be greater than 0")
        var results: [[Base.Element]] = []
        let row: Int = base.count / perRowCount
        for i in 0..<row {
            var subResults: [Base.Element] = []
            for j in 0..<perRowCount {
                let index = i * perRowCount + j
                subResults.append(base[index as! Base.Index])
            }
            results.append(subResults)
        }
        let remain: Int = base.count % perRowCount
        if remain <= 0 {
            return results
        }
        var subResults: [Base.Element] = []
        for i in 0..<remain {
            let index = row * perRowCount + i
            subResults.append(base[index as! Base.Index])
        }
        if !isMakeUp {
            results.append(subResults)
            return results
        }
        guard let defaultValueClosure = defaultValueClosure else {
            results.append(subResults)
            return results
        }
        for _ in 0..<(perRowCount - remain) {
            subResults.append(defaultValueClosure())
        }
        results.append(subResults)
        return results
    }
}

extension GL where Base: Collection {
    /// json编码
    public var jsonEncode: String? {
        guard let data = try? JSONSerialization.data(withJSONObject: base, options: []) else { return nil }
        return String(data: data, encoding: .utf8)
    }
}
