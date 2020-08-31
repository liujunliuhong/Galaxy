//
//  SwiftyFileManager.swift
//  SwiftTool
//
//  Created by apple on 2020/5/19.
//  Copyright © 2020 galaxy. All rights reserved.
//

import Foundation
import UIKit

public let SwiftyDocumentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last
public let SwiftyLibraryDirectory = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).last
public let SwiftyCachesDirectory = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last


public enum SwiftyFileType: String {
    case json = "json"
    case plist = "plist"
}

public class SwiftyFileManager {
    public static let `default` = SwiftyFileManager()
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
                #if DEBUG
                print("Creat Directory Error: \(error.localizedDescription)")
                #endif
                return false
            }
        }
        return true
    }
    
    /// caculate file size
    /// - Parameter length: length
    /// - Returns: format size
    public func caculateFileSize(length: Int) -> String {
        if (length < 1024) {
            return "\(length)B"
        }else if (length >= 1024 && length < (1024 * 1024)){
            return "\(CGFloat(length) / 1024.0)KB"
        } else if (length > (1024 * 1024) && length < (1024 * 1024 * 1024)) {
            return "\(CGFloat(length) / (1024.0 * 1024.0))MB"
        } else {
            return "\(CGFloat(length) / (1024.0 * 1024.0 * 1024.0))GB"
        }
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
    public func getLocalFile(bundle: Bundle, fileName: String, type: SwiftyFileType, options: JSONSerialization.ReadingOptions = [.mutableContainers]) -> Any? {
        guard let path = bundle.path(forResource: fileName, ofType: type.rawValue) else { return nil }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else { return nil }
        let resultData = try? JSONSerialization.jsonObject(with: data, options: options)
        return resultData
    }
}
