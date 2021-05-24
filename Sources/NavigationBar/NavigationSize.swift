//
//  NavigationSize.swift
//  SwiftTool
//
//  Created by galaxy on 2021/5/24.
//  Copyright © 2021 yinhe. All rights reserved.
//

import Foundation
import CoreGraphics

public typealias NavigationSize = CGFloat

extension NavigationSize {
    public static let auto: NavigationSize = -9999.0
    
    internal var isAuto: Bool {
        return NSDecimalNumber(value: Float(self)).compare(NSDecimalNumber(value: Float(.auto))) == .orderedSame
    }
}
