//
//  URL+Extension.swift
//  SwiftTool
//
//  Created by liujun on 2021/5/15.
//  Copyright © 2021 yinhe. All rights reserved.
//

import Foundation

extension URL {
    
    public enum GLSchemeType: String, CaseIterable {
        case http = "http"
        case https = "https"
    }
    
    /// 获取`URL`里面的所有参数，组装成字典
    ///
    /// 支持`www.baidu.com?name=xiaoming&age=20`形式
    public var gl_queryParameters: [String: String]? {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems else { return nil }
        
        var items: [String: String] = [:]
        
        for queryItem in queryItems {
            items[queryItem.name] = queryItem.value
        }
        return items
    }
    
    /// 在原有的`URL`上面拼接参数
    ///
    /// 支持`www.baidu.com?name=xiaoming&age=20`形式
    public func gl_appendingQueryParameters(_ parameters: [String: String]) -> URL? {
        guard var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true) else { return nil }
        let queryItems = parameters.map { (key, value) -> URLQueryItem in
            return URLQueryItem(name: key, value: value)
        }
        urlComponents.queryItems = (urlComponents.queryItems ?? []) + queryItems
        return urlComponents.url
    }
    
    /// 在`URL`上面查询一个参数
    ///
    /// 支持`www.baidu.com?name=xiaoming&age=20`形式
    public func gl_queryValue(for key: String) -> String? {
        return URLComponents(string: absoluteString)?
            .queryItems?
            .first(where: { $0.name == key })?
            .value
    }
}
