//
//  GLLog.swift
//  SwiftTool
//
//  Created by galaxy on 2020/10/31.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import CocoaLumberjack


/// Log初始化(依赖`CocoaLumberjack/Swift`)
public func GLLogSetup(saveToSandbox: Bool) {
    
    #if DEBUG
    // DEBUG模式下，开启控制台输出打印
    if #available(iOS 10.0, *) {
        let logger = DDOSLogger(subsystem: nil, category: nil)
        DDLog.add(logger)
    } else {
        if let logger = DDTTYLogger.sharedInstance {
            DDLog.add(logger)
        }
    }
    #endif
    if !saveToSandbox {
        return
    }
    let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last
    let logFileManager = DDLogFileManagerDefault(logsDirectory: documentDirectory)
    let fileLogger = DDFileLogger(logFileManager: logFileManager)
    fileLogger.rollingFrequency = 60 * 60 * 24
    fileLogger.logFileManager.maximumNumberOfLogFiles = 7
    fileLogger.maximumFileSize = UInt64(1024 * 1024 * 0.5) // 512KB
    DDLog.add(fileLogger)
    
    #if DEBUG
    print("CocoaLumberjack Log File Paths:\(formatString(value: logFileManager.sortedLogFilePaths) ?? "")")
    #endif
}

fileprivate func formatString<T>(value: T) -> String? {
    guard let data = String(format: "%@", value as! CVarArg).data(using: .utf8) else { return nil }
    guard let utf8 = String(data: data, encoding: .nonLossyASCII)?.utf8 else { return nil }
    return "\(utf8)"
}

/// 打印日志
public func GLLog<T>(_ message: T, file: String = #file, line: Int = #line) {
    let filName = (file as NSString).lastPathComponent
    let msg = "[👉] [\(filName)] [\(line)] \(message)"
    DDLogDebug(msg)
}
