//
//  BTC.swift
//  Galaxy
//
//  Created by liujun on 2021/6/8.
//

import Foundation

/// `UTXO`(Unspent Transaction Output)
/// 未被花费的交易输出

/// 输出->锁定脚本（锁定脚本是一个放置在输出上面的花费条件：它指定了今后花费这笔输出必须要满足的条件）
/// 输入->解锁脚本（解锁脚本是一个证明比特币所有权的数字签名和公钥，但是并不是所有的解锁脚本都包含签名）
/// 比特币交易脚本语言包含许多操作符


/// 比特币并不是基于账户的方案，而是基于`UTXO`方案。这个和传统银行账户的思维完全不一样。
/// 张三拥有`10`个`btc`，其实就是当前区块链账本中，有若干笔交易的输出（`UTXO`）收款人都是张三的地址，而这些`UXTO`的总额为`10`。
/// 这个地址一共收了多少`UTXO`，则是要通过比特币钱包代为跟踪计算，所以钱包里显示的余额其实是有多少价值`btc`的输出指向你的地址。


/// `ECDSA`（`Elliptic Curve Digital Signature Algorithm`）
/// 椭圆曲线数字签名算法
/// 数字签名是一种数学方案，由两部分组成的：
/// 第一部分是使用私钥（签名密钥）从消息（交易）创建签名的算法；
/// 第二部分是允许任何人给定依据给定的消息和公钥验证签名的算法。


/// `DER`（`Distinguished Encoding Rules`）
/// 签名序列化





/// https://github.com/inoutcode/bitcoin_book_2nd/blob/master/%E7%AC%AC%E5%85%AD%E7%AB%A0.asciidoc#simplemath_script
/// https://www.jianshu.com/p/ed92cd055c40


/// BTC
public class BTC {
    
    /// 压缩私钥的Base58Check
    public var compressedWIF: String? {
        return Base58.base58CheckEncoded(hexPrefix: "0x80", data: bip32.compressedPrivateKey)
    }
    
    /// 未压缩私钥的Base58Check
    public var uncompressedWIF: String? {
        return Base58.base58CheckEncoded(hexPrefix: "0x80", data: bip32.uncompressedPrivateKey)
    }
    
    /// 压缩私钥测试网的Base58Check
    public var compressedWIFTestnet: String? {
        return Base58.base58CheckEncoded(hexPrefix: "0x6F", data: bip32.compressedPrivateKey)
    }
    
    /// 未压缩私钥测试网的Base58Check
    public var uncompressedWIFTestnet: String? {
        return Base58.base58CheckEncoded(hexPrefix: "0x6F", data: bip32.uncompressedPrivateKey)
    }
    
    /// 由压缩公钥生成的BTC地址
    public var compressedAddress: String? {
        var hash = SHA256.sha256(data: bip32.compressedPublicKey)
        hash = RIPEMD160.hash(message: hash)
        return Base58.base58CheckEncoded(hexPrefix: "0x00", data: hash)
    }
    
    /// 由未压缩公钥生成的BTC地址
    public var uncompressedAddress: String? {
        guard let uncompressedPublicKey = bip32.uncompressedPublicKey else { return nil }
        var hash = SHA256.sha256(data: uncompressedPublicKey)
        hash = RIPEMD160.hash(message: hash)
        return Base58.base58CheckEncoded(hexPrefix: "0x00", data: hash)
    }
    
    public let bip32: BIP32
    
    public init(bip32: BIP32) {
        self.bip32 = bip32
    }
}

extension BTC {
    
}
