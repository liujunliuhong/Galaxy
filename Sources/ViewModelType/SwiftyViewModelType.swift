//
//  SwiftyViewModelType.swift
//  SwiftTool
//
//  Created by liujun on 2020/6/3.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation

public protocol SwiftyViewModelType {
    associatedtype Input
    associatedtype Output
    func transform(input: Input) -> Output
}
