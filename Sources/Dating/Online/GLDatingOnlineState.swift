//
//  GLDatingOnlineState.swift
//  SwiftTool
//
//  Created by Yule on 2020/12/7.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import UIKit

public enum GLDatingOnlineState: RawRepresentable {
    case online
    case offline
    case busy
    
    public typealias RawValue = UIColor
    
    public var rawValue: UIColor {
        switch self {
        case .online:
            return UIColor.gl_hexColor(hex: 0x00FF0B)
        case .offline:
            return UIColor.gl_hexColor(hex: 0x919191)
        case .busy:
            return UIColor.gl_hexColor(hex: 0xFF000C)
        }
    }
    
    public init?(rawValue: GLDatingOnlineState.RawValue) {
        switch rawValue {
        case GLDatingOnlineState.online.rawValue:
            self = .offline
        case GLDatingOnlineState.offline.rawValue:
            self = .offline
        case GLDatingOnlineState.busy.rawValue:
            self = .busy
        default:
            self = .offline
        }
    }
}
