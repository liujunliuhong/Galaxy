//
//  SwiftyViewModelType.swift
//  SwiftTool
//
//  Created by 刘军 on 2020/6/3.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation

public protocol SwiftyViewModelType {
    associatedtype Input
    associatedtype Output
    func transform(input: Input) -> Output
}
