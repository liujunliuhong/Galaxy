//
//  Array+YHExtension.swift
//  FNDating
//
//  Created by apple on 2019/10/12.
//  Copyright © 2019 yinhe. All rights reserved.
//

import Foundation


extension Array {
    
    /// json encode
    var yh_jsonEnCode: String? {
        let data = try? JSONSerialization.data(withJSONObject: self, options: [])
        guard let _data = data else { return nil }
        return String(data: _data, encoding: .utf8)
    }
}
