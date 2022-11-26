//
//  Height+Cm.swift
//  Galaxy
//
//  Created by galaxy on 2022/11/26.
//

import Foundation


public final class CmHeight: CustomStringConvertible {
    public let cm: UInt64
    
    public init(cm: UInt64) {
        self.cm = cm
    }
    
    public var description: String {
        return cm.description + "cm"
    }
}

extension CmHeight {
    public static let maximumHeight = CmHeight(cm: 270)
    public static let minimumHeight = CmHeight(cm: 120)
    public static let defaultHeight = CmHeight(cm: 165)
}
