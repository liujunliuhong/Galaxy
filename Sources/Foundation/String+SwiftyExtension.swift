//
//  String+SwiftyExtension.swift
//  SwiftTool
//
//  Created by apple on 2020/5/20.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation

extension String {
    /// json decode
    public var yh_jsonDecode: Any? {
        guard let data = self.data(using: .utf8) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
    }
}
