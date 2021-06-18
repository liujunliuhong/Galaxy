//
//  FixedWidthInteger+Extension.swift
//  Galaxy
//
//  Created by galaxy on 2021/6/5.
//

import Foundation

extension GL where Base: FixedWidthInteger {
    /// 序列化(big-endian)
    ///
    ///     UInt16 -> UInt8
    ///     UInt32 -> UInt16
    ///     UInt32 -> UInt8
    ///     UInt64 -> UInt32
    ///     UInt64 -> UInt16
    ///     UInt64 -> UInt8
    public func bigEndianSerialize<T: FixedWidthInteger>(to type: T.Type) -> [T] {
        return serialize(to: type, littleEndian: false)
    }
    
    /// 序列化(little-endian)
    ///
    ///     UInt16 -> UInt8
    ///     UInt32 -> UInt16
    ///     UInt32 -> UInt8
    ///     UInt64 -> UInt32
    ///     UInt64 -> UInt16
    ///     UInt64 -> UInt8
    public func littleEndianSerialize<T: FixedWidthInteger>(to type: T.Type) -> [T] {
        return serialize(to: type, littleEndian: true)
    }
}



extension GL where Base: FixedWidthInteger {
    fileprivate func serialize<T: FixedWidthInteger>(to type: T.Type, littleEndian: Bool) -> [T] {
        var value = self.base.littleEndian
        if !littleEndian {
            value = self.base.bigEndian
        }
        let count = MemoryLayout.size(ofValue: self.base)
        
        let bytePtr = withUnsafePointer(to: &value) { ptr in
            return ptr.withMemoryRebound(to: type.self, capacity: count) { ptr1 in
                return UnsafeBufferPointer<T>(start: ptr1, count: count)
            }
        }
        return Array(bytePtr)
    }
}
