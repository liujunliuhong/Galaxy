//
//  GLDatingLog.swift
//  SwiftTool
//
//  Created by galaxy on 2020/12/12.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation

/// Dating专用日志打印
public func GLDatingLog<T>(_ message: T) {
    #if DEBUG
    print(message)
    #endif
}
