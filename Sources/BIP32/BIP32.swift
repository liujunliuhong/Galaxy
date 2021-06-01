//
//  BIP32.swift
//  Galaxy
//
//  Created by galaxy on 2021/5/30.
//

import Foundation


/// BIP32
/// 分层确定性钱包（Hierarchical Deterministic wallet） (HD Wallet)
/// 从单一个`seed`产生一树状结构储存多组私钥和公钥
/// 好处是可以方便的备份、转移到其他相容装置（因为都只需要`seed`），以及分层的权限控制等


/// 比特币使用基于椭圆曲线加密的椭圆曲线数字签名算法（`ECDSA`）。特定的椭圆曲线称为`secp256k1`，即曲线`y² = x³ + 7`


/// 将根种子作为`HMAC-SHA512`的输入，`Bitcoin seed`为`key`，生成一个`512`位的`Hash`
/// `512`位分成平均分成两部分，左边的`256`位为母私钥，右边的`256`位为链码
///





/// BIP32
public class BIP32 {
    
    public init?(seed: Data) {
        // 验证一下种子，种子是512位，即长度64
        guard seed.count == 64 else { return nil }
        // HMAC-SHA512
        let key: String = "Bitcoin seed"
        guard let keyData = key.data(using: .utf8) else { return nil}
        let hash = HMAC.HMAC(key: [UInt8](keyData), data: [UInt8](seed), algorithmType: .sha512)
        // 生成的hash应该是512位的，做一下验证
        guard hash.count == 64 else { return nil }
        // 左边256位是主秘钥
        let masterPrivateKey = hash[0..<32]
        // 右边256位是主链码
        let masterChainNode = hash[32..<64]
        
        
        
        
    }
}

extension BIP32 {
    
}

extension BIP32 {
    
}

extension BIP32 {
    
}

extension BIP32 {
    
}
