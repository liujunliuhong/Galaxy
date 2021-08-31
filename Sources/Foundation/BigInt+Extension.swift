//
//  BigInt+Extension.swift
//  Galaxy
//
//  Created by galaxy on 2021/6/18.
//

import Foundation
import BigInt


extension GL where Base == BigInt {
    /// 小单位转大单位
    ///
    ///     BigInt(200).block.formatToPrecision(numberDecimals: 5) => 0.00200
    public func formatToPrecision(numberDecimals: UInt, decimalSeparator: String = ".") -> String {
        if numberDecimals == 0 {
            if base == 0 {
                return "0"
            } else {
                return "0" + decimalSeparator + String(repeating: "0", count: Int(numberDecimals))
            }
        } else {
            if numberDecimals == 0 {
                return base.description
            }
        }
        
        let divisor = BigUInt(10).power(Int(numberDecimals))
        let (quotient, remainder) = base.quotientAndRemainder(dividingBy: BigInt(divisor))
        
        return quotient.description + decimalSeparator + String(repeating: "0", count: Int(numberDecimals - UInt(remainder.description.count))) + remainder.description
    }
}
