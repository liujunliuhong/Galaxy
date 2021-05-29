//
//  BinaryInteger+Extension.swift
//  Galaxy
//
//  Created by liujun on 2021/5/29.
//

import Foundation

/// 位运算规则
/// `&`    与     两个位都为1时，结果才为1
/// `|`    或     两个位都为0时，结果才为0
/// `^`    异或   两个位相同为0，相异为1
/// `~`    取反   0变1，1变0
/// `<<`   左移   各二进位全部左移若干位，高位丢弃，低位补0
/// `>>`   右移   各二进位全部右移若干位，对无符号数，高位补0，有符号数，各编译器处理方法不一样，有的补符号位（算术右移），有的补0（逻辑右移）


extension GL where Base: BinaryInteger {
    /// 获取对应的二进制
    ///
    ///     UInt8(10).gl.binaryDescription // 0000 1010
    ///
    public func binaryDescription(separator: String = " ") -> String {
        var binaryString = ""
        var internalNumber = self.base
        for idx in 0..<self.base.bitWidth {
            // 核心`internalNumber & 1`
            binaryString.insert(contentsOf: "\(internalNumber & 1)", at: binaryString.startIndex)
            // 右移1位
            internalNumber >>= 1
            // 每隔`bitWidth`插入一个空格
            if idx.advanced(by: 1) % 4 == 0 && idx != self.base.bitWidth - 1 {
                binaryString.insert(contentsOf: separator, at: binaryString.startIndex)
            }
        }
        return binaryString
    }
}
