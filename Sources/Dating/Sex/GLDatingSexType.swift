//
//  GLDatingSexType.swift
//  SwiftTool
//
//  Created by Yule on 2020/12/8.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import WCDBSwift

public enum GLDatingSexType: Int {
    case man = 0
    case women = 1
    case unknown = 2
}


extension GLDatingSexType: ColumnCodable {
    public init?(with value: FundamentalValue) {
        guard let object = GLDatingSexType(rawValue: Int(truncatingIfNeeded: value.int64Value)) else { return nil }
        self = object
    }
    
    public func archivedValue() -> FundamentalValue {
        return FundamentalValue(Int64(self.rawValue))
    }
    
    public static var columnType: ColumnType {
        return .integer64
    }
}
