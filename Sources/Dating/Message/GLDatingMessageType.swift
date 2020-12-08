//
//  GLDatingMessageType.swift
//  SwiftTool
//
//  Created by Yule on 2020/12/8.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import WCDBSwift

public enum GLDatingMessageType: Int {
    case text = 0
    case photo = 1
}

extension GLDatingMessageType: ColumnCodable {
    public init?(with value: FundamentalValue) {
        guard let object = GLDatingMessageType(rawValue: Int(truncatingIfNeeded: value.int64Value)) else { return nil }
        self = object
    }
    
    public func archivedValue() -> FundamentalValue {
        return FundamentalValue(Int64(self.rawValue))
    }
    
    public static var columnType: ColumnType {
        return .integer64
    }
}
