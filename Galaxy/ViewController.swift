//
//  ViewController.swift
//  Galaxy
//
//  Created by galaxy on 2021/5/28.
//

import UIKit
import web3swift
import CryptoSwift
import BigInt

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        
        //test()
        let result1 = BIP39.generateMnemonics(type: .m12, language: .english)
        let result2 = BIP39.generateMnemonics(type: .m15, language: .english)
        let result3 = BIP39.generateMnemonics(type: .m18, language: .english)
        let result4 = BIP39.generateMnemonics(type: .m21, language: .english)
        let result5 = BIP39.generateMnemonics(type: .m24, language: .english)
        print(result1)
        print(result2)
        print(result3)
        print(result4)
        print(result5)
        
        let isValid1 = BIP39.isValidMnemonics(mnemonics: result1)
        let isValid2 = BIP39.isValidMnemonics(mnemonics: result2)
        let isValid3 = BIP39.isValidMnemonics(mnemonics: result3)
        let isValid4 = BIP39.isValidMnemonics(mnemonics: result4)
        let isValid5 = BIP39.isValidMnemonics(mnemonics: result5)
        print("isValid1: \(isValid1)")
        print("isValid2: \(isValid2)")
        print("isValid3: \(isValid3)")
        print("isValid4: \(isValid4)")
        print("isValid5: \(isValid5)")
        
        let input = "韩打算"
        let salt = "我退热奥拓已森，发送"
        
        guard let result = PBKDF2.PBKDF2(input: input, salt: salt, algorithmType: .sha512, iterationsCount: 2048, dkLen: 64) else { return }
        print(result.gl.toHexString)
        
        let s = try? CryptoSwift.PKCS5.PBKDF2(password: [UInt8](input.data(using: .utf8)!),
                                              salt: [UInt8](salt.data(using: .utf8)!),
                                              iterations: 2048,
                                              keyLength: 64,
                                              variant: HMAC.Variant.sha512).calculate()
        print(s?.gl.bytesToHexString)
        
        // a1d687f158c0e2f08a065d5a82a06f5ca16d995c0a1783b16e3147367c9a467a09529571c5fee3519ab4a3172cfdc59026e57ba4bf0457a1de0f62fa85605d77
        
    }


}

extension ViewController {
    func test() {
        // 熵的位数
        let bitsOfEntropy: Int = 128
        // 熵
        let entropy: Data = GL<Data>.randomData(length: bitsOfEntropy/8)!
        // 哈希
        let hash = SHA256.sha256(data: entropy)
        // 熵的二进制
        var binaryEntropyDescription = entropy.map { value in
            return value.gl.binaryDescription(separator: "")
        }.joined(separator: "")
        // 哈希的二进制
        let binaryHashDescription = hash.map { value in
            return value.gl.binaryDescription(separator: "")
        }.joined(separator: "")
        // 取hash值的前面几位（熵长/32）
        let checkSumStartIndex = binaryHashDescription.startIndex
        let checkSumEndIndex = binaryHashDescription.index(checkSumStartIndex, offsetBy: bitsOfEntropy/32)
        let checkSum: String = String(binaryHashDescription[checkSumStartIndex..<checkSumEndIndex])
        // 拼接
        binaryEntropyDescription += checkSum
        
        // 每11位为一组
        for index in 0..<binaryEntropyDescription.count/11 {
            let originIndex = binaryHashDescription.startIndex
            let startIndex = binaryHashDescription.index(originIndex, offsetBy: 11*index)
            let endIndex = binaryHashDescription.index(startIndex, offsetBy: 11)
            let subBinaryDescription = String(binaryHashDescription[startIndex..<endIndex])
            //print(subBinaryDescription)
            
            //print(Int(subBinaryDescription, radix: 2))
            
            print(BIP39Language.english.words[Int(subBinaryDescription, radix: 2)!])
        }
        
        print(binaryHashDescription)
        //print(binaryEntropyDescription)
        print("😁")
//        print(Int8(truncatingIfNeeded: 257))
        print(UInt8(11).gl.binaryDescription())
//        let bits = entropy.map { (value) -> BigUInt in
//            return BigUInt(UInt8(value), radix: 2)!
//        }
//        print(bits)
        
        entropy.map { (value) -> Void in
            let bitsString: String = UInt8(value).bits()
//            print(bitsString)
            //print(UInt8(value))
//            print(BigUInt("\(value)", radix: 2))
//            print(String(BigUInt(UInt8(value)), radix: 2))
//            print(String(13242, radix: 2))
        }
        
        
        
//        print("😄\(entropy?.count)")
        
        // 128 - 16
        // 192 - 24
        
//        let entropy = GL<Data>.randomData(length: 2)!
//
//        let y = hash[0..<(entropy.count/32)]
//
//        let newData = entropy + y
//
//        let s: String = UInt8(255).bits()
//
//        for index in 0..<(newData.count/11) {
//
//            let subData = newData[(index*11)..<(index*11+11)]
//            let sss = subData.map { (x) -> String in
//                return x.bits()
//            }
//            var newString = sss.joined(separator: "")
//            newString = newString.replacingOccurrences(of: " ", with: "")
//            print(newString)
//
//            let wordIndex = BigUInt(newString, radix: 2)!
//
//            print(wordIndex)
//            print("😄")
//            //print(BIP39Language.english.words[wordIndex])
//        }
    }
}

