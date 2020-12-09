//
//  GLDatingUserManager.swift
//  SwiftTool
//
//  Created by Yule on 2020/12/8.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import WCDBSwift
import RxSwift
import RxCocoa
import NSObject_Rx

private let tableName = String(describing: GLDatingUser.self)

public class GLDatingUserManager {
    /// 单列
    public static let `default` = GLDatingUserManager()
    
    
    private var database: Database?
    
    
    
    /// 当前用户
    public var currentUser: GLDatingUser?
    
    
    
    /// 邮箱
    public let email = BehaviorRelay<String?>(value: nil)
    /// 性别
    public let sex = BehaviorRelay<GLDatingSexType>(value: .women)
    /// 昵称
    public let nickName = BehaviorRelay<String?>(value: nil)
    /// 年龄
    public let age = BehaviorRelay<Int>(value: 20)
    /// 身高
    public let height = BehaviorRelay<Int>(value: 165)
    /// 头像
    public let avatarName = BehaviorRelay<String?>(value: nil)
    /// 国家
    public let country = BehaviorRelay<String?>(value: nil)
    /// 城市
    public let city = BehaviorRelay<String?>(value: nil)
    /// 位置描述
    public let locationDescription = BehaviorRelay<String?>(value: nil)
    /// 职业
    public let profession = BehaviorRelay<String?>(value: nil)
    /// 照片
    public let photos = BehaviorRelay<[String]>(value: [])
    /// 关于自己
    public let aboutMe = BehaviorRelay<String?>(value: nil)
    /// 寻找
    public let lookingFor = BehaviorRelay<String?>(value: nil)
    /// 钻石数量
    public let diamond = BehaviorRelay<Int>(value: 0)
    /// 是否是vip
    public let isVip = BehaviorRelay<Bool>(value: false)
    /// 是否是超级vip
    public let isSuperVip = BehaviorRelay<Bool>(value: false)
    
    /// 是否登录
    public var isLogin: Bool {
        if let _ = UserDefaults.standard.gl_dating_getUserID() {
            #if DEBUG
            print("[已登录]")
            #endif
            return true
        }
        #if DEBUG
        print("[未登录]")
        #endif
        return false
    }
    
    private init() {
        self.initDatabase()
    }
}

extension GLDatingUserManager {
    /// 初始化数据库
    private func initDatabase() {
        guard let basePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last else { return }
        let directory = "GLDatingUserDatabase"
        let path = URL(fileURLWithPath: "\(basePath)/\(directory)").appendingPathComponent(tableName).path
        #if DEBUG
        print("用户信息数据库路径:\(path)")
        #endif
        let database = Database(withPath: path)
        database.close()
        do {
            try database.create(table: tableName, of: GLDatingUser.self)
            #if DEBUG
            print("[创建数据用户信息数据库成功]")
            #endif
        } catch {
            #if DEBUG
            print("[创建数据用户信息数据库失败] \(error)")
            #endif
        }
        self.database = database
    }
}

extension GLDatingUserManager {
    /// 加载用户信息，应该先调用`isLogin`判断是否登录，如果登录了，再调用此方法
    public func loadInfo() throws {
        guard let database = self.database else {
            #if DEBUG
            print("[获取用户信息] [database不存在]")
            #endif
            throw GLDatingError.unknownError
        }
        if !self.isLogin {
            #if DEBUG
            print("[获取用户信息] [未登录]")
            #endif
            throw GLDatingError.error("Please sign in")
        }
        guard let userID = UserDefaults.standard.gl_dating_getUserID() else {
            #if DEBUG
            print("[获取用户信息] [userID不存在]")
            #endif
            throw GLDatingError.error("Please sign in")
        }
        
        do {
            let results:[GLDatingUser] = try database.getObjects(on: GLDatingUser.Properties.all,
                                                                 fromTable: tableName,
                                                                 where: GLDatingUser.Properties.user_id == userID)
            if results.count <= 0 {
                #if DEBUG
                print("[获取用户信息] [数据库查询此用户不存在]")
                #endif
                throw GLDatingError.error("Incorrect email or password")
            }
            let user = results.first!
            self.currentUser = user
            self.refreshUserInfo()
            #if DEBUG
            print("[获取用户信息成功] \(user.description)")
            #endif
        } catch {
            #if DEBUG
            print("[获取用户信息失败] \(error)")
            #endif
            throw error
        }
    }
    
    /// 检查邮箱是否重复
    public func checkEmailIsRepeat(email: String) -> Bool {
        guard let database = self.database else {
            #if DEBUG
            print("[检查邮箱是否重复] [database不存在]")
            #endif
            return true
        }
        do {
            let results:[GLDatingUser] = try database.getObjects(on: GLDatingUser.Properties.all,
                                                                 fromTable: tableName,
                                                                 where: GLDatingUser.Properties.email == email)
            #if DEBUG
            print("[检查邮箱是否重复] \(results)")
            #endif
            return results.count > 0
        } catch {
            #if DEBUG
            print("[检查邮箱是否重复失败] \(error)")
            #endif
            return false
        }
    }
    
    /// 注册
    public func register(sex: GLDatingSexType,
                         email: String,
                         password: String,
                         nickName: String? = nil,
                         age: Int = 20,
                         avatar: String? = nil,
                         height: Int = 165,
                         country: String? = nil,
                         city: String? = nil,
                         locationDescription: String? = nil,
                         profession: String? = nil,
                         photos: [String] = [],
                         aboutMe: String? = nil,
                         lookingFor: String? = nil,
                         diamond: Int = 0,
                         isVip: Bool = false,
                         isSuperVip: Bool = false) throws {
        guard let database = self.database else {
            #if DEBUG
            print("[注册] [database不存在]")
            #endif
            throw GLDatingError.unknownError
        }
        
        let user = GLDatingUser()
        user.sex = sex
        user.email = email
        user.password = password
        user.nick_name = nickName
        user.age = age
        user.avatar_name = avatar
        user.height = height
        user.country = country
        user.city = city
        user.location_description = locationDescription
        user.profession = profession
        user.photos = photos.gl_jsonEncode
        user.about_me = aboutMe
        user.looking_for = lookingFor
        user.diamond = diamond
        user.is_vip = isVip
        user.is_super_vip = isSuperVip
        
        do {
            // 注册之前，先根据传入的邮箱在数据库里面查找
            let results:[GLDatingUser] = try database.getObjects(on: GLDatingUser.Properties.all,
                                                                 fromTable: tableName,
                                                                 where: GLDatingUser.Properties.email == email)
            if results.count > 0 {
                #if DEBUG
                print("[注册失败] 邮箱重复")
                #endif
                throw GLDatingError.error("Email has been registered")
            }
            
            try database.insert(objects: user, intoTable: tableName)
            UserDefaults.standard.gl_dating_set(userID: user.user_id) // 存userID
            #if DEBUG
            print("[注册成功] \(user.description)")
            #endif
        } catch {
            #if DEBUG
            print("[注册失败] \(error)")
            #endif
            throw error
        }
    }
    
    /// 测试账号注册
    public func registerTestAccount(email: String, password: String, sex: GLDatingSexType) throws {
        guard let database = self.database else {
            #if DEBUG
            print("[测试账号注册] [database不存在]")
            #endif
            throw GLDatingError.unknownError
        }
        
        let user = GLDatingUser()
        user.sex = sex
        user.email = email
        user.password = password
        
        do {
            // 注册之前，先根据传入的邮箱在数据库里面查找
            let results:[GLDatingUser] = try database.getObjects(on: GLDatingUser.Properties.all,
                                                                 fromTable: tableName,
                                                                 where: GLDatingUser.Properties.email == email)
            if results.count > 0 {
                #if DEBUG
                print("[测试账号注册失败] 邮箱重复")
                #endif
                throw GLDatingError.error("Email has been registered")
            }
            
            try database.insert(objects: user, intoTable: tableName)
            #if DEBUG
            print("[测试账号注册成功]")
            #endif
        } catch {
            #if DEBUG
            print("[测试账号注册失败] \(error)")
            #endif
            throw error
        }
    }
    
    /// 登录(根据邮箱和密码在数据库里面查找，如果查询到用户，就把用户ID存进UserDefaults)
    public func login(email: String,
                      password: String) throws {
        guard let database = self.database else {
            #if DEBUG
            print("[登录] [database不存在]")
            #endif
            throw GLDatingError.unknownError
        }
        do {
            let results:[GLDatingUser] = try database.getObjects(on: GLDatingUser.Properties.all,
                                                                 fromTable: tableName,
                                                                 where: GLDatingUser.Properties.email == email && GLDatingUser.Properties.password == password)
            if results.count <= 0 {
                #if DEBUG
                print("[登录] [查询用户不存在]")
                #endif
                throw GLDatingError.error("Incorrect email or password")
            }
            let user = results.first!
            UserDefaults.standard.gl_dating_set(userID: user.user_id) // 存userID
            #if DEBUG
            print("[登录成功]")
            #endif
        } catch {
            #if DEBUG
            print("[登录失败] \(error)")
            #endif
            throw error
        }
    }
    
    /// 退出登录(会把单列里面的所有信息清除)
    public func logout() {
        self.clearUserInfo()
    }
    
    /// 删除用户(把当前用户从本地数据库删除)
    public func delete() throws {
        guard let database = self.database else {
            #if DEBUG
            print("[删除用户] [database不存在]")
            #endif
            throw GLDatingError.unknownError
        }
        guard let user = self.currentUser else {
            print("[删除用户] [当前用户不存在]")
            throw GLDatingError.unknownError
        }
        
        do {
            try database.delete(fromTable: tableName, where: GLDatingUser.Properties.user_id == user.user_id)
            self.clearUserInfo()
            #if DEBUG
            print("[删除用户成功]")
            #endif
        } catch {
            #if DEBUG
            print("[删除用户失败] \(error)")
            #endif
            throw error
        }
    }
}

extension GLDatingUserManager {
    private func refreshUserInfo() {
        guard let user = self.currentUser else { return }
        self.email.accept(user.email)
        self.sex.accept(user.sex)
        self.nickName.accept(user.nick_name)
        self.age.accept(user.age)
        self.height.accept(user.height)
        self.avatarName.accept(user.avatar_name)
        self.country.accept(user.country)
        self.city.accept(user.city)
        self.locationDescription.accept(user.location_description)
        self.profession.accept(user.profession)
        self.photos.accept((user.photos?.gl_jsonDecode as? [String]) ?? [])
        self.aboutMe.accept(user.about_me)
        self.lookingFor.accept(user.looking_for)
        self.diamond.accept(user.diamond)
        self.isVip.accept(user.is_vip)
        self.isSuperVip.accept(user.is_super_vip)
    }
    
    private func clearUserInfo() {
        self.currentUser = nil
        UserDefaults.standard.gl_dating_removeUserID()
        self.email.accept(nil)
        self.sex.accept(.women)
        self.nickName.accept(nil)
        self.age.accept(20)
        self.height.accept(165)
        self.avatarName.accept(nil)
        self.country.accept(nil)
        self.city.accept(nil)
        self.locationDescription.accept(nil)
        self.profession.accept(nil)
        self.photos.accept([])
        self.aboutMe.accept(nil)
        self.lookingFor.accept(nil)
        self.diamond.accept(0)
        self.isVip.accept(false)
        self.isSuperVip.accept(false)
    }
}

extension GLDatingUserManager {
    /// 更新用户性别
    public func updateUserSex(sex: GLDatingSexType) {
        guard let database = self.database else {
            #if DEBUG
            print("[更新用户性别] [database不存在]")
            #endif
            return
        }
        guard let user = GLDatingUserManager.default.currentUser else {
            #if DEBUG
            print("[更新用户性别] [用户不存在]")
            #endif
            return
        }
        user.sex = sex
        try? database.update(table: tableName, on: GLDatingUser.Properties.sex, with: user)
        GLDatingUserManager.default.sex.accept(sex)
    }
    
    /// 更新用户LookingFor
    public func updateUserLookingFor(lookingFor: String?) {
        guard let database = self.database else {
            #if DEBUG
            print("[更新用户LookingFor] [database不存在]")
            #endif
            return
        }
        guard let user = GLDatingUserManager.default.currentUser else {
            #if DEBUG
            print("[更新用户LookingFor] [用户不存在]")
            #endif
            return
        }
        user.looking_for = lookingFor
        try? database.update(table: tableName, on: GLDatingUser.Properties.looking_for, with: user)
        GLDatingUserManager.default.lookingFor.accept(lookingFor)
    }
    
    /// 更新用户AboutMe
    public func updateUserAboutMe(aboutMe: String?) {
        guard let database = self.database else {
            #if DEBUG
            print("[更新用户AboutMe] [database不存在]")
            #endif
            return
        }
        guard let user = GLDatingUserManager.default.currentUser else {
            #if DEBUG
            print("[更新用户AboutMe] [用户不存在]")
            #endif
            return
        }
        user.about_me = aboutMe
        try? database.update(table: tableName, on: GLDatingUser.Properties.about_me, with: user)
        GLDatingUserManager.default.aboutMe.accept(aboutMe)
    }
    
    /// 更新用户照片
    public func updateUserPhotos(photos: [String]) {
        guard let database = self.database else {
            #if DEBUG
            print("[更新用户照片] [database不存在]")
            #endif
            return
        }
        guard let user = GLDatingUserManager.default.currentUser else {
            #if DEBUG
            print("[更新用户照片] [用户不存在]")
            #endif
            return
        }
        user.photos = photos.gl_jsonEncode
        try? database.update(table: tableName, on: GLDatingUser.Properties.photos, with: user)
        GLDatingUserManager.default.photos.accept(photos)
    }
    
    /// 更新用户职业
    public func updateUserProfession(profession: String?) {
        guard let database = self.database else {
            #if DEBUG
            print("[更新用户职业] [database不存在]")
            #endif
            return
        }
        guard let user = GLDatingUserManager.default.currentUser else {
            #if DEBUG
            print("[更新用户职业] [用户不存在]")
            #endif
            return
        }
        user.profession = profession
        try? database.update(table: tableName, on: GLDatingUser.Properties.profession, with: user)
        GLDatingUserManager.default.profession.accept(profession)
    }
    
    /// 更新用户位置描述
    public func updateUserLocationDescription(locationDescription: String?) {
        guard let database = self.database else {
            #if DEBUG
            print("[更新用户位置描述] [database不存在]")
            #endif
            return
        }
        guard let user = GLDatingUserManager.default.currentUser else {
            #if DEBUG
            print("[更新用户位置描述] [用户不存在]")
            #endif
            return
        }
        user.location_description = locationDescription
        try? database.update(table: tableName, on: GLDatingUser.Properties.location_description, with: user)
        GLDatingUserManager.default.locationDescription.accept(locationDescription)
    }
    
    /// 更新用户城市
    public func updateUserCity(city: String?) {
        guard let database = self.database else {
            #if DEBUG
            print("[更新用户城市] [database不存在]")
            #endif
            return
        }
        guard let user = GLDatingUserManager.default.currentUser else {
            #if DEBUG
            print("[更新用户城市] [用户不存在]")
            #endif
            return
        }
        user.city = city
        try? database.update(table: tableName, on: GLDatingUser.Properties.city, with: user)
        GLDatingUserManager.default.city.accept(city)
    }
    
    /// 更新用户国家
    public func updateUserCountry(country: String?) {
        guard let database = self.database else {
            #if DEBUG
            print("[更新用户国家] [database不存在]")
            #endif
            return
        }
        guard let user = GLDatingUserManager.default.currentUser else {
            #if DEBUG
            print("[更新用户国家] [用户不存在]")
            #endif
            return
        }
        user.country = country
        try? database.update(table: tableName, on: GLDatingUser.Properties.country, with: user)
        GLDatingUserManager.default.country.accept(country)
    }
    
    /// 更新用户头像
    public func updateUserAvatar(avatarName: String?) {
        guard let database = self.database else {
            #if DEBUG
            print("[更新用户头像] [database不存在]")
            #endif
            return
        }
        guard let user = GLDatingUserManager.default.currentUser else {
            #if DEBUG
            print("[更新用户头像] [用户不存在]")
            #endif
            return
        }
        user.avatar_name = avatarName
        try? database.update(table: tableName, on: GLDatingUser.Properties.avatar_name, with: user)
        GLDatingUserManager.default.avatarName.accept(avatarName)
    }
    
    /// 更新用户年龄
    public func updateUserAge(age: Int) {
        guard let database = self.database else {
            #if DEBUG
            print("[更新用户年龄] [database不存在]")
            #endif
            return
        }
        guard let user = GLDatingUserManager.default.currentUser else {
            #if DEBUG
            print("[更新用户年龄] [用户不存在]")
            #endif
            return
        }
        user.age = age
        try? database.update(table: tableName, on: GLDatingUser.Properties.age, with: user)
        GLDatingUserManager.default.age.accept(age)
    }
    
    /// 更新用户身高
    public func updateUserHeight(height: Int) {
        guard let database = self.database else {
            #if DEBUG
            print("[更新用户身高] [database不存在]")
            #endif
            return
        }
        guard let user = GLDatingUserManager.default.currentUser else {
            #if DEBUG
            print("[更新用户身高] [用户不存在]")
            #endif
            return
        }
        user.height = height
        try? database.update(table: tableName, on: GLDatingUser.Properties.height, with: user)
        GLDatingUserManager.default.height.accept(height)
    }
    
    /// 更新用户昵称
    public func updateUserNickName(nickName: String?) {
        guard let database = self.database else {
            #if DEBUG
            print("[更新用户昵称] [database不存在]")
            #endif
            return
        }
        guard let user = GLDatingUserManager.default.currentUser else {
            #if DEBUG
            print("[更新用户昵称] [用户不存在]")
            #endif
            return
        }
        user.nick_name = nickName
        try? database.update(table: tableName, on: GLDatingUser.Properties.nick_name, with: user)
        GLDatingUserManager.default.nickName.accept(nickName)
    }
    
    /// 更新用户vip状态
    public func updateUserVip(isVip: Bool) {
        guard let database = self.database else {
            #if DEBUG
            print("[更新用户vip状态] [database不存在]")
            #endif
            return
        }
        guard let user = GLDatingUserManager.default.currentUser else {
            #if DEBUG
            print("[更新用户vip状态] [用户不存在]")
            #endif
            return
        }
        user.is_vip = isVip
        try? database.update(table: tableName, on: GLDatingUser.Properties.is_vip, with: user)
        GLDatingUserManager.default.isVip.accept(isVip)
    }
    
    /// 更新用户超级vip状态
    public func updateUserSuperVip(isSuperVip: Bool) {
        guard let database = self.database else {
            #if DEBUG
            print("[更新用户超级vip状态] [database不存在]")
            #endif
            return
        }
        guard let user = GLDatingUserManager.default.currentUser else {
            #if DEBUG
            print("[更新用户超级vip状态] [用户不存在]")
            #endif
            return
        }
        user.is_super_vip = isSuperVip
        try? database.update(table: tableName, on: GLDatingUser.Properties.is_super_vip, with: user)
        GLDatingUserManager.default.isSuperVip.accept(isSuperVip)
    }
    
    /// 更新用户钻石（消费）
    public func updateDiamondWhenCost(costCount: Int) {
        guard let database = self.database else {
            #if DEBUG
            print("[更新用户钻石（消费）] [database不存在]")
            #endif
            return
        }
        
        guard let user = GLDatingUserManager.default.currentUser else {
            #if DEBUG
            print("[更新用户钻石（消费）] [user不存在]")
            #endif
            return
        }
        var value = user.diamond - costCount
        if value < 0 {
            value = 0
        }
        user.diamond = value
        try? database.update(table: tableName, on: GLDatingUser.Properties.diamond, with: user)
        GLDatingUserManager.default.diamond.accept(value)
    }
    
    /// 更新用户钻石（充值）
    public func updateDiamondWhenRecharge(rechargeCount: Int) {
        guard let database = self.database else {
            #if DEBUG
            print("[更新用户钻石（充值）] [database不存在]")
            #endif
            return
        }
        
        guard let user = GLDatingUserManager.default.currentUser else {
            #if DEBUG
            print("[更新用户钻石（充值）] [user不存在]")
            #endif
            return
        }
        var value = user.diamond + rechargeCount
        if value < 0 {
            value = 0
        }
        user.diamond = value
        try? database.update(table: tableName, on: GLDatingUser.Properties.diamond, with: user)
        GLDatingUserManager.default.diamond.accept(value)
    }
}
