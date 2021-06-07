//
//  BIP32.swift
//  Galaxy
//
//  Created by galaxy on 2021/5/30.
//

import Foundation
import BigInt

/// BIP32
/// 分层确定性钱包（`Hierarchical Deterministic wallet`） (`HD Wallet`)
/// 从单一个`seed`产生一树状结构储存多组私钥和公钥
/// 好处是可以方便的备份、转移到其他相容装置（因为都只需要`seed`），以及分层的权限控制等


/// 比特币使用基于椭圆曲线加密的椭圆曲线数字签名算法（`ECDSA`）。特定的椭圆曲线称为`secp256k1`，即曲线`y² = x³ + 7`


/// 将根种子作为`HMAC-SHA512`的输入，`Bitcoin seed`为`key`，生成一个`512`位的`Hash`
/// `512`位分成平均分成两部分，左边的`256`位为母私钥，右边的`256`位为链码


/// 原始`16`进制私钥`P`：`1e99423a4ed27608a15a2616a2b0e9e52ced330ac530edcc32c8ffc6a526aedd`
/// 1.将原始`16`进制编码为`Base58Check`：`Base58Check(version + P)`
/// 2.将“压缩”的私钥编码为`Base58Check`，要将后缀`01`附加到十六进制密钥后面：`Base58Check(version + P + 01)` = `WIF`


/// WIF：Wallet Import Format
/// 术语`压缩私钥`实际上是指`只能从私钥导出压缩的公钥`，而`未压缩的私钥`实际上是指`只能从私钥导出未压缩的公钥`


/// 公钥的格式
/// 公钥也能以不同的方式呈现，通常是`compressed`或`uncompressed`公钥
/// 公钥是由一对坐标（x，y）组成的椭圆曲线上的一个点。
/// 它通常带有前缀`04`，后跟两个`256`位数字：一个是该点的`x`坐标，另一个是`y`坐标
/// 前缀`04`表示未压缩的公钥，`02`或`03`开头表示压缩的公钥


/// 压缩的公钥
/// 压缩公钥被引入到比特币中，以减少交易处理的大小并节省存储空间。
/// 大多数交易包括公钥，这是验证所有者凭证并花费比特币所需的。
/// 每个公钥需要`520`位（ 前缀 + x + y ），每个块有几百个交易，每天产生千上万的交易时，会将大量数据添加到区块链中。
/// 正如我们在公钥看到的那样，公钥是椭圆曲线上的一个点（x，y）。
/// 因为曲线表达了一个数学函数，所以曲线上的一个点代表该方程的一个解，
/// 因此，如果我们知道`x`坐标，我们可以通过求解方程来计算`y`坐标. `y2 mod p =（ x3 + 7 ）mod p`
/// 这允许我们只存储公钥的`x`坐标，省略`y`坐标并减少密钥的大小和所需的256位空间
/// 在每次交易中，几乎减少了`50％`的尺寸，加起来可以节省大量的数据！
/// 未压缩的公钥的前缀为`04`，压缩的公钥以`02`或`03`前缀开头。


/***************************************************************************
 Type                         Version prefix (hex)    Base58 result prefix
 Bitcoin Address                   0x00                      1
 Pay-to-Script-Hash Address        0x05                      3
 Bitcoin Testnet Address           0x6F                    m or n
 Private Key WIF                   0x80                  5, K, or L
 BIP-38 Encrypted Private Key     0x0142                     6P
 BIP-32 Extended Public Key     0x0488B21E                  xpub
 *****************************************************************************/


/// 创建比特币地址的完整过程：从私钥到公钥（椭圆曲线上的一个点），再到双重哈希地址，最后是`Base58Check`编码
/// https://github.com/inoutcode/bitcoin_book_2nd/blob/master/%E7%AC%AC%E5%9B%9B%E7%AB%A0.asciidoc#pubkey


/// 扩展密钥由私钥或公钥和链码组成
/// `拓展秘钥 = 私钥 + 链码`或者`拓展秘钥 = 公钥 + 链码`
/// 扩展密钥简单地表示为由`256`位的密钥和`256`位的链码串联成的`512`位序列。
/// 有两种类型的扩展密钥：
/// 1.`扩展私钥`是私钥和链码的组合，可用于派生子私钥（从它们产生子公钥）
/// 2.`扩展公钥`是公钥和链码，可用于创建子公钥（ 只有子公钥 ）
/// `扩展私钥`可以创建一个完整的分支，而`扩展公钥`只能创建一个公钥分支。



/// 子私钥的派生
/// 使用派生的子密钥
/// 扩展密钥
/// 子公钥派生

/// 在派生函数中使用的索引号是一个`32`位整数
/// 为了便于区分`通过常规推导函数派生的密钥`与`通过强化派生派生的密钥`，该索引号分为两个范围。
/// `0`到`2^31 - 1`（`0x0`到`0x7FFFFFFF`）之间的索引号仅用于常规推导
/// `2^31`和`2^32 - 1`（`0x80000000`到0xFFFFFFFF`）之间的索引号仅用于硬化派生
/// 因此，如果索引号小于`2^31`，则子密钥是常规的，而如果索引号等于或大于`2^31`，则子密钥是强化派生的。
/// 为了使索引号码更容易阅读和显示，`强化子密钥的索引号从零开始`显示，但带有一个符号
/// 第一个常规子密钥表示成`0`，第一个强化子秘钥（索引号是`0x80000000`）表示成`0'`
/// 以此类推，第二个强化子密钥（`0x80000001`) 表示成`1'`
/// 当你看到`HD`钱包索引`i'`时，它表示231+i.


/// 从主密钥派生的私钥以`m`开头
/// 从主公钥派生的公钥以`M`开始
/// 主私钥的第一个子私钥为`m/0`，第一个子私钥的第二个子私钥是`m/0/1`，依此类推
/// 第一个子公钥是`M/0`
/// https://github.com/inoutcode/bitcoin_book_2nd/blob/master/%E7%AC%AC%E4%BA%94%E7%AB%A0.asciidoc
/// https://github.com/bitcoin/bips/blob/master/bip-0032.mediawiki#child-key-derivation-ckd-functions




/// BIP32
public class BIP32 {
    
    public enum ExtendedVersion: String {
        case mainnetPublicVersion    = "0x0488B21E"
        case mainnetPrivateVersion   = "0x0488ADE4"
        case testnetPublicVersion    = "0x043587CF"
        case testnetPrivateVersion   = "0x04358394"
    }
    
    /// 未压缩的私钥
    public private(set) var uncompressedPrivateKey: Data?
    
    /// 压缩的公钥
    public private(set) var compressedPublicKey: Data
    
    /// 链码
    public private(set) var chainCode: Data
    
    /// 深度
    public private(set) var depth: UInt8 = 0
    
    /// 真实索引
    public private(set) var trueIndex: UInt32 = 0
    
    /// path
    public private(set) var path: String = "m"
    
    /// 指纹
    public private(set) var parentFingerprint: Data = Data(repeating: 0, count: 4)
    
    /// 压缩的私钥
    public var compressedPrivateKey: Data? {
        guard let uncompressedPrivateKey = uncompressedPrivateKey else { return nil }
        var bytes = uncompressedPrivateKey.gl.bytes
        bytes.append(UInt8(0x01))
        return Data(bytes)
    }
    
    /// 未压缩的公钥
    public var uncompressedPublicKey: Data? {
        return SECP256K1.privateKeyToPublicKey(privateKey: uncompressedPrivateKey, compressed: false)
    }
    
    /// 是否是强化派生
    public var isHardened:Bool {
        return self.trueIndex >= hardenedStartIndex
    }
    
    
    /// 硬化派生后缀
    private let hardenedSuffix = "'"
    /// 硬化派生开始索引
    private let hardenedStartIndex: UInt32 = UInt32(1) << 31
    /// secp256k1 order
    private let curveOrder = BigUInt("FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141", radix: 16)!
    /// seed hamc key
    private let seedKey = "Bitcoin seed"
    
    
    
    public init() {
        self.uncompressedPrivateKey = nil
        self.compressedPublicKey = Data()
        self.chainCode = Data()
        self.depth = 0
        self.trueIndex = 0
        self.parentFingerprint = Data(repeating: 0, count: 4)
    }
    
    
    /// 根据种子初始化
    /// - Parameter seed: 种子
    public init?(seed: Data) {
        // 验证一下种子，种子是512位，即长度64
        guard seed.count == 64 else { return nil }
        // HMAC-SHA512
        guard let keyData = seedKey.data(using: .utf8) else { return nil}
        let hash = HMAC.HMAC(key: [UInt8](keyData), data: [UInt8](seed), algorithmType: .sha512)
        // 生成的hash应该是512位的，做一下验证
        guard hash.count == 64 else { return nil }
        // 左边256位是主秘钥
        let I_L = hash[0..<32]
        // 右边256位是主链码
        let I_R = hash[32..<64]
        // 私钥是否合法
        guard SECP256K1.isValidPrivateKey(privateKey: I_L) else { return nil }
        // 根据私钥生成压缩公钥
        guard let publicKey = SECP256K1.privateKeyToPublicKey(privateKey: I_L, compressed: true) else { return nil }
        // 压缩的公钥是0x02或者0x03开头
        guard publicKey[0] == 0x02 || publicKey[0] == 0x03 else { return nil }
        //
        self.uncompressedPrivateKey = I_L
        self.chainCode = I_R
        self.compressedPublicKey = publicKey
        self.depth = 0
        self.trueIndex = 0
        self.parentFingerprint = Data(repeating: 0, count: 4)
    }
    
    /// 根据`扩展秘钥`初始化
    /// - Parameter extendedKeyData: 扩展秘钥
    ///
    /// 4 byte: version bytes (mainnet: 0x0488B21E public, 0x0488ADE4 private; testnet: 0x043587CF public, 0x04358394 private)
    /// 1 byte: depth: 0x00 for master nodes, 0x01 for level-1 derived keys, ....
    /// 4 bytes: the fingerprint of the parent's key (0x00000000 if master key)
    /// 4 bytes: child number. This is ser32(i) (0x00000000 if master key)
    /// 32 bytes: the chain code
    /// 33 bytes: the public key or private key data (serP(K) for public keys, 0x00 || ser256(k) for private keys)
    /// This 78 byte structure can be encoded like other Bitcoin data in Base58, by first adding 32 checksum bits (derived from the double SHA-256 checksum), and then converting to the Base58 representation. This results in a Base58-encoded string of up to 112 characters. Because of the choice of the version bytes, the Base58 representation will start with "xprv" or "xpub" on mainnet, "tprv" or "tpub" on testnet.
    public init?(extendedKeyData: Data) {
        if extendedKeyData.count < 78 || extendedKeyData.count > 82 { return nil }
        let version = extendedKeyData[0..<4].gl.toHexString.gl.add0xHexPrefix
        let depth = extendedKeyData[4]
        let parentFingerprint = extendedKeyData[5..<9]
        let index = UInt32(extendedKeyData[9..<13].gl.toHexString, radix: 16)!
        let chainCode = extendedKeyData[13..<45]
        
        var privateKey: Data?
        var publicKey: Data = Data()
        
        if version == ExtendedVersion.mainnetPrivateVersion.rawValue || version == ExtendedVersion.testnetPublicVersion.rawValue {
            let privateKeyPrefix = extendedKeyData[45]
            guard privateKeyPrefix == 0x00 else { return nil }
            privateKey = extendedKeyData[46..<78]
            guard let tmpPublicKey = SECP256K1.privateKeyToPublicKey(privateKey: privateKey, compressed: true) else { return nil }
            publicKey = tmpPublicKey
        } else if version == ExtendedVersion.mainnetPrivateVersion.rawValue || version == ExtendedVersion.testnetPrivateVersion.rawValue {
            publicKey = extendedKeyData[45..<78]
        }
        if extendedKeyData.count == 82 {
            // 有校验和
            var hash = extendedKeyData[0..<78]
            hash = SHA256.sha256(data: hash)
            hash = SHA256.sha256(data: hash)
            let checkSum = hash[0..<4]
            if checkSum != extendedKeyData[78..<82] { return nil }
        }
        self.uncompressedPrivateKey = privateKey
        self.compressedPublicKey = publicKey
        self.chainCode = chainCode
        self.depth = depth
        self.parentFingerprint = parentFingerprint
        self.trueIndex = index
    }
}


extension BIP32 {
    public func derive(path: String?) -> BIP32? {
        guard var path = path else { return nil }
        // 判断
        if path == "m" || path == "/" || path == "" {
            return self
        }
        // 去除前面的'm/'
        if path.hasPrefix("m/") {
            path = String(path[path.index(path.startIndex, offsetBy: 2)...])
        }
        // 分组
        let components = path.components(separatedBy: "/")
        // 定义临时变量
        var current: BIP32 = self
        // for循环
        for chunk in components {
            if chunk.count == 0 { continue }
            // 判断是否是强化派生
            var hardened = false
            if chunk.hasSuffix(hardenedSuffix) { hardened = true }
            // 转换为32位索引
            guard let index = UInt32(chunk.trimmingCharacters(in: CharacterSet(charactersIn: hardenedSuffix))) else { return nil }
            // 开始派生
            guard let newNode = current.derived(at: index, hardened: hardened) else { return nil }
            // 赋值
            current = newNode
        }
        return current
    }
    
    public func derived(at index: UInt32, hardened: Bool) -> BIP32? {
        // 检查
        guard depth < UInt8.max else { return nil }
        if hardened && uncompressedPrivateKey == nil { return nil }
        // 索引值做个判断
        // 0到2^31-1（0x0到0x7FFFFFFF）之间的索引号仅用于常规推导
        // 2^31到2^32-1（0x80000000到0xFFFFFFFF）之间的索引号仅用于硬化派生
        var trueIndex: UInt32 = index
        if hardened && index < hardenedStartIndex {
            trueIndex = trueIndex + hardenedStartIndex
        } else if !hardened && index >= hardenedStartIndex {
            trueIndex = index - hardenedStartIndex
        }
        //
        if uncompressedPrivateKey == nil {
            if trueIndex >= hardenedStartIndex || hardened {
                return nil
            }
        }
        // 判断下trueIndex
        guard trueIndex < UInt32.max else { return nil }
        // 把32位索引值序列化为UInt8数组
        let indexBytes = trueIndex.gl.serialize(to: UInt8.self, keepLeadingZero: true)
        //
        var inputForHMAC: Data = Data()
        //
        if hardened {
            // 如果是强化派生
            inputForHMAC.append(0x00)
            inputForHMAC.append(uncompressedPrivateKey!)
        } else {
            // 如果是常规派生
            inputForHMAC.append(compressedPublicKey)
        }
        inputForHMAC.append(Data(indexBytes))
        // HMAC-SHA512
        let hash = HMAC.HMAC(key: [UInt8](chainCode), data: [UInt8](inputForHMAC), algorithmType: .sha512)
        // 生成的hash应该是512位的，做一下验证
        guard hash.count == 64 else { return nil }
        //
        let I_L = hash[0..<32]
        let I_R = hash[32..<64]
        //
        let _I_L = BigUInt(I_L)
        // 检查
        if _I_L > curveOrder {
            if trueIndex < UInt32.max {
                return derived(at: index + 1, hardened: hardened)
            } else {
                return nil
            }
        }
        //
        var privateKeyCandidate = _I_L
        if uncompressedPrivateKey != nil {
            privateKeyCandidate = (_I_L + BigUInt(uncompressedPrivateKey!)) % curveOrder
            if privateKeyCandidate == BigUInt(0) {
                if trueIndex < UInt32.max {
                    return derived(at: index + 1, hardened: hardened)
                } else {
                    return nil
                }
            }
        }
        //
        let newPrivateKeyBytes = privateKeyCandidate.gl.serialize(to: UInt8.self, keepLeadingZero: true)
        let newPrivateKey = Data(newPrivateKeyBytes)
        // 验证私钥是否合法
        guard SECP256K1.isValidPrivateKey(privateKey: newPrivateKey) else { return nil }
        // 根据私钥生成压缩公钥
        guard let newPublicKey = SECP256K1.privateKeyToPublicKey(privateKey: newPrivateKey, compressed: true) else { return nil }
        // 压缩的公钥是0x02或者0x03开头
        guard newPublicKey[0] == 0x02 || newPublicKey[0] == 0x03 else { return nil }
        // 获取指纹（取前4位）
        let ripemdHash = RIPEMD160.hash(message: SHA256.sha256(data: newPublicKey))
        guard ripemdHash.count >= 4 else { return nil }
        let fingerprint = ripemdHash[0..<4]
        //
        let newNode = BIP32()
        newNode.depth = depth + 1
        newNode.trueIndex = trueIndex
        newNode.parentFingerprint = fingerprint
        newNode.chainCode = Data(I_R)
        // 生成path
        var newPath = path
        if trueIndex >= hardenedStartIndex {
            newPath = newPath + "/"
            newPath = newPath + "\(trueIndex % hardenedStartIndex)"
            newPath = newPath + hardenedSuffix
        } else {
            newPath = newPath + "/"
            newPath = newPath + "\(trueIndex)"
        }
        newNode.path = newPath
        // 秘钥赋值
        if uncompressedPrivateKey != nil {
            // 如果私钥存在
            newNode.uncompressedPrivateKey = newPrivateKey
            newNode.compressedPublicKey = newPublicKey
        } else {
            // 如果私钥不存在
            newNode.uncompressedPrivateKey = nil
            guard let _newPublicKey = SECP256K1.combineSerializedPublicKeys(keys: [compressedPublicKey, newPublicKey], compressed: true) else { return nil }
            guard _newPublicKey[0] == 0x02 || _newPublicKey[0] == 0x03 else { return nil }
            newNode.compressedPublicKey = _newPublicKey
        }
        return newNode
    }
}

extension BIP32 {
    public func extendedKeyString(extendedPublic: Bool, extendedVersion: ExtendedVersion) -> String? {
        guard let data = extendedKeyData(extendedPublic: extendedPublic, extendedVersion: extendedVersion) else { return nil }
        return Base58.base58Encoded(data: data).gl.toHexString
    }
    
    public func extendedKeyData(extendedPublic: Bool, extendedVersion: ExtendedVersion) -> Data? {
        // 检查
        if !extendedPublic && uncompressedPrivateKey == nil { return nil }
        //
        var data: Data = Data()
        // append version
        guard let extendedVersionData = extendedVersion.rawValue.gl.toHexData else { return nil }
        data.append(extendedVersionData)
        // append depth
        data.append(depth)
        // append parentFingerprint
        data.append(parentFingerprint)
        // append index
        let indexBytes = trueIndex.gl.serialize(to: UInt8.self, keepLeadingZero: true)
        data.append(contentsOf: indexBytes)
        // append chain code
        data.append(chainCode)
        // append key
        if extendedPublic {
            data.append(compressedPublicKey)
        } else {
            data.append(0x00)
            data.append(uncompressedPrivateKey!)
        }
        // append check sum
        var hash = SHA256.sha256(data: data)
        hash = SHA256.sha256(data: hash)
        let checkSum = hash[0..<4]
        data.append(checkSum)
        // 最终数据长度为82
        guard data.count == 82 else { return nil }
        return data
    }
}

extension BIP32 {
    /// 生成WIF
    public func WIF(prefix: String, compressed: Bool) -> String? {
        guard let prefixData = prefix.gl.toHexData else { return nil }
        if compressed {
            // 压缩的私钥生成压缩的公钥
            guard let compressedPrivateKey = compressedPrivateKey else { return nil }
            let result = Base58.base58CheckEncoded(prefix: prefixData, data: compressedPrivateKey)
            return String(data: result, encoding: .utf8)
        } else {
            // 未压缩的私钥生成未压缩的公钥
            guard let uncompressedPrivateKey = uncompressedPrivateKey else { return nil }
            let result = Base58.base58CheckEncoded(prefix: prefixData, data: uncompressedPrivateKey)
            return String(data: result, encoding: .utf8)
        }
    }
}
