//
//  Dictionary+SwiftyExtension.swift
//  SwiftTool
//
//  Created by apple on 2020/5/20.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation


extension Dictionary {
    /// json encode
    public var YH_jsonEnCode: String? {
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: []) else { return nil }
        return String(data: data, encoding: .utf8)
    }
}
