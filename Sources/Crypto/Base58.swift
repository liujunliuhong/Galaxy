//
//  Base58.swift
//  SwiftTool
//
//  Created by liujun on 2021/5/27.
//  Copyright © 2021 yinhe. All rights reserved.
//

import Foundation
import BigInt
import CryptoSwift


/// `Base58`
/// `Base58`是用于`Bitcoin`中使用的一种独特的编码方式，主要用于产生`Bitcoin`的钱包地址。
/// 相比`Base64`，`Base58`不使用数字"0"，字母大写"O"，字母大写"I"，和字母小写"l"，以及"+"和"/"符号。
/// 本质其实就是58进制
/// https://www.cnblogs.com/yanglang/p/10147028.html
/// https://blog.csdn.net/bnbjin/article/details/81431686
/// https://blog.csdn.net/idwtwt/article/details/80740474
/// https://www.sohu.com/a/238347731_116580
/// https://www.liankexing.com/q/6455



/// `Base58 Check`
/// 1.首先对数据添加一个版本前缀，这个前缀用来识别编码的数据类型
/// 2.对数据连续进行两次`SHA256`哈希算法
/// checksum = SHA256(SHA256(prefix+data))
/// 3.在产生的长度为`32`个字节（两次哈希云算）的哈希值中，取其前`4`个字节作为检验和添加到数据第一步产生的数据之后
/// 4.将数据进行Base58编码处理
/// https://blog.csdn.net/luckydog612/article/details/81168276
/// https://www.jianshu.com/p/9644fe5a06bc
/// 地址前缀列表：https://en.bitcoin.it/wiki/List_of_address_prefixes




private let alphabet = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"


/// `Base 58`
public struct Base58 {
    /// `Base 58`编码
    public static func base58Encoded(data: Data) -> Data {
        let base58AlphaBytes: [UInt8] = [UInt8](alphabet.utf8)
        // 58进制
        let radix = BigUInt(base58AlphaBytes.count)
        // 临时变量
        var x = BigUInt(data)
        // 存储转换结果
        var result = [UInt8]()
        // 分配足够的空间
        // 这儿空间有点多余，通过查找资料，经过Base58编码的数据为原始的数据长度的1.37倍左右。此处给了2倍的空间
        result.reserveCapacity(data.count + data.count)
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
        let zeroBytes = data.prefix { (value) -> Bool in
            return value == 0
        }.map { (_) -> UInt8 in
            return base58AlphaBytes.first! // 1
        }
        result.append(contentsOf: zeroBytes)
        // 翻转
        result.reverse()
        
        return Data(result)
    }
    
    /// `Base 58`解码
    public static func base58Decoded(data: Data) -> Data? {
        let base58AlphaBytes: [UInt8] = [UInt8](alphabet.utf8)
        // 58进制
        let radix = BigUInt(base58AlphaBytes.count)
        // 原始Data转换为byte
        let bytes = [UInt8](data)
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
        
        return resultData
    }
    
    /// `Base 58 Check`编码
    public static func base58CheckEncoded(prefix: UInt8, data: Data) -> Data {
        var bytes = [UInt8](Array(data))
        // 在首位添加`prefix`
        bytes.insert(prefix, at: 0)
        // 连续两次`SHA256`
        let checksums = bytes.sha256().sha256()
        // 取前4位得到`checksum`
        let checksum = Array(checksums[0..<4])
        // 得到完整的`bytes`
        bytes += checksum
        // Base58编码
        return Base58.base58Encoded(data: Data(bytes))
    }
    
    /// `Base 58 Check`解码
    public static func base58CheckDecoded(data: Data) -> Data? {
        // 先解码
        guard let data = Base58.base58Decoded(data: data) else { return nil }
        // 如果长度小于4，这届return nil
        guard data.count >= 4 else { return nil }
        // 转换为字节数组
        let bytes = [UInt8](Array(data))
        // 得到原始数据
        let resultBytes = Array(bytes[0..<(bytes.count - 4)])
        // 取后4位得到checksum
        let checksum = Array(bytes[(bytes.count - 4)..<bytes.count])
        // 作对比
        if Array(resultBytes.sha256().sha256()[0..<4]) != checksum {
            return nil
        }
        return Data(resultBytes)
    }
}
