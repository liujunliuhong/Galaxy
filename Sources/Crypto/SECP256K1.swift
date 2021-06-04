//
//  SECP256K1.swift
//  Galaxy
//
//  Created by liujun on 2021/5/31.
//

import Foundation
/// Hash
/// Hash，一般翻译做散列、杂凑，或音译为哈希
/// 是把任意长度的输入（又叫做预映射pre-image）通过散列算法变换成固定长度的输出，该输出就是散列值。
/// 这种转换是一种压缩映射，也就是，散列值的空间通常远小于输入的空间，不同的输入可能会散列成相同的输出，
/// 所以不可能从散列值来确定唯一的输入值。
/// 简单的说就是一种将任意长度的消息压缩到某一固定长度的消息摘要的函数。




/// `ECDSA`（`Elliptic Curve Digital Signature Algorithm`）
/// 椭圆曲线数字签名算法  `y² = (x³ + a.x + b) mod p`
/// `ECDSA`用于对数据（比如一个文件）创建数字签名，以便于你在不破坏它的安全性的前提下对它的真实性进行验证。
/// 可以将它想象成一个实际的签名，你可以识别部分人的签名，但是你无法在别人不知道的情况下伪造它。
/// 而`ECDSA`签名和真实签名的区别在于，伪造`ECDSA`签名是根本不可能的
/// 你不应该将`ECDSA`与用来对数据进行加密的`AES`（高级加密标准）相混淆。
/// `ECDSA`不会对数据进行加密、或阻止别人看到或访问你的数据，它可以防止的是确保数据没有被篡改
/// `R = k * P`的性质，已知`R`与`P`的值，无法推出`k`的值, 而知道`k`值于`P`值是很容易计算`R`值。这是`ECDSA`签名算法的理论基础
/// https://zhuanlan.zhihu.com/p/97953640






/// SECP256K1
/// 比特币使用基于椭圆曲线加密的椭圆曲线数字签名算法（`ECDSA`）
/// 特定的椭圆曲线称为`secp256k1`，即曲线`y² = x³ + 7`



/// 椭圆曲线乘法是密码学家称为“陷阱门”的一种函数：在一个方向（乘法）很容易做到，而在相反方向（除法）不可能做到。
/// 私钥的所有者可以很容易地创建公钥，然后与世界共享，因为知道没有人能够反转该函数并从公钥计算私钥。
/// 这种数学技巧成为证明比特币资金所有权的不可伪造且安全的数字签名的基础。
/// http://www.secg.org/sec2-v2.pdf


/// SECP256K1
public struct SECP256K1 {
//    private static let context = secp256k1_context_create(UInt32(SECP256K1_CONTEXT_SIGN | SECP256K1_CONTEXT_VERIFY))
}

extension SECP256K1 {
    func asdas() {
        
    }
}
