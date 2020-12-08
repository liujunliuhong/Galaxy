//
//  UserDefaults+GLDatingUser.swift
//  SwiftTool
//
//  Created by Yule on 2020/12/8.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation

fileprivate extension UserDefaults {
    struct Key {
        static let userIDKey: String = "com.galaxy.dating.user_id.key"
    }
}

extension UserDefaults {
    /// 保存用户ID
    public func gl_dating_set(userID: String) {
        set(userID, forKey: Key.userIDKey)
        synchronize()
    }
    
    /// 获取用户ID
    public func gl_dating_getUserID() -> String? {
        return object(forKey: Key.userIDKey) as? String
    }
    
    /// 移除用户ID
    public func gl_dating_removeUserID() {
        removeObject(forKey: Key.userIDKey)
        synchronize()
    }
}
