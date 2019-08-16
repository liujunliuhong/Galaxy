//
//  YHViewModelType.swift
//  QAQSwift
//
//  Created by apple on 2019/8/16.
//  Copyright © 2019 yinhe. All rights reserved.
//

import Foundation

protocol YHViewModelType {
    associatedtype Input
    associatedtype Output
    func transform(input: Input) -> Output
}
