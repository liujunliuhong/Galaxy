//
//  Height+Ft.swift
//  Galaxy
//
//  Created by galaxy on 2022/11/26.
//

import Foundation

/*
 * 英尺、英寸
 * 1 ft = 12 in = 30.48 cm
 */
public final class FtHeight: CustomStringConvertible {
    /// ft
    public let ft: UInt64
    /// in
    public let `in`: UInt64
    /// such as `8.35`
    public let ftDescription: String
    
    /// cmHeight
    public var cmHeight: CmHeight {
        let tmp = NSDecimalNumber(string: `in`.description)
            .dividing(by: NSDecimalNumber(string: "12"))
            .adding(NSDecimalNumber(string: ft.description))
        let cm = tmp.multiplying(by: NSDecimalNumber(string: "30.48"))
        return CmHeight(cm: UInt64(floor(cm.doubleValue)))
    }
    
    public init(ft: UInt64, in: UInt64) {
        let check = FtHeight.correct(ft: ft, in: `in`)
        
        self.ft = check.ft
        self.in = check.in
        
        let ftDescription = NSDecimalNumber(string: `in`.description)
            .dividing(by: NSDecimalNumber(string: "12"))
            .adding(NSDecimalNumber(string: ft.description))
            .stringValue
        self.ftDescription = ftDescription
    }
    
    public init?(ftDescription: String) {
        guard let _ = Double(ftDescription) else {
            return nil
        }
        let ftDescription = NSDecimalNumber(string: ftDescription)
        
        /// 整数英尺
        let ft = UInt64(floor(ftDescription.doubleValue))
        
        /// 获取英寸
        let inValue = (ftDescription.subtracting(NSDecimalNumber(string: ft.description)))
            .multiplying(by: NSDecimalNumber(string: "12"))
        
        let `in` = UInt64(floor(inValue.doubleValue)) // 这儿会出现精度丢失
        
        let check = FtHeight.correct(ft: ft, in: `in`)
        
        self.ft = check.ft
        self.in = check.in
        self.ftDescription = ftDescription.stringValue
    }
    
    public convenience init(cmHeight: CmHeight) {
        let cmResult = cmHeight.cm
        
        /// 厘米转换为英尺
        let ftDescription = NSDecimalNumber(string: cmResult.description).dividing(by: NSDecimalNumber(string: "30.48"))
        self.init(ftDescription: ftDescription.stringValue)!
    }
    
    public var description: String {
        return "Height: " + ft.description + " \(HeightUnit.ft.rawValue)" + ", " + `in`.description + " \(HeightUnit.in.rawValue)" + "; " + ftDescription + " \(HeightUnit.ft.rawValue)"
    }
}

extension FtHeight {
    private static func correct(ft: UInt64, `in`: UInt64) -> (ft: UInt64, `in`: UInt64) {
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
}
