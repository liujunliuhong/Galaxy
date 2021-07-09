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

/// 星座类型
public enum ConstellationType: CustomStringConvertible {
    case aquarius     /// 水瓶座
    case pisces       /// 双鱼座
    case aries        /// 白羊座
    case taurus       /// 金牛座
    case gemini       /// 双子座
    case cancer       /// 巨蟹座
    case leo          /// 狮子座
    case virgo        /// 处女座
    case libra        /// 天秤座
    case scorpio      /// 天蝎座
    case sagittarius  /// 射手座
    case capricorn    /// 摩羯座
    
    public var description: String {
        switch self {
        case .aquarius:     return "水瓶座"
        case .pisces:       return "双鱼座"
        case .aries:        return "白羊座"
        case .taurus:       return "金牛座"
        case .gemini:       return "双子座"
        case .cancer:       return "巨蟹座"
        case .leo:          return "狮子座"
        case .virgo:        return "处女座"
        case .libra:        return "天秤座"
        case .scorpio:      return "天蝎座"
        case .sagittarius:  return "射手座"
        case .capricorn:    return "摩羯座"
        }
    }
}
