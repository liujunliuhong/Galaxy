//
//  GLAlertOptions.swift
//  SwiftTool
//
//  Created by Yule on 2020/12/3.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import UIKit

public class GLAlertOptions {
    public let from: GLAlertFromPosition
    public let to: GLAlertDestinationPostion
    public let dismissTo: GLAlertFromPosition
    
    public var enableMask: Bool = true
    public var shouldResignOnTouchOutside: Bool = true
    public var duration: TimeInterval = 0.25
    public var translucentColor: UIColor = GLAlertEndColor
    
    public init(from: GLAlertFromPosition, to: GLAlertDestinationPostion, dismissTo: GLAlertFromPosition) {
        self.from = from
        self.to = to
        self.dismissTo = dismissTo
    }
}
