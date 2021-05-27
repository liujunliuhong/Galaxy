//
//  Base58.swift
//  SwiftTool
//
//  Created by liujun on 2021/5/27.
//  Copyright © 2021 yinhe. All rights reserved.
//

import Foundation
import BigInt

/// `Base58`是用于`Bitcoin`中使用的一种独特的编码方式，主要用于产生`Bitcoin`的钱包地址。
/// 相比`Base64`，`Base58`不使用数字"0"，字母大写"O"，字母大写"I"，和字母小写"l"，以及"+"和"/"符号。
/// 本质其实就是58进制
/// https://www.cnblogs.com/yanglang/p/10147028.html
/// https://blog.csdn.net/bnbjin/article/details/81431686
/// https://blog.csdn.net/idwtwt/article/details/80740474
 
private let alphabet = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"

extension Data {
    public var gl_base58Encoding: String {
        let base58AlphaBytes: [UInt8] = [UInt8](alphabet.utf8)
        // 58进制
        let radix = BigUInt(base58AlphaBytes.count)
        // 临时变量
        var x = BigUInt(self)
        // 存储转换结果
        var result = [UInt8]()
        // 分配足够的空间（空间有点多余，通过查找资料，经过Base58编码的数据为原始的数据长度的1.37倍）
        result.reserveCapacity(self.count + self.count)
        // 循环遍历
        while x > BigUInt(0) {
            // x除以58，获取商和余数
            let (quotient, remainder) = x.quotientAndRemainder(dividingBy: radix)
            // 余数就是索引，根据索引取值，然后放进数组中
            result.append(base58AlphaBytes[Int(remainder)])
            // 重新赋值x，开始下一次循环
            x = quotient
        }
        // 最前面的0
        let zeroBytes = self.prefix { (value) -> Bool in
            return value == 0
        }.map { (_) -> UInt8 in
            return base58AlphaBytes.first!
        }
        result.append(contentsOf: zeroBytes)
        // 翻转
        result.reverse()
        // 转为String
        return String(bytes: result, encoding: .utf8)!
    }
}

extension String {
//    public var gl_base58Encoding: String {
//        let base58AlphaBytes: [UInt8] = [UInt8](alphabet.utf8)
//        // 58进制
//        let radix = BigUInt(base58AlphaBytes.count)
//        // 临时变量
//        var x = BigUInt(self)
//        // 存储转换结果
//        var result = [UInt8]()
//        // 分配足够的空间（空间有点多余，通过查找资料，经过Base58编码的数据为原始的数据长度的1.37倍）
//        result.reserveCapacity(self.count + self.count)
//        // 循环遍历
//        while x > BigUInt(0) {
//            // x除以58，获取商和余数
//            let (quotient, remainder) = x.quotientAndRemainder(dividingBy: radix)
//            // 余数就是索引，根据索引取值，然后放进数组中
//            result.append(base58AlphaBytes[Int(remainder)])
//            // 重新赋值x，开始下一次循环
//            x = quotient
//        }
//        // 最前面的0
//        let zeroBytes = self.prefix { (value) -> Bool in
//            return value == 0
//        }.map { (_) -> UInt8 in
//            return base58AlphaBytes.first!
//        }
//        result.append(contentsOf: zeroBytes)
//        // 翻转
//        result.reverse()
//        return String(bytes: result, encoding: .utf8)!
//    }
}
