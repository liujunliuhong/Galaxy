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

/// CocoaLumberjack配置
/// - Parameter saveToSandbox: 日志是否可以保存到沙盒。一种情形是：DEBUG模式下可以保存到沙盒，RELEASE模式下不能保存到沙盒。还有种情形是：无论什么情况，都可以保存到沙盒
public func YHSetupLog(saveToSandbox: Bool) {
    #if canImport(CocoaLumberjack)
    #if DEBUG
    if let logger = DDTTYLogger.sharedInstance {
        DDLog.add(logger)
    }
    #endif
    if saveToSandbox {
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last
        let logFileManager = DDLogFileManagerDefault(logsDirectory: documentDirectory)
        let fileLogger = DDFileLogger(logFileManager: logFileManager)
        fileLogger.rollingFrequency = 60 * 60 * 24
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7
        DDLog.add(fileLogger)
    }
    #endif
}


/// 日志打印
/// - Parameters:
///   - message: message
///   - file: file
///   - line: line
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
    /// 兼容OC的日志打印
    /// - Parameter message: message
    @objc public static func log(message: String) {
        YHDebugLog(message)
    }
}
