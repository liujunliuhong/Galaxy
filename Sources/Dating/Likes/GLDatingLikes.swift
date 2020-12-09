//
//  GLDatingLikes.swift
//  SwiftTool
//
//  Created by Yule on 2020/12/9.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import WCDBSwift

// 喜欢
public class GLDatingLikes: TableCodable {
    public var ID: String = UUID().uuidString
    /// 用户ID
    public var userID: String?
    /// 拥有者ID
    public var ownerID: String?
    /// 头像
    public var avatar: String?
    /// 昵称
    public var name: String?
    
    
    public enum CodingKeys: String, CodingTableKey {
        public typealias Root = GLDatingLikes
        public static let objectRelationalMapping = TableBinding(CodingKeys.self)
        
        case ID
        case userID
        case ownerID
        case avatar
        case name
        
        public static var columnConstraintBindings: [CodingKeys: ColumnConstraintBinding]? {
            return [
                .ID: ColumnConstraintBinding(isPrimary: true)
            ]
        }
        
        public static var indexBindings: [IndexBinding.Subfix: IndexBinding]? {
            return [
                "_index": IndexBinding(indexesBy: CodingKeys.ID)
            ]
        }
    }
}

