//
//  SwiftyLog.swift
//  SwiftTool
//
//  Created by apple on 2020/5/12.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import CocoaLumberjack


/// ⚠️pod 'CocoaLumberjack/Swift'


/// `CocoaLumberjack` set up
/// - Parameter saveToSandbox: Whether the log can be saved to the sandbox. One situation is: DEBUG mode can be saved to sandbox, RELEASE mode can not be saved to sandbox. There is another situation: no matter what the situation, it can be saved to the sandbox
public func SwiftyLogSetup(saveToSandbox: Bool) {
    #if DEBUG
    // only debug
    if #available(iOS 10.0, *) {
        let logger = DDOSLogger(subsystem: nil, category: nil)
        DDLog.add(logger)
    } else {
        if let logger = DDTTYLogger.sharedInstance {
            DDLog.add(logger)
        }
    }
    #endif
    
    if saveToSandbox {
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last
        let logFileManager = DDLogFileManagerDefault(logsDirectory: documentDirectory)
        let fileLogger = DDFileLogger(logFileManager: logFileManager)
        fileLogger.rollingFrequency = 60 * 60 * 24
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7
        DDLog.add(fileLogger)
        
        #if DEBUG
        print("CocoaLumberjack Log File Path:\(formatString(value: logFileManager.sortedLogFilePaths) ?? "")")
        #endif
    }
}

fileprivate func formatString<T>(value: T) -> String? {
    guard let data = String(format: "%@", value as! CVarArg).data(using: .utf8) else { return nil }
    guard let utf8 = String(data: data, encoding: .nonLossyASCII)?.utf8 else { return nil }
    return "\(utf8)"
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
        SwiftyLog(message)
    }
}
