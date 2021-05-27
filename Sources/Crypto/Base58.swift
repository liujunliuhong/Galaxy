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
/// https://www.sohu.com/a/238347731_116580
/// https://www.liankexing.com/q/6455

private let alphabet = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"

extension GL where Base == Data {
    /// `Base 58`编码
    public var base58Encoding: String? {
        let base58AlphaBytes: [UInt8] = [UInt8](alphabet.utf8)
        // 58进制
        let radix = BigUInt(base58AlphaBytes.count)
        // 临时变量
        var x = BigUInt(self.base)
        // 存储转换结果
        var result = [UInt8]()
        // 分配足够的空间
        // 这儿空间有点多余，通过查找资料，经过Base58编码的数据为原始的数据长度的1.37倍左右。此处给了2倍的空间
        result.reserveCapacity(self.base.count + self.base.count)
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
        let zeroBytes = self.base.prefix { (value) -> Bool in
            return value == 0
        }.map { (_) -> UInt8 in
            return base58AlphaBytes.first! // 1
        }
        result.append(contentsOf: zeroBytes)
        // 翻转
        result.reverse()
        // 转为UTF-8 String
        return String(bytes: result, encoding: .utf8)
    }
    
    /// `Base 58`解码
    public var base58Decoding: String? {
        let base58AlphaBytes: [UInt8] = [UInt8](alphabet.utf8)
        // 58进制
        let radix = BigUInt(base58AlphaBytes.count)
        // 原始Data转换为byte
        let bytes = [UInt8](self.base)
        // 初始值
        var result = BigUInt(0)
        //
        var j = BigUInt(1)
        //
        for ch in bytes.reversed() {
            // 拿到对应的索引
            if let index = base58AlphaBytes.firstIndex(of: ch) {
                result = result + (j * BigUInt(index))
                j *= radix
            } else {
                return nil
            }
        }
        // 序列化
        var resultData = result.serialize()
        //
        let zeroBytes = bytes.prefix { value in
            return value == base58AlphaBytes.first! // 1
        }
        //
        resultData = Data(zeroBytes) + resultData
        //
        return String(data: resultData, encoding: .utf8)
    }
}

extension GL where Base == String {
    /// `Base 58`编码
    public var base58Encoding: String? {
        return self.base.data(using: .utf8)?.gl.base58Encoding
    }
    
    /// `Base 58`解码
    public var base58Decoding: String? {
        return self.base.data(using: .utf8)?.gl.base58Decoding
    }
}
