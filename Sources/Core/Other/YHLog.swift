//
//  YHLog.swift
//  SwiftTool
//
//  Created by apple on 2019/6/21.
//  Copyright © 2019 yinhe. All rights reserved.
//

import Foundation

#if canImport(CocoaLumberjack)
import CocoaLumberjack
#endif

public enum YHDebugLogType {
    case info
    case warning
    case error
}

public func YHDebugLog<T>(_ message: T, file: String = #file, line: Int = #line) {
    #if canImport(CocoaLumberjack)
    let filName = (file as NSString).lastPathComponent
    let msg = "[👉] [\(filName)] [\(line)] \(message)"
    DDLogDebug(msg)
    #else
    #if DEBUG
    let dateFormatter: DateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss";
    let time = dateFormatter.string(from: Date())
    let filName = (file as NSString).lastPathComponent
    print("[👉] [\(time)] [\(filName)] [\(line)] \(message)")
    #endif
    #endif
}

@objc public class YHLogger: NSObject {
    @objc public static func log(message: String) {
        YHDebugLog(message)
    }
}
