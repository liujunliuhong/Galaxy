//
//  BTC.swift
//  Galaxy
//
//  Created by liujun on 2021/6/8.
//

import Foundation

public class BTC {
    
    public var compressedWIF: String? {
        guard let prefixData = "0x80".gl.toHexData else { return nil }
        guard let compressedPrivateKey = bip32.compressedPrivateKey else { return nil }
        let result = Base58.base58CheckEncoded(prefix: prefixData, data: compressedPrivateKey)
        return String(data: result, encoding: .utf8)
    }
    
    public var uncompressedWIF: String? {
        guard let prefixData = "0x80".gl.toHexData else { return nil }
        guard let uncompressedPrivateKey = bip32.uncompressedPrivateKey else { return nil }
        let result = Base58.base58CheckEncoded(prefix: prefixData, data: uncompressedPrivateKey)
        return String(data: result, encoding: .utf8)
    }
    
    public var compressedWIFTestnet: String? {
        guard let prefixData = "0x6F".gl.toHexData else { return nil }
        guard let compressedPrivateKey = bip32.compressedPrivateKey else { return nil }
        let result = Base58.base58CheckEncoded(prefix: prefixData, data: compressedPrivateKey)
        return String(data: result, encoding: .utf8)
    }
    
    public var uncompressedWIFTestnet: String? {
        guard let prefixData = "0x6F".gl.toHexData else { return nil }
        guard let uncompressedPrivateKey = bip32.uncompressedPrivateKey else { return nil }
        let result = Base58.base58CheckEncoded(prefix: prefixData, data: uncompressedPrivateKey)
        return String(data: result, encoding: .utf8)
    }
    
    
    
    public let bip32: BIP32
    
    public init(bip32: BIP32) {
        self.bip32 = bip32
    }
}

extension BTC {
    
}
