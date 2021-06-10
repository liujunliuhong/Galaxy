//
//  BTC.swift
//  Galaxy
//
//  Created by liujun on 2021/6/8.
//

import Foundation

/// https://github.com/inoutcode/bitcoin_book_2nd/blob/master/%E7%AC%AC%E5%85%AD%E7%AB%A0.asciidoc#simplemath_script


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
