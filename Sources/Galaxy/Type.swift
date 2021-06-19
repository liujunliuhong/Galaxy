//
//  Type.swift
//  Galaxy
//
//  Created by galaxy on 2021/6/19.
//

import Foundation

/// Scheme类型
public enum SchemeType: String, CaseIterable {
    case http = "http"    /// http
    case https = "https"  /// https
}

/// 文件类型
public enum FileType: String {
    case json = "json"    /// json
    case plist = "plist"  /// plist
}
