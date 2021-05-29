//
//  Galaxy.swift
//  SwiftTool
//
//  Created by galaxy on 2021/5/23.
//  Copyright © 2021 yinhe. All rights reserved.
//

import Foundation
import UIKit
import CoreText
import Alamofire

public struct GalaxyWrapper<Base> {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

public typealias GL = GalaxyWrapper

public protocol GalaxyCompatible {}

extension GalaxyCompatible {
    public var gl: GalaxyWrapper<Self> {
        get { return GalaxyWrapper(self) }
        set { }
    }
}

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


extension NSObject: GalaxyCompatible { }
extension Array: GalaxyCompatible { }
extension Dictionary: GalaxyCompatible { }
extension CGFloat: GalaxyCompatible { }
extension Float: GalaxyCompatible { }
extension Double: GalaxyCompatible { }
extension Int: GalaxyCompatible { }
extension UInt8: GalaxyCompatible { }
extension UInt16: GalaxyCompatible { }
extension UInt32: GalaxyCompatible { }
extension UInt64: GalaxyCompatible { }
extension Int8: GalaxyCompatible { }
extension Int16: GalaxyCompatible { }
extension Int32: GalaxyCompatible { }
extension Int64: GalaxyCompatible { }
extension Data: GalaxyCompatible { }
extension String: GalaxyCompatible { }
extension CTParagraphStyle: GalaxyCompatible { }
extension Alamofire.NetworkReachabilityManager: GalaxyCompatible { }
