//
//  Base64.swift
//  Galaxy
//
//  Created by liujun on 2021/5/29.
//

import Foundation

/// `Base 64`
public struct Base64 {
    
    /// `Base64`编码
    public static func base64Encoded(data: Data?, options: Data.Base64EncodingOptions = [.lineLength64Characters]) -> Data? {
        guard let data = data else { return nil }
        return data.base64EncodedData(options: options)
    }
    
    /// `Base64`解码
    public static func base64Decoded(data: Data?, options: Data.Base64DecodingOptions = [.ignoreUnknownCharacters]) -> Data? {
        guard let data = data else { return nil }
        return Data(base64Encoded: data, options: options)
    }
    
    /// `Base64`解码
    public static func base64Decoded(string: String?, options: Data.Base64DecodingOptions = [.ignoreUnknownCharacters]) -> Data? {
        guard let string = string else { return nil }
        return Data(base64Encoded: string, options: options)
    }
}
