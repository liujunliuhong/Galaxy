//
//  BIP39.swift
//  Galaxy
//
//  Created by galaxy on 2021/5/29.
//

import Foundation

/// 解释一下`位`
/// 一个字节存储`8`位无符号整数，储存的数值范围为`0-255`，即`UInt8`，`2^8`
/// `Swift`中`Data`里面存储的是`16`进制，每两位一组，最大值为`0xFF`，对应`10`进制就是`255`
/// 因此`512位`表示`512 / 8`即`64`的长度


/// BIP39
/// BIP39定义了助记词和种子
/// https://learnblockchain.cn/2018/09/28/hdwallet/



/// `BIP 39`
public struct BIP39 { }

extension BIP39 {
    /// 根据熵生成助记词
    public static func generateMnemonicsFromEntropy(entropy: Data?, language: BIP39Language = .english) -> String? {
        guard let entropy = entropy else { return nil }
        // 熵位数集合
        let binaryEntropyCounts = BIP39MnemonicType.allCases.map{ $0.rawValue }
        // 熵的二进制
        var binaryEntropyDescription = entropy.map { value in
            return value.gl.binaryDescription(separator: "")
        }.joined(separator: "")
        // 判断一下熵的位数
        guard binaryEntropyCounts.contains(binaryEntropyDescription.count) else { return nil }
        guard binaryEntropyDescription.count.isMultiple(of: 8) else { return nil }
        guard binaryEntropyDescription.count.isMultiple(of: 32) else { return nil }
        // 熵的哈希
        let entropyHash = SHA256.sha256(data: entropy)
        // 熵哈希的二进制
        let binaryHashDescription = entropyHash.map { value in
            return value.gl.binaryDescription(separator: "")
        }.joined(separator: "")
        // 校验和，取hash值的前面几位（熵长/32）
        let checkSumStartIndex = binaryHashDescription.startIndex
        let checkSumEndIndex = binaryHashDescription.index(checkSumStartIndex, offsetBy: binaryEntropyDescription.count / 32)
        let checkSum: String = String(binaryHashDescription[checkSumStartIndex..<checkSumEndIndex])
        // 拼接
        binaryEntropyDescription += checkSum
        //
        guard binaryEntropyDescription.count.isMultiple(of: 11) else { return nil }
        //
        var wordList: [String] = []
        // 每11位为一组
        for index in 0..<(binaryEntropyDescription.count / 11) {
            let originIndex = binaryEntropyDescription.startIndex
            let startIndex = binaryEntropyDescription.index(originIndex, offsetBy: 11 * index)
            let endIndex = binaryEntropyDescription.index(originIndex, offsetBy: 11 * index + 11)
            let subBinaryDescription = String(binaryEntropyDescription[startIndex..<endIndex])
            //print(subBinaryDescription)
            // 转换为10进制索引
            guard let languageIndex = Int(subBinaryDescription, radix: 2) else { return nil }
            guard language.words.count >= languageIndex else { return nil }
            let word = language.words[languageIndex]
            //print(word)
            wordList.append(word)
        }
        return wordList.joined(separator: language.separator)
    }
    
    /// 生成助记词
    public static func generateMnemonics(type: BIP39MnemonicType = .m12, language: BIP39Language = .english) -> String? {
        guard type.rawValue.isMultiple(of: 8) else { return nil }
        guard type.rawValue.isMultiple(of: 32) else { return nil }
        // 熵源
        guard let entropy: Data = GL<Data>.randomData(length: type.rawValue / 8) else { return nil }
        return BIP39.generateMnemonicsFromEntropy(entropy: entropy, language: language)
    }
    
    /// 助记词推导出熵源
    public static func mnemonicsToEntropy(mnemonics: String?, language: BIP39Language = .english) -> Data? {
        guard let mnemonics = mnemonics else { return nil }
        //
        let wordList = mnemonics.components(separatedBy: language.separator)
        //
        let mnemonicCounts = BIP39MnemonicType.allCases.map{ $0.mnemonicCount }
        guard mnemonicCounts.contains(wordList.count) else { return nil }
        
        var binaryEntropyDescription: String = ""
        
        // 获取助记词的索引值
        for word in wordList {
            guard let wordIndex = language.words.firstIndex(of: word) else { return nil }
            // 索引值转换为二进制(11位分组)
            binaryEntropyDescription += UInt11.binaryDescription(value: wordIndex)
        }
        
        // x + x/32 = binaryEntropyDescriptions.count
        // 33/32 * x = binaryEntropyDescriptions.count
        // x = binaryEntropyDescriptions.count * 32/33
        
        guard (binaryEntropyDescription.count * 32).isMultiple(of: 33) else { return nil }
        
        // 获取助记词数目类型
        let mnemonicCount: BIP39MnemonicType = BIP39MnemonicType(rawValue: binaryEntropyDescription.count * 32 / 33) ?? .m12
        
        guard mnemonicCount.rawValue.isMultiple(of: 32) else { return nil }
        guard mnemonicCount.rawValue.isMultiple(of: 8) else { return nil }
        
        // 校验和数量
        let checkSumCount = mnemonicCount.rawValue / 32
        
        // 获取校验和，此校验和是熵SHA512的前面几位（熵长/32）
        let checkSumStartIndex = binaryEntropyDescription.index(binaryEntropyDescription.endIndex, offsetBy: -checkSumCount)
        let checkSumEndIndex = binaryEntropyDescription.endIndex
        let checkSum: String = String(binaryEntropyDescription[checkSumStartIndex..<checkSumEndIndex])
        // 获取熵的二进制
        let entropyStartIndex = binaryEntropyDescription.startIndex
        let entropyEndIndex = binaryEntropyDescription.index(entropyStartIndex, offsetBy: binaryEntropyDescription.count-checkSumCount)
        let binaryEntropy = String(binaryEntropyDescription[entropyStartIndex..<entropyEndIndex])
        // 按`UInt8.bitWidth`分组，并得到对应的`UInt8`
        let entropyBytes = binaryEntropy.gl.split(intoChunksOf: UInt8.bitWidth).map { UInt8($0, radix: 2)
        }.compactMap{ $0 }
        // 得到熵源
        let entropyData = Data(entropyBytes)
        // 熵的哈希
        let _entropyHash = SHA256.sha256(data: entropyData)
        // 熵哈希的二进制
        let _binaryHashDescription = _entropyHash.map { value in
            return value.gl.binaryDescription(separator: "")
        }.joined(separator: "")
        // 校验和，取hash值的前面几位（熵长/32）
        let _checkSumStartIndex = _binaryHashDescription.startIndex
        let _checkSumEndIndex = _binaryHashDescription.index(_checkSumStartIndex, offsetBy: checkSumCount)
        let _checkSum: String = String(_binaryHashDescription[_checkSumStartIndex..<_checkSumEndIndex])
        // 判断校验和是否相等
        guard checkSum == _checkSum else { return nil }
        //
        return entropyData
    }
    
    /// 是否是合法的助记词
    public static func isValidMnemonics(mnemonics: String?, language: BIP39Language = .english) -> Bool {
        return BIP39.mnemonicsToEntropy(mnemonics: mnemonics, language: language) != nil
    }
}

extension BIP39 {
    /// 助记词推导出种子(512位)
    public static func seedFromMmemonics(mnemonics: String?, password: String = "", language: BIP39Language = BIP39Language.english) -> Data? {
        guard let mnemonics = mnemonics else { return nil }
        // 验证助记词是否合法
        guard BIP39.isValidMnemonics(mnemonics: mnemonics, language: language) else { return nil }
        // 盐由常量字符串 "mnemonic" 及一个可选的密码组成
        let salt = "mnemonic" + password
        // 密钥延伸函数PBKDF2生成512位种子，循环2048次
        guard let seed = PBKDF2.PBKDF2(input: mnemonics, salt: salt, algorithmType: .sha512, iterationsCount: 2048, dkLen: (512 / 8)) else { return nil }
        return seed
    }
    
    /// 熵源推导出种子(512位)
    static public func seedFromEntropy(entropy: Data?, password: String = "", language: BIP39Language = BIP39Language.english) -> Data? {
        // 先用熵源生成助记词
        guard let mnemonics = BIP39.generateMnemonicsFromEntropy(entropy: entropy, language: language) else { return nil }
        // 助记词推导出种子
        return BIP39.seedFromMmemonics(mnemonics: mnemonics, password: password, language: language)
    }
}
