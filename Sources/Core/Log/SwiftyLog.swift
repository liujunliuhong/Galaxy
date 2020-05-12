//
//  SwiftyLog.swift
//  SwiftTool
//
//  Created by apple on 2020/5/12.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import CocoaLumberjack


/// `CocoaLumberjack` set up
/// - Parameter saveToSandbox: Whether the log can be saved to the sandbox. One situation is: DEBUG mode can be saved to sandbox, RELEASE mode can not be saved to sandbox. There is another situation: no matter what the situation, it can be saved to the sandbox
public func SwiftyLogSetup(saveToSandbox: Bool) {
    #if DEBUG
    // only debug
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
}

/// Log
/// - Parameters:
///   - message: message
///   - file: file
///   - line: line
public func SwiftyLog<T>(_ message: T, file: String = #file, line: Int = #line) {
    let filName = (file as NSString).lastPathComponent
    let msg = "[👉] [\(filName)] [\(line)] \(message)"
    DDLogDebug(msg)
}


@objc public class SwiftyLogger: NSObject {
    /// OC compatible log printing
    /// - Parameter message: message
    @objc public static func log(message: String) {
        YHDebugLog(message)
    }
}
