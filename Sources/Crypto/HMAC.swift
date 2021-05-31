//
//  HMAC.swift
//  Galaxy
//
//  Created by liujun on 2021/5/31.
//

import Foundation
import CommonCrypto

/// `HMAC`
/// `HMAC`是密钥相关的哈希运算消息认证码（`Hash-based Message Authentication Code`）的缩写
/// `HMAC`算法是一种基于密钥的报文完整性的验证方法
/// 其安全性是建立在`Hash`加密算法基础上的。
/// 它要求通信双方共享密钥、约定算法、对报文进行`Hash`运算，形成固定长度的认证码。
/// 通信双方通过认证码的校验来确定报文的合法性。`HMAC`算法可以用来作加密、数字签名、报文验证等 。


/// digest:摘要


/// HMAC
public struct HMAC {
    /// 算法类型
    public enum AlgorithmType {
        case sha1    /// kCCHmacAlgSHA1
        case md5     /// kCCHmacAlgMD5
        case sha256  /// kCCHmacAlgSHA256
        case sha384  /// kCCHmacAlgSHA384
        case sha512  /// kCCHmacAlgSHA512
        case sha224  /// kCCHmacAlgSHA224
    }
    
    
    /// HMAC
    /// - Parameters:
    ///   - key: key
    ///   - data: data
    ///   - algorithmType: 算法类型
    /// - Returns: 结果
    public static func HMAC(key: [UInt8], data: [UInt8], algorithmType: AlgorithmType) -> Data {
        var key = key
        var data = data
        var result: [UInt8] = Array<UInt8>(repeating: 0x00, count: Int(algorithmType.digestLength()))
        
        CCHmac(CCHmacAlgorithm(algorithmType.algorithmType()),
               &key,
               key.count,
               &data,
               data.count,
               &result)
        
        return Data(result)
    }
}

extension HMAC.AlgorithmType {
    public func algorithmType() -> Int {
        switch self {
        case .sha1:
            return kCCHmacAlgSHA1
        case .md5:
            return kCCHmacAlgMD5
        case .sha256:
            return kCCHmacAlgSHA256
        case .sha384:
            return kCCHmacAlgSHA384
        case .sha512:
            return kCCHmacAlgSHA512
        case .sha224:
            return kCCHmacAlgSHA224
        }
    }
    
    public func digestLength() -> Int32 {
        switch self {
        case .sha1:
            return CC_SHA1_DIGEST_LENGTH
        case .md5:
            return CC_MD5_DIGEST_LENGTH
        case .sha256:
            return CC_SHA256_DIGEST_LENGTH
        case .sha384:
            return CC_SHA384_DIGEST_LENGTH
        case .sha512:
            return CC_SHA512_DIGEST_LENGTH
        case .sha224:
            return CC_SHA224_DIGEST_LENGTH
        }
    }
}
