//
//  BIP32.swift
//  Galaxy
//
//  Created by galaxy on 2021/5/30.
//

import Foundation


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
        // 用主私钥生成主公钥
        
        
        
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
