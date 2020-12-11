//
//  GLDatingLog.swift
//  SwiftTool
//
//  Created by galaxy on 2020/12/12.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation

public func GLDatingLog<T>(_ message: T) {
    #if DEBUG
    print(message)
    #endif
}
