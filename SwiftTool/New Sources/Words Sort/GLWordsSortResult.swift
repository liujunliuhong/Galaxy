//
//  GLWordsSortResult.swift
//  SwiftTool
//
//  Created by galaxy on 2020/10/20.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation

public struct GLWordsSortResult<T> {
    public let key: String
    public let models: [T]
    public init(key: String, models: [T]) {
        self.key = key
        self.models = models
    }
}
