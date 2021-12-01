//
//  Log.swift
//  SwiftTool
//
//  Created by liujun on 2021/5/24.
//  Copyright © 2021 yinhe. All rights reserved.
//

import Foundation
#if canImport(CocoaLumberjack)
import CocoaLumberjack
#endif

public struct Log {
    #if canImport(CocoaLumberjack)
    /// Log初始化，添加控制台打印和沙盒日志保存.(依赖`CocoaLumberjack/Swift`)
    /// - Parameter saveToSandbox: 日志是否报保存到本地沙盒
    public static func setup(saveToSandbox: Bool) {
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
        let paths = logFileManager.sortedLogFilePaths as NSArray // pretty print
        let des = NSString(format: "%@", paths)
        print("CocoaLumberjack Log File Paths:\(des)")
        #endif
    }
    #endif
}


/// 打印日志
public func MyLog<T>(_ message: T, file: String = #file, line: Int = #line) {
    let filName = (file as NSString).lastPathComponent
    let msg = "[👉] [\(filName)] [\(line)] \(message)"
    #if canImport(CocoaLumberjack)
    DDLogDebug(msg)
    #else
#if DEBUG
    print(msg)
#endif
    #endif
}
