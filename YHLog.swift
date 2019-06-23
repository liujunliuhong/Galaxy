//
//  YHLog.swift
//  SwiftTool
//
//  Created by apple on 2019/6/21.
//  Copyright © 2019 yinhe. All rights reserved.
//

import Foundation

enum YHDebugLogType {
    case info
    case warning
    case error
}

func YHDebugLog<T>(_ message: T, type: YHDebugLogType = .info, file: String = #file, line: Int = #line) {
    #if DEBUG
    let dateFormatter: DateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss";
    let time = dateFormatter.string(from: Date())
    
    let type = type
    var typeFormat = "INFO"
    switch type {
    case .info:
        typeFormat = "👉"
    case .warning:
        typeFormat = "❗️"
    case .error:
        typeFormat = "❌"
    }
    
    let filName = (file as NSString).lastPathComponent
    print("[\(typeFormat)] [\(time)] [\(filName)] [\(line)] \(message)")
    #endif
}
