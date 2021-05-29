//
//  BIP39.swift
//  Galaxy
//
//  Created by galaxy on 2021/5/29.
//

import Foundation
import BigInt

/// 一个字节存储`8`位无符号整数，储存的数值范围为`0-255`，即`UInt8`，`2^8`
/// `Swift`中`Data`里面存储的是`16`进制，每两位一组，最大值为`0xFF`，对应`10`进制就是`255`
/// https://learnblockchain.cn/2018/09/28/hdwallet/


/// `BIP 39`
public struct BIP39 {
    /// 生成助记词
    public static func generateMnemonics(count: BIP39MnemonicCount = .m12, language: BIP39Language = .english) -> String? {
        guard count.rawValue.isMultiple(of: 8) else { return nil }
        guard count.rawValue.isMultiple(of: 32) else { return nil }
        // 熵源
        guard let entropy: Data = GL<Data>.randomData(length: count.rawValue / 8) else { return nil }
        // 熵的哈希
        let entropyHash = SHA256.sha256(data: entropy)
        // 熵的二进制
        var binaryEntropyDescription = entropy.map { value in
            return value.gl.binaryDescription(separator: "")
        }.joined(separator: "")
        // 熵哈希的二进制
        let binaryHashDescription = entropyHash.map { value in
            return value.gl.binaryDescription(separator: "")
        }.joined(separator: "")
        // 校验和，取hash值的前面几位（熵长/32）
        let checkSumStartIndex = binaryHashDescription.startIndex
        let checkSumEndIndex = binaryHashDescription.index(checkSumStartIndex, offsetBy: count.rawValue / 32)
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
    
    /// 助记词推导出熵源
    public static func mnemonicsToEntropy(mnemonics: String?, language: BIP39Language = .english) -> Data? {
        guard let mnemonics = mnemonics else { return nil }
        //
        let wordList = mnemonics.components(separatedBy: language.separator)
        //
        let mnemonicCounts = BIP39MnemonicCount.allCases.map{ $0.mnemonicCount }
        guard mnemonicCounts.contains(wordList.count) else { return nil }
        
        var binaryEntropyDescription: String = ""
        
        // 获取助记词的索引值
        for word in wordList {
            guard let wordIndex = language.words.firstIndex(of: word) else { return nil }
            // 索引值转换为二进制(11位分组)
            binaryEntropyDescription += UInt11(value: Int(wordIndex)).binaryDescription()
        }
        
        // x + x/32 = binaryEntropyDescriptions.count
        // 33/32 * x = binaryEntropyDescriptions.count
        // x = binaryEntropyDescriptions.count * 32/33
        
        guard (binaryEntropyDescription.count * 32).isMultiple(of: 33) else { return nil }
        
        // 获取助记词数目类型
        let mnemonicCount: BIP39MnemonicCount = BIP39MnemonicCount(rawValue: binaryEntropyDescription.count * 32 / 33) ?? .m12
        
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
