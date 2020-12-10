//
//  GLDatingSexType.swift
//  SwiftTool
//
//  Created by Yule on 2020/12/8.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import GRDB

public enum GLDatingSexType: Int, Codable {
    case man = 0
    case women = 1
    case unknown = 2
}

extension GLDatingSexType: DatabaseValueConvertible {}
