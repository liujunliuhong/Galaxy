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
    
    /// If it is Chinese, then unicode is displayed on the console, which affects reading, so convert it.
    public var yh_unicodeToUTF8: String? {
        guard let data = self.data(using: .utf8) else { return nil }
        guard let utf8 = String(data: data, encoding: .nonLossyASCII)?.utf8 else { return nil }
        return "\(utf8)"
    }
}
