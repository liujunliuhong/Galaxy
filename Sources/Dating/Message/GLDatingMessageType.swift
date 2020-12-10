//
//  GLDatingMessageType.swift
//  SwiftTool
//
//  Created by Yule on 2020/12/8.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import GRDB

public enum GLDatingMessageType: Int, Codable {
    case text = 0
    case photo = 1
}

extension GLDatingMessageType: DatabaseValueConvertible {}
