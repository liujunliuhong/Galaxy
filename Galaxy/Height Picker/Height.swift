//
//  Height.swift
//  Galaxy
//
//  Created by galaxy on 2022/12/3.
//

import Foundation

/*
 * 英尺、英寸
 * 1 ft = 12 in = 30.48 cm
 */
public final class Height {
    
    /// ft
    public let ft: UInt64
    /// in
    public let `in`: UInt64
    /// cm
    public let cm: UInt64
    
    
    /// 厘米初始化
    public init(cm: UInt64) {
        self.cm = cm
        
        let convert = Height.convertToFt(cm: cm)
        self.ft = convert.ft
        self.in = convert.in
    }
    
    
    /// 英尺、英寸初始化
    public init(ft: UInt64, in: UInt64) {
        let check = Height.correct(ft: ft, in: `in`)
        self.ft = check.ft
        self.in = check.`in`
        
        self.cm = Height.convertToCm(ft: self.ft, in: self.in)
        
    }
    
    /// 用格式化的英尺进行初始化，比如"12.34"
    public init?(formatFt: String) {
        guard let convert = Height.convertToFt(formatFt: formatFt) else { return nil }
        self.ft = convert.ft
        self.in = convert.in
        
        self.cm = Height.convertToCm(ft: self.ft, in: self.in)
    }
    
    /// 用格式化的厘米进行初始化，比如"170"
    public init?(formatCm: String) {
        guard let cm = UInt64(formatCm) else { return nil }
        self.cm = cm
        
        let convert = Height.convertToFt(cm: cm)
        self.ft = convert.ft
        self.in = convert.in
    }
}

extension Height: Equatable {
    public static func == (lhs: Height, rhs: Height) -> Bool {
        return lhs.ft == rhs.ft && lhs.in == rhs.in && lhs.cm == rhs.cm
    }
}

extension Height {
    private static func correct(ft: UInt64, in: UInt64) -> (ft: UInt64, `in`: UInt64) {
        var ft = ft
        var `in` = `in`
        // check
        let tmp = `in` / 12
        if tmp > 0 {
            ft = ft + tmp
            `in` = `in` % 12
        }
        return (ft, `in`)
    }
    
    private static func convertToCm(ft: UInt64, in: UInt64) -> UInt64 {
        let tmp = NSDecimalNumber(string: `in`.description)
            .dividing(by: NSDecimalNumber(string: "12"))
            .adding(NSDecimalNumber(string: ft.description))
        let cm = tmp.multiplying(by: NSDecimalNumber(string: "30.48"))
        
        let result = UInt64(floor(cm.doubleValue))  // 这儿会出现精度丢失
        
        return result
    }
    
    private static func convertToFt(formatFt: String) -> (ft: UInt64, `in`: UInt64)? {
        guard let _ = Double(formatFt) else {
            return nil
        }
        let formatFt = NSDecimalNumber(string: formatFt)
        
        /// 整数英尺
        let ft = UInt64(floor(formatFt.doubleValue))
        
        /// 获取英寸
        let inValue = (formatFt.subtracting(NSDecimalNumber(string: ft.description)))
            .multiplying(by: NSDecimalNumber(string: "12"))
        
        let `in` = UInt64(floor(inValue.doubleValue)) // 这儿会出现精度丢失
        
        let check = Height.correct(ft: ft, in: `in`)
        return check
    }
    
    private static func convertToFt(cm: UInt64) -> (ft: UInt64, `in`: UInt64) {
        let formatFt = NSDecimalNumber(string: cm.description).dividing(by: NSDecimalNumber(string: "30.48"))
        return Height.convertToFt(formatFt: formatFt.stringValue)!
    }
}
