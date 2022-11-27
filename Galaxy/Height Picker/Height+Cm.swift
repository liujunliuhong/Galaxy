//
//  Height+Cm.swift
//  Galaxy
//
//  Created by galaxy on 2022/11/26.
//

import Foundation


public final class CmHeight: CustomStringConvertible {
    public let cm: UInt64
    
    public var ftHeight: FtHeight {
        return FtHeight(cmHeight: self)
    }
    
    public init(cm: UInt64) {
        self.cm = cm
    }
    
    public var description: String {
        return "Height: " + cm.description + "\(HeightUnit.cm.rawValue)"
    }
}
