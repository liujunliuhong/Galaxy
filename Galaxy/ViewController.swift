//
//  ViewController.swift
//  Galaxy
//
//  Created by galaxy on 2021/5/28.
//

import UIKit
import CryptoSwift
import BigInt


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        
        
//        test()
//        let result1 = BIP39.generateMnemonics(type: .m12, language: .english)
//        let result2 = BIP39.generateMnemonics(type: .m15, language: .english)
//        let result3 = BIP39.generateMnemonics(type: .m18, language: .english)
//        let result4 = BIP39.generateMnemonics(type: .m21, language: .english)
//        let result5 = BIP39.generateMnemonics(type: .m24, language: .english)
//        print(result1)
//        print(result2)
//        print(result3)
//        print(result4)
//        print(result5)
//
//        let isValid1 = BIP39.isValidMnemonics(mnemonics: result1)
//        let isValid2 = BIP39.isValidMnemonics(mnemonics: result2)
//        let isValid3 = BIP39.isValidMnemonics(mnemonics: result3)
//        let isValid4 = BIP39.isValidMnemonics(mnemonics: result4)
//        let isValid5 = BIP39.isValidMnemonics(mnemonics: result5)
//        print("isValid1: \(isValid1)")
//        print("isValid2: \(isValid2)")
//        print("isValid3: \(isValid3)")
//        print("isValid4: \(isValid4)")
//        print("isValid5: \(isValid5)")
        
        
//        guard let mnemonics = BIP39.generateMnemonics(type: .m12, language: .english) else {
//            return
//        }
        
        
        //BTCRequest.getUnspentTransactionOutputsWithAddresses(addresses: ["1CBtcGivXmHQ8ZqdPgeMfcpQNJrqTrSAcG"])
//        let data = "hellohellohello".data(using: .utf8)!
//        print(data as NSData)
//        let range: ClosedRange<Int> = 14...14
//        print(range.lowerBound)
//        print(range.upperBound)
//        print(data[range] as NSData)
        
        
//        print("bigEndian: \(value.bigEndian)")
//        print("littleEndian: \(value.littleEndian)")
//        print(value.gl.littleEndianSerialize(to: UInt8.self))
//        print(value.gl.bigEndianSerialize(to: UInt8.self))
//
//        print(CFByteOrderGetCurrent() == CFByteOrderLittleEndian.rawValue)
//
//        let scriptData = NSMutableData()
//
//        var len = CFSwapInt16HostToLittle(value);
//        scriptData.append(&len, length: MemoryLayout.size(ofValue: len))
//        print((scriptData as Data).gl.bytes)
        
//        print(value.gl.littleEndianSerialize(to: UInt32.self))
//        print(value.gl.bigEndianSerialize(to: UInt32.self))
//        print(UInt32.max)
        //let _ = Test()
        
        //print(Int(UInt8(0xff)) << 8)
        
//        let str = "00abadaeaf"
//        let bytes = str.gl.toHexData?.gl.bytes ?? []
//        print(bytes)
//
//        let range = 0...4
//        print(bytes[range])
//
//
//        let dataLength: UInt32 = UInt32(bytes[4]) << 24 + UInt32(bytes[3]) << 16 + UInt32(bytes[2]) << 8 + UInt32(bytes[1])
//        print(dataLength)
//        print(dataLength.gl.littleEndianSerialize(to: UInt8.self))
        
//        var rt: Data = Data()
//        let str = "1"
//        let data = str.data(using: .utf8)!
//        let len = UInt8(data.count)
//        rt.append(Data(len.gl.bigEndianSerialize(to: UInt8.self)))
//        print(rt as NSData)
//        print(MemoryLayout.size(ofValue: len))
        // 0000 0000 0000 0000      0000 0000 0000 1010
        
        // 1010 0000 0000 0000
        
        
//        let path = "m/49'/0'/0'/0/0"
//        let mnemonics = "monkey pencil polar hand mimic trouble voice suit sunset fabric chief left"
//
//        print("mnemonics: \(mnemonics)")
//        print("😄😄😄😄😄😄😄😄😄😄😄😄😄😄")
//        guard let seed = BIP39.seedFromMmemonics(mnemonics: mnemonics) else {
//            return
//        }
//        print("seed: \(seed.gl.toHexString)")
//        print("😄😄😄😄😄😄😄😄😄😄😄😄😄😄")
//        guard let ethNode = BIP32(seed: seed)?.derive(path: path) else { return }
//
//        print("uncompressedPrivateKey: \(ethNode.uncompressedPrivateKey?.gl.toHexString ?? "nil")")
//        print("compressedPrivateKey: \(ethNode.compressedPrivateKey?.gl.toHexString ?? "nil")")
//        print("compressedPublicKey: \(ethNode.compressedPublicKey.gl.toHexString)")
//        print("uncompressedPublicKey: \(ethNode.uncompressedPublicKey?.gl.toHexString ?? "nil")")
//        print("depth: \(ethNode.depth)")
//        print("trueIndex: \(ethNode.trueIndex)")
//        print("parentFingerprint: \(ethNode.parentFingerprint.gl.toHexString)")
//        print("chainCode: \(ethNode.chainCode.gl.toHexString)")
//        print("path: \(ethNode.path)")
//
//        print("😄😄😄😄😄😄😄😄😄😄😄😄😄😄")
//        guard let extendedPrivateKeyString = ethNode.extendedPrivateKeyString(versionType: .segregatedWitness, isMainNet: true) else { return }
//        guard let extendedPublicKeyString = ethNode.extendedPublicKeyString(versionType: .segregatedWitness, isMainNet: true) else { return }
//        print("扩展私钥: \(extendedPrivateKeyString)")
//        print("扩展公钥: \(extendedPublicKeyString)")
//
//
//        print("😄😄😄😄😄😄😄😄😄😄😄😄😄😄")
//        let extendedPrivateNode = BIP32(extendedKeyString: extendedPrivateKeyString)
//        print("扩展私钥 - uncompressedPrivateKey: \(extendedPrivateNode?.uncompressedPrivateKey?.gl.toHexString ?? "nil")")
//        print("扩展私钥 - compressedPrivateKey: \(extendedPrivateNode?.compressedPrivateKey?.gl.toHexString ?? "nil")")
//        print("扩展私钥 - uncompressedPublicKey: \(extendedPrivateNode?.uncompressedPublicKey?.gl.toHexString ?? "nil")")
//        print("扩展私钥 - compressedPublicKey: \(extendedPrivateNode?.compressedPublicKey.gl.toHexString ?? "nil")")
//
//
//        print("😄😄😄😄😄😄😄😄😄😄😄😄😄😄")
//        let extendedPublicKeyNode = BIP32(extendedKeyString: extendedPublicKeyString)
//        print("扩展公钥 - uncompressedPrivateKey: \(extendedPublicKeyNode?.uncompressedPrivateKey?.gl.toHexString ?? "nil")")
//        print("扩展公钥 - compressedPrivateKey: \(extendedPublicKeyNode?.compressedPrivateKey?.gl.toHexString ?? "nil")")
//        print("扩展公钥 - uncompressedPublicKey: \(extendedPublicKeyNode?.uncompressedPublicKey?.gl.toHexString ?? "nil")")
//        print("扩展公钥 - compressedPublicKey: \(extendedPublicKeyNode?.compressedPublicKey.gl.toHexString ?? "nil")")
////
//
//        print("😄😄😄😄😄😄😄😄😄😄😄😄😄😄")
//        let btc = BTC(bip32: ethNode)
//        print("btc compressedAddress: \(btc.compressedAddress ?? "")")
//        print("btc uncompressedAddress: \(btc.uncompressedAddress ?? "")")
//        print("btc compressedWIF: \(btc.compressedWIF ?? "")")
    }
}


//extension ViewController {
//    func test() {
//        let path = "m/44'/0'/0'/0"
//        let mnemonics = "monkey pencil polar hand mimic trouble voice suit sunset fabric chief left"
//
//        print("mnemonics: \(mnemonics)")
//        print("😄😄😄😄😄😄😄😄😄😄😄😄😄😄")
//        guard let seed = BIP39.seedFromMmemonics(mnemonics: mnemonics) else {
//            return
//        }
//        print("seed: \(seed.gl.toHexString)")
//        print("😄😄😄😄😄😄😄😄😄😄😄😄😄😄")
//
//        guard let bip = BIP32(seed: seed) else { return }
//        print("root uncompressedPrivateKey: \(bip.uncompressedPrivateKey?.gl.toHexString ?? "nil")")
//        print("root compressedPrivateKey: \(bip.compressedPrivateKey?.gl.toHexString ?? "nil")")
//        print("root compressedPublicKey: \(bip.compressedPublicKey.gl.toHexString)")
//        print("root uncompressedPublicKey: \(bip.uncompressedPublicKey?.gl.toHexString ?? "nil")")
//        print("root depth: \(bip.depth)")
//        print("root trueIndex: \(bip.trueIndex)")
//        print("root parentFingerprint: \(bip.parentFingerprint.gl.toHexString)")
//        print("root chainCode: \(bip.chainCode.gl.toHexString)")
//        print("root path: \(bip.path)")
//        let rootExtendedPrivateKeyString = bip.extendedPrivateKeyString(versionType: .segregatedWitness, isMainNet: true)
//        let rootExtendedPublicKeyString = bip.extendedPublicKeyString(versionType: .segregatedWitness, isMainNet: true)
//        print("root extendedPrivateKeyString: \(rootExtendedPrivateKeyString ?? "nil")")
//        print("root extendedPublicKeyString: \(rootExtendedPublicKeyString ?? "nil")")
//
//        print("😄😄😄😄😄😄😄😄😄😄😄😄😄😄")
//        guard let ethNode = bip.derive(path: path) else { return }
//
//        print("uncompressedPrivateKey: \(ethNode.uncompressedPrivateKey?.gl.toHexString ?? "nil")")
//        print("compressedPrivateKey: \(ethNode.compressedPrivateKey?.gl.toHexString ?? "nil")")
//        print("compressedPublicKey: \(ethNode.compressedPublicKey.gl.toHexString)")
//        print("uncompressedPublicKey: \(ethNode.uncompressedPublicKey?.gl.toHexString ?? "nil")")
//        print("depth: \(ethNode.depth)")
//        print("trueIndex: \(ethNode.trueIndex)")
//        print("parentFingerprint: \(ethNode.parentFingerprint.gl.toHexString)")
//        print("chainCode: \(ethNode.chainCode.gl.toHexString)")
//        print("path: \(ethNode.path)")
//
//        print("😄😄😄😄😄😄😄😄😄😄😄😄😄😄")
////        print("BTC compressed WIF: \(ethNode.WIF(hexPrefix: "0x80", compressed: true) ?? "nil")") // 比特币私钥(压缩的私钥并且base58 check encode)
//        print("BTC extendedPrivateKeyString: \(ethNode.extendedPrivateKeyString(versionType: .segregatedWitness, isMainNet: true) ?? "nil")")
//        print("BTC extendedPublicKeyString: \(ethNode.extendedPublicKeyString(versionType: .segregatedWitness, isMainNet: true) ?? "nil")")
//
//
//
//        print("😄😄😄😄😄😄😄😄😄😄😄😄😄😄")
//        let extendedPrivateNode = BIP32(extendedKeyString: rootExtendedPrivateKeyString ?? "")?.derive(path: path)
//        print("扩展私钥 - uncompressedPrivateKey: \(extendedPrivateNode?.uncompressedPrivateKey?.gl.toHexString ?? "nil")")
//        print("扩展私钥 - compressedPrivateKey: \(extendedPrivateNode?.compressedPrivateKey?.gl.toHexString ?? "nil")")
//        print("扩展私钥 - uncompressedPublicKey: \(extendedPrivateNode?.uncompressedPublicKey?.gl.toHexString ?? "nil")")
//        print("扩展私钥 - compressedPublicKey: \(extendedPrivateNode?.compressedPublicKey.gl.toHexString ?? "nil")")
//
//
//        print("😄😄😄😄😄😄😄😄😄😄😄😄😄😄")
//        let extendedPublicKeyNode = BIP32(extendedKeyString: rootExtendedPublicKeyString ?? "")?.derive(path: path)
//        print("扩展公钥 - uncompressedPrivateKey: \(extendedPublicKeyNode?.uncompressedPrivateKey?.gl.toHexString ?? "nil")")
//        print("扩展公钥 - compressedPrivateKey: \(extendedPublicKeyNode?.compressedPrivateKey?.gl.toHexString ?? "nil")")
//        print("扩展公钥 - uncompressedPublicKey: \(extendedPublicKeyNode?.uncompressedPublicKey?.gl.toHexString ?? "nil")")
//        print("扩展公钥 - compressedPublicKey: \(extendedPublicKeyNode?.compressedPublicKey.gl.toHexString ?? "nil")")
//    }
//}
//
