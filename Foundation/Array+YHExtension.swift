//
//  Array+YHExtension.swift
//  FNDating
//
//  Created by apple on 2019/10/12.
//  Copyright © 2019 yinhe. All rights reserved.
//

import Foundation


extension Array {
    /// json encode
    var yh_jsonEnCode: String? {
        let data = try? JSONSerialization.data(withJSONObject: self, options: [])
        guard let _data = data else { return nil }
        return String(data: _data, encoding: .utf8)
    }
}

extension Array {
    /// 一定数量的集合分组。集合里面的元素必须继承自`NSObject`。如果最后一行不足`perRowCount`，则用默认的初始化
    /// - Parameters:
    ///   - perRowCount: 每行多少个
    public func yh_group<T: NSObject>(perRowCount: Int) -> [[T]] where Element: NSObject {
        var allValues: [T] = []
        //
        let remainCount = self.count % perRowCount // 剩余没有排满的数量
        for (_, value) in self.enumerated() {
            allValues.append(value as! T)
        }
        // 剩余的补齐
        if remainCount > 0 {
            for _ in 0..<(perRowCount - remainCount) {
                allValues.append(T.init())
            }
        }
        //
        var finalAllValues: [[T]] = []
        // 现在`allValues`的数量一定是`perRowCount`的整数倍了
        let rowCount = allValues.count / perRowCount // 排满了几排
        for i in 0..<rowCount {
            var subValues: [T] = []
            for j in 0..<perRowCount {
                let index = i * perRowCount + j
                subValues.append(allValues[index])
            }
            finalAllValues.append(subValues)
        }
        return finalAllValues
    }
}


extension Array {
    /// 数组随机打乱顺序
    public func yh_shuffle() -> Array<Element> {
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
