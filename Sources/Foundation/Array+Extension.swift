//
//  Array+Extension.swift
//  SwiftTool
//
//  Created by galaxy on 2021/5/14.
//  Copyright © 2021 yinhe. All rights reserved.
//

import Foundation


extension Array {
    /// 数组打乱顺序
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
    /// 根据每行数目对数组进行分组
    /// - Parameters:
    ///   - perRowCount: 每行数量
    ///   - isMakeUp: 是否补齐。如果`defaultValue`为`nil`，`isMakeUp`无效
    ///   - defaultValueClosure: 如果需要补齐，此时的默认值
    /// - Returns: 处理好的数组
    public func gl_makeGroups(perRowCount: Int, isMakeUp: Bool, defaultValueClosure: (()->(Element))?) -> [[Element]] {
        assert(perRowCount > 0, "perRowCount must be greater than 0")
        var results: [[Element]] = []
        let row: Int = count / perRowCount
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
        for i in 0..<remain {
            let index = row * perRowCount + i
            subResults.append(self[index])
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

extension Array where Element == UInt8 {
    /// 字节数组转字符串
    public var gl_bytesToString: String? {
        return String(bytes: self, encoding: .utf8)
    }
    
    /// 字节数组转`16`进制字符串
    public var gl_bytesToHexString: String {
        return `lazy`.reduce("") {
            var s = String($1, radix: 16)
            if s.count == 1 {
                s = "0" + s
            }
            return $0 + s
        }
    }
}
