//
//  FixedWidthInteger+Extension.swift
//  Galaxy
//
//  Created by galaxy on 2021/6/5.
//

import Foundation

extension GL where Base: FixedWidthInteger {
    /// 序列化(big-endian)从左往右
    /// - Parameters:
    ///   - type: 转换为什么类型
    ///   - keepLeadingZero: 是否保留头部的0
    /// - Returns: 目标类型数组
    
    public func bigEndianSerialize<T: FixedWidthInteger>(to type: T.Type, keepLeadingZero: Bool) -> [T] {
        
        let value = T(self.base)
        var bigEndian = value.bigEndian
        let count = MemoryLayout.size(ofValue: self.base)
        
        let bytePtr = withUnsafePointer(to: &bigEndian) {
            $0.withMemoryRebound(to: type.self, capacity: count) {
                UnsafeBufferPointer(start: $0, count: count)
            }
        }
        
        
        let zero: String = [UInt8](repeating: 0, count: type.bitWidth).map{ "\($0)" }
            .joined()
        let binaryStirng = binaryDescription(separator: "")
        var output = [T]()
        let splittedStrings = binaryStirng
            .reversed()
            .map{ "\($0)" }
            .gl
            .makeGroups(perRowCount: type.bitWidth, isMakeUp: true) { return "0" }
            .joined()
            .joined()
            .reversed()
            .map{ "\($0)" }
            .gl
            .makeGroups(perRowCount: type.bitWidth, isMakeUp: false, defaultValueClosure: nil)
        
        for (i, v) in splittedStrings.enumerated() {
            let vaule = v.map { String($0) }.joined(separator: "")
            if i == 0 && vaule == zero && !keepLeadingZero { continue }
            output.append(T(vaule, radix: 2)!)
        }
        return output
    }
}
