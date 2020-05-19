//
//  SwiftyFileManager.swift
//  SwiftTool
//
//  Created by apple on 2020/5/19.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation

let SwiftyDocumentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last
let SwiftyLibraryDirectory = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).last
let SwiftyCachesDirectory = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last


public enum SwiftyFileType: String {
    case json = "json"
    case plist = "plist"
}

public class SwiftyFileManager {
    public let `default` = SwiftyFileManager()
}

extension SwiftyFileManager {
    
    /// creat directory
    /// - Parameter path: path
    /// - Returns: success or fail
    @discardableResult public func creatDirectory(path: String?) -> Bool {
        guard let path = path else { return false }
        var isDirectory: ObjCBool = true
        if !FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory) {
            do {
                try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
                return true
            } catch {
                return false
            }
        }
        return true
    }
}

extension SwiftyFileManager {
    
    /// get local file data
    /// - Parameters:
    ///   - bundle: bundle
    ///   - fileName: file name
    ///   - type: type
    ///   - options: options
    /// - Returns: array or dictionary
    public func localFile(bundle: Bundle, fileName: String, type: SwiftyFileType, options: JSONSerialization.ReadingOptions = [.mutableContainers]) -> Any? {
        guard let path = bundle.path(forResource: fileName, ofType: type.rawValue) else { return nil }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else { return nil }
        let resultData = try? JSONSerialization.jsonObject(with: data, options: options)
        return resultData
    }
}
