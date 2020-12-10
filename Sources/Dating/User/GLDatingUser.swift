//
//  GLDatingUser.swift
//  SwiftTool
//
//  Created by Yule on 2020/12/8.
//  Copyright © 2020 yinhe. All rights reserved.
//

import UIKit
import Foundation
import GRDB

/// 表名
internal let GLDatingUserTableName = "User"

public class GLDatingUser: Codable {
    /// 用户ID
    public var user_id: String = UUID().uuidString
    /// 邮箱
    public var email: String?
    /// 性别
    public var sex: GLDatingSexType = .women
    /// 昵称
    public var nick_name: String?
    /// 年龄
    public var age: Int = 20
    /// 身高
    public var height: Int = 165
    /// 密码
    public var password: String?
    /// 头像
    public var avatar_name: String?
    /// 国家
    public var country: String?
    /// 城市
    public var city: String?
    /// 位置描述
    public var location_description: String?
    /// 职业
    public var profession: String?
    /// 照片
    public var photos: String?
    /// 关于自己
    public var about_me: String?
    /// 寻找
    public var looking_for: String?
    /// 钻石数量
    public var diamond: Int = 0
    /// 是否是vip
    public var is_vip: Bool = false
    /// 是否是超级vip
    public var is_super_vip: Bool = false
    
    
    public enum CodingKeys: String, CodingKey, ColumnExpression {
        case user_id
        case email
        case sex
        case nick_name
        case age
        case height
        case password
        case avatar_name
        case photos
        case country
        case city
        case location_description
        case profession
        case about_me
        case looking_for
        case diamond
        case is_vip
        case is_super_vip
    }
}

extension GLDatingUser: MutablePersistableRecord, FetchableRecord, TableRecord, PersistableRecord {
    public static var databaseTableName: String {
        return GLDatingUserTableName
    }
}


extension GLDatingUser: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        return getMessage()
    }
    
    public var debugDescription: String {
        return getMessage()
    }
    
    private func getMessage() -> String {
        let dict: [String: Any] = [GLDatingUser.CodingKeys.user_id.rawValue: user_id,
                                   GLDatingUser.CodingKeys.email.rawValue: email ?? "",
                                   GLDatingUser.CodingKeys.sex.rawValue: sex,
                                   GLDatingUser.CodingKeys.nick_name.rawValue: nick_name ?? "",
                                   GLDatingUser.CodingKeys.password.rawValue: password ?? "",
                                   GLDatingUser.CodingKeys.age.rawValue: age,
                                   GLDatingUser.CodingKeys.height.rawValue: height,
                                   GLDatingUser.CodingKeys.avatar_name.rawValue: avatar_name ?? "",
                                   GLDatingUser.CodingKeys.photos.rawValue: photos ?? "",
                                   GLDatingUser.CodingKeys.country.rawValue: country ?? "",
                                   GLDatingUser.CodingKeys.city.rawValue: city ?? "",
                                   GLDatingUser.CodingKeys.location_description.rawValue: location_description ?? "",
                                   GLDatingUser.CodingKeys.profession.rawValue: profession ?? "",
                                   GLDatingUser.CodingKeys.about_me.rawValue: about_me ?? "",
                                   GLDatingUser.CodingKeys.looking_for.rawValue: looking_for ?? "",
                                   GLDatingUser.CodingKeys.diamond.rawValue: diamond,
                                   GLDatingUser.CodingKeys.is_vip.rawValue: is_vip,
                                   GLDatingUser.CodingKeys.is_super_vip.rawValue: is_super_vip]
        return NSString(format: "%@", dict as NSDictionary) as String
    }
}


