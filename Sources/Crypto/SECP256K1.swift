//
//  SECP256K1.swift
//  Galaxy
//
//  Created by liujun on 2021/5/31.
//

import Foundation
import secp256k1

/// SECP256K1
/// 比特币使用基于椭圆曲线加密的椭圆曲线数字签名算法（`ECDSA`）
/// 特定的椭圆曲线称为`secp256k1`，即曲线`y² = x³ + 7`



/// SECP256K1
public struct SECP256K1 {
    private static let context = secp256k1_context_create(UInt32(SECP256K1_CONTEXT_SIGN | SECP256K1_CONTEXT_VERIFY))
}

extension SECP256K1 {
    
}

