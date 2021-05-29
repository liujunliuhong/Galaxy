//
//  BIP39Language.swift
//  Galaxy
//
//  Created by galaxy on 2021/5/29.
//

import Foundation

public enum BIP39Language {
    case english
}

extension BIP39Language {
    public var words: [String] {
        switch self {
            case .english:
                return BIP39Language.englishWords
        }
    }
    
    public var separator: String {
        switch self {
            case .english:
                return " "
        }
    }
}
