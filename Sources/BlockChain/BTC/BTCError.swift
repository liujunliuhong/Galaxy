//
//  BTCError.swift
//  Galaxy
//
//  Created by liujun on 2021/6/16.
//

import Foundation

public enum BTCError {
    case msg(message: String)
}

extension BTCError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .msg(let message):
            return message
        }
    }
}
