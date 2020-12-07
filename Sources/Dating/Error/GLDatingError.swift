//
//  GLDatingError.swift
//  SwiftTool
//
//  Created by Yule on 2020/12/7.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation

public enum GLDatingError: LocalizedError {
    
    public static let unknownError = GLDatingError.error("Unknown error")
    
    case error(String?)
}

extension GLDatingError {
    public var errorDescription: String? {
        switch self {
        case .error(let des):
            return des
        }
    }
    
    public var localizedDescription: String? {
        switch self {
        case .error(let des):
            return des
        }
    }
}
