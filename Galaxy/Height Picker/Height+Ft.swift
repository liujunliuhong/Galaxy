//
//  Height+Ft.swift
//  Galaxy
//
//  Created by galaxy on 2022/11/26.
//

import Foundation

/*
 * 1 ft = 12 in = 30.48 cm
 */
public final class FtHeight: CustomStringConvertible {
    public let ft: UInt64
    public let `in`: UInt64
    
    public var cmHeight: CmHeight {
        let tmp = NSDecimalNumber(string: `in`.description)
            .dividing(by: NSDecimalNumber(string: "12"))
            .adding(NSDecimalNumber(string: ft.description))
        let cm = tmp.multiplying(by: NSDecimalNumber(string: "30.48"))
        return CmHeight(cm: UInt64(floor(cm.doubleValue)))
    }
    
    public init(ft: UInt64, in: UInt64) {
        self.ft = ft
        self.in = `in`
    }
    
    public convenience init(cmHeight: CmHeight) {
        let cmResult = cmHeight.cm
        
        /// 厘米转换为英尺
        let ftResult = NSDecimalNumber(string: cmResult.description).dividing(by: NSDecimalNumber(string: "30.48"))
        
        /// 整数英尺
        let ft = UInt64(floor(ftResult.doubleValue))
        
        /// 获取英寸
        let inValue = (ftResult.subtracting(NSDecimalNumber(string: ft.description)))
            .multiplying(by: NSDecimalNumber(string: "12"))
        
        let `in` = UInt64(floor(inValue.doubleValue)) // 这儿会出现精度丢失
        
        self.init(ft: ft, in: `in`)
    }
    
    public var description: String {
        let ftDescription = NSDecimalNumber(string: `in`.description)
            .dividing(by: NSDecimalNumber(string: "12"))
            .adding(NSDecimalNumber(string: ft.description))
            .description
        
        return ft.description + "ft" + " " + `in`.description + "in" + ", " + ftDescription + " ft"
    }
}

extension FtHeight {
    public static let maximumHeight = FtHeight(cmHeight: CmHeight.maximumHeight)
    public static let minimumHeight = FtHeight(cmHeight: CmHeight.minimumHeight)
    public static let defaultHeight = FtHeight(cmHeight: CmHeight.defaultHeight)
}
