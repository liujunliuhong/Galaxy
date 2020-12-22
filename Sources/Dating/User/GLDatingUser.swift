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
    /// 寻找的性别
    public var looking_for_sex: GLDatingSexType = .women
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
    
    
    
    /// 生日
    public var birth: String?
    /// 体型（苗条、健美型、很胖等等）
    public var body_type_status: String?
    /// 关系状态（单身、离异等等）
    public var relationship_status: String?
    /// 小孩状态（没有小孩、有小孩但是不住在一起等等）
    public var children_status: String?
    /// 吸烟状态（从不吸烟、偶尔吸烟、经常吸烟等等）
    public var smoke_status: String?
    /// 饮酒状态（从不饮酒、偶尔饮酒、经常饮酒等等）
    public var drink_status: String?
    /// 种族（白种人、黄种人等等）
    public var ethnicities_status: String?
    
    
    
    public enum CodingKeys: String, CodingKey, ColumnExpression {
        case user_id
        case email
        case sex
        case looking_for_sex
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
        case birth
        case body_type_status
        case relationship_status
        case children_status
        case smoke_status
        case drink_status
        case ethnicities_status
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
                                   GLDatingUser.CodingKeys.looking_for_sex.rawValue: looking_for_sex,
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
                                   GLDatingUser.CodingKeys.is_super_vip.rawValue: is_super_vip,
        
        
                                   GLDatingUser.CodingKeys.birth.rawValue: birth ?? "",
                                   GLDatingUser.CodingKeys.body_type_status.rawValue: body_type_status ?? "",
                                   GLDatingUser.CodingKeys.relationship_status.rawValue: relationship_status ?? "",
                                   GLDatingUser.CodingKeys.children_status.rawValue: children_status ?? "",
                                   GLDatingUser.CodingKeys.smoke_status.rawValue: smoke_status ?? "",
                                   GLDatingUser.CodingKeys.drink_status.rawValue: drink_status ?? "",
                                   GLDatingUser.CodingKeys.ethnicities_status.rawValue: ethnicities_status ?? ""]
        return NSString(format: "%@", dict as NSDictionary) as String
    }
}


