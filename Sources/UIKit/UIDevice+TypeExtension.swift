//
//  UIDevice+TypeExtension.swift
//  SwiftTool
//
//  Created by galaxy on 2021/5/18.
//  Copyright © 2021 yinhe. All rights reserved.
//

import Foundation
import UIKit


extension UIDevice {
    public enum GLType {
        // AirPods
        case AirPods_1st_generation
        case AirPods_2nd_generation
        case AirPods_Pro
        // Apple TV
        case Apple_TV_1st_generation
        case Apple_TV_2nd_generation
        case Apple_TV_3rd_generation
        case Apple_TV_4th_generation
        case Apple_TV_4K
    }
}

extension UIDevice.GLType {
    public var gl_description: String {
        switch self {
            case .AirPods_1st_generation:
                return "AirPods (1st generation)"
            case .AirPods_2nd_generation:
                return "AirPods (2nd generation)"
            case .AirPods_Pro:
                return "AirPods Pro"
            case .Apple_TV_1st_generation:
                return "Apple TV (1st generation)"
            case .Apple_TV_2nd_generation:
                return "Apple TV (2nd generation)"
            case .Apple_TV_3rd_generation:
                return "Apple TV (3rd generation)"
            case .Apple_TV_4th_generation:
                return "Apple TV (4th generation)"
            case .Apple_TV_4K:
                return "Apple TV 4K"
        }
    }
    
    public var gl_identifiers: [String] {
        switch self {
            case .AirPods_1st_generation:
                return ["AirPods1,1"]
            case .AirPods_2nd_generation:
                return ["AirPods2,1"]
            case .AirPods_Pro:
                return ["iProd8,1"]
            case .Apple_TV_1st_generation:
                return ["AppleTV1,1"]
            case .Apple_TV_2nd_generation:
                return ["AppleTV2,1"]
            case .Apple_TV_3rd_generation:
                return ["AppleTV3,1", "AppleTV3,2"]
            case .Apple_TV_4th_generation:
                return ["AppleTV5,3"]
            case .Apple_TV_4K:
                return ["AppleTV6,2"]
        }
    }
}
