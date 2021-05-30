//
//  BIP39MnemonicCount.swift
//  Galaxy
//
//  Created by galaxy on 2021/5/29.
//

import Foundation

/// 助记词数目
public enum BIP39MnemonicType: Int, CaseIterable {
    case m12 = 128   /// 12位助记词（常用）
    case m15 = 160   /// 15位助记词
    case m18 = 192   /// 18位助记词
    case m21 = 224   /// 21位助记词
    case m24 = 256   /// 24位助记词
}

extension BIP39MnemonicType {
    public var mnemonicCount: Int {
        switch self {
            case .m12:
                return 12
            case .m15:
                return 15
            case .m18:
                return 18
            case .m21:
                return 21
            case .m24:
                return 24
        }
    }
}
