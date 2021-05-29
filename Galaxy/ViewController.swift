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
        
        
        test()
    }


}

extension ViewController {
    func test() {
        let bitsOfEntropy: Int = 128
        // 熵
        let entropy = Data.randomBytes(length: bitsOfEntropy/8)!
        // 哈希
        let hash = entropy.sha256()
        
//        print(Int8(truncatingIfNeeded: 257))
        print(UInt8(11).gl.binaryDescription)
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

