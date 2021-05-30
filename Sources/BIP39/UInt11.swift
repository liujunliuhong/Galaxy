//
//  UInt11.swift
//  Galaxy
//
//  Created by galaxy on 2021/5/30.
//

import Foundation

public struct UInt11 {
    public static func binaryDescription(value: Int) -> String {
        var binaryString = ""
        var internalNumber = value
        for _ in 0..<11 {
            binaryString.insert(contentsOf: "\(internalNumber & 1)", at: binaryString.startIndex)
            internalNumber >>= 1
        }
        return binaryString
    }
}
