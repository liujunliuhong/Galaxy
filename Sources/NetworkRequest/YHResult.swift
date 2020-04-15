//
//  YHResult.swift
//  SwiftTool
//
//  Created by apple on 2019/8/8.
//  Copyright © 2019 yinhe. All rights reserved.
//

import Foundation
import Result

// https://github.com/antitypical/Result/issues/77
public struct YHResult<T, E: Swift.Error> {
    public typealias result = Result<T, E>
}
