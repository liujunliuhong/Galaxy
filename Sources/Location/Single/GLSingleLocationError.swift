//
//  GLSingleLocationError.swift
//  SwiftTool
//
//  Created by galaxy on 2020/12/8.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation


public enum GLSingleLocationError: LocalizedError {
    case error(String?)
    
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
