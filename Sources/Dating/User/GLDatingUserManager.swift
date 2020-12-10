//
//  GLDatingUserManager.swift
//  SwiftTool
//
//  Created by Yule on 2020/12/8.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import GRDB
import RxSwift
import RxCocoa

private let tableDirectory = "GLDatingUserDatabase"
private let tablePath = "user.db"


public class GLDatingUserManager {
    /// 单列
    public static let `default` = GLDatingUserManager()
    
    
    private var dbQueue: DatabaseQueue?
    
    
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
        self.creatUserDatabase()
    }
}

extension GLDatingUserManager {
    /// 初始化数据库
    private func initDatabase() {
        guard let basePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last else { return }
        let dirPath = basePath + "/" + tableDirectory
        var isDirectory: ObjCBool = true
        if !FileManager.default.fileExists(atPath: dirPath, isDirectory: &isDirectory) {
            try? FileManager.default.createDirectory(atPath: dirPath, withIntermediateDirectories: true, attributes: nil)
        }
        let path = dirPath + "/" + tablePath
        #if DEBUG
        print("用户信息数据库路径:\(path)")
        #endif
        var configuration = GRDB.Configuration()
        configuration.busyMode = .timeout(10)
        configuration.readonly = false
        do {
            let dbQueue = try DatabaseQueue(path: path, configuration: configuration)
            self.dbQueue = dbQueue
            #if DEBUG
            print("初始化用户数据库成功")
            #endif
        } catch {
            #if DEBUG
            print("初始化用户数据库失败: \(error.localizedDescription)")
            #endif
        }
    }
    
    /// 创建用户数据库
    private func creatUserDatabase() {
        do {
            try self.dbQueue?.write({ (db) in
                if try db.tableExists(GLDatingUserTableName) {
                    throw GLDatingError.error("用户表已存在，不能再创建")
                }
                try db.create(table: GLDatingUserTableName, temporary: false, ifNotExists: true, body: { (t) in
                    t.column(GLDatingUser.CodingKeys.user_id.rawValue, .text).primaryKey().indexed()
                    t.column(GLDatingUser.CodingKeys.email.rawValue, .text)
                    t.column(GLDatingUser.CodingKeys.sex.rawValue, .integer).defaults(to: GLDatingSexType.man)
                    t.column(GLDatingUser.CodingKeys.nick_name.rawValue, .text)
                    t.column(GLDatingUser.CodingKeys.age.rawValue, .integer).defaults(to: 25)
                    t.column(GLDatingUser.CodingKeys.height.rawValue, .integer).defaults(to: 170)
                    t.column(GLDatingUser.CodingKeys.password.rawValue, .text)
                    t.column(GLDatingUser.CodingKeys.avatar_name.rawValue, .text)
                    t.column(GLDatingUser.CodingKeys.photos.rawValue, .text)
                    t.column(GLDatingUser.CodingKeys.country.rawValue, .text)
                    t.column(GLDatingUser.CodingKeys.city.rawValue, .text)
                    t.column(GLDatingUser.CodingKeys.location_description.rawValue, .text)
                    t.column(GLDatingUser.CodingKeys.profession.rawValue, .text)
                    t.column(GLDatingUser.CodingKeys.about_me.rawValue, .text)
                    t.column(GLDatingUser.CodingKeys.looking_for.rawValue, .text)
                    t.column(GLDatingUser.CodingKeys.diamond.rawValue, .integer).defaults(to: 0)
                    t.column(GLDatingUser.CodingKeys.is_vip.rawValue, .boolean).defaults(to: false)
                    t.column(GLDatingUser.CodingKeys.is_super_vip.rawValue, .boolean).defaults(to: false)
                })
            })
            #if DEBUG
            print("用户表创建成功")
            #endif
        } catch {
            #if DEBUG
            print("用户表创建失败: \(error.localizedDescription)")
            #endif
        }
    }
}

extension GLDatingUserManager {
    
    /// 加载用户信息，应该先调用`isLogin`判断是否登录，如果登录了，再调用此方法
    public func loadUserInfo() throws {
        if !self.isLogin {
            #if DEBUG
            print("[获取用户信息] [用户未登录]")
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
            let user = try self.dbQueue?.write({ (db) -> GLDatingUser? in
                return try GLDatingUser.filter(Column(GLDatingUser.CodingKeys.user_id.rawValue) == userID).fetchOne(db)
            })
            if user == nil {
                throw GLDatingError.error("user not exists")
            }
            self.currentUser = user!
            self.refreshUserInfo()
            #if DEBUG
            print("[获取用户信息成功] \(user!.description)")
            #endif
        } catch {
            #if DEBUG
            print("[获取用户信息失败] \(error.localizedDescription)")
            #endif
            throw error
        }
    }
    
    /// 检查邮箱是否重复
    public func checkEmailIsRepeat(email: String) -> Bool {
        let count = (try? self.dbQueue?.write({ (db) -> Int in
            return try GLDatingUser.filter(Column(GLDatingUser.CodingKeys.email.rawValue) == email).fetchCount(db)
        })) ?? 0
        #if DEBUG
        print("[检查邮箱是否重复] \(count > 0)")
        #endif
        return count > 0
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
        
        if self.checkEmailIsRepeat(email: email) {
            throw GLDatingError.error("Email has been registered")
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
            try self.dbQueue?.write({ (db) in
                var user = user
                do {
                    try user.insert(db)
                } catch {
                    throw error
                }
            })
            UserDefaults.standard.gl_dating_set(userID: user.user_id) // 存userID
            #if DEBUG
            print("[注册成功]")
            #endif
        } catch {
            #if DEBUG
            print("[注册失败] \(error.localizedDescription)")
            #endif
            throw error
        }
    }
    
    /// 测试账号注册
    public func registerTestAccount(email: String, password: String, sex: GLDatingSexType) {
        if self.checkEmailIsRepeat(email: email) {
            #if DEBUG
            print("[测试账号已存在，不能再注册]")
            #endif
            return
        }
        
        let user = GLDatingUser()
        user.sex = sex
        user.email = email
        user.password = password
        user.nick_name = "admin"
        
        do {
            try self.dbQueue?.write({ (db) in
                var user = user
                do {
                    try user.insert(db)
                } catch {
                    throw error
                }
            })
            #if DEBUG
            print("[测试账号注册成功]")
            #endif
        } catch {
            #if DEBUG
            print("[注册失败] \(error.localizedDescription)")
            #endif
        }
    }
    
    /// 登录(根据邮箱和密码在数据库里面查找，如果查询到用户，就把用户ID存进UserDefaults)
    public func login(email: String,
                      password: String) throws {
        
        do {
            let user = try self.dbQueue?.write({ (db) -> GLDatingUser? in
                return try GLDatingUser.filter(Column(GLDatingUser.CodingKeys.email.rawValue) == email && Column(GLDatingUser.CodingKeys.password.rawValue) == password).fetchOne(db)
            })
            if user == nil {
                throw GLDatingError.error("Incorrect email or password")
            }
            UserDefaults.standard.gl_dating_set(userID: user!.user_id) // 存userID
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
        guard let user = self.currentUser else {
            #if DEBUG
            print("[删除用户] [当前用户不存在]")
            #endif
            throw GLDatingError.unknownError
        }
        do {
            try self.dbQueue?.write({ (db) -> Void in
                try user.delete(db)
            })
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
    
    /// 打印用户信息
    public func printUserInfo() {
        if !self.isLogin {
            #if DEBUG
            print("[打印用户信息] [用户未登录]")
            #endif
            return
        }
        guard let userID = UserDefaults.standard.gl_dating_getUserID() else {
            #if DEBUG
            print("[打印用户信息] [userID不存在]")
            #endif
            return
        }
        do {
            let user = try self.dbQueue?.write({ (db) -> GLDatingUser? in
                return try GLDatingUser.filter(Column(GLDatingUser.CodingKeys.user_id.rawValue) == userID).fetchOne(db)
            })
            if user == nil {
                throw GLDatingError.error("user not exists")
            }
            #if DEBUG
            print("[打印用户信息成功] \(user!.description)")
            #endif
        } catch {
            #if DEBUG
            print("[打印用户信息失败] \(error.localizedDescription)")
            #endif
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
        guard let user = GLDatingUserManager.default.currentUser else {
            #if DEBUG
            print("[更新用户性别] [用户不存在]")
            #endif
            return
        }
        user.sex = sex
        self._update(user: user) {
            GLDatingUserManager.default.sex.accept(sex)
            #if DEBUG
            print("[更新用户性别成功]")
            #endif
        }
    }
    
    /// 更新用户LookingFor
    public func updateUserLookingFor(lookingFor: String?) {
        guard let user = GLDatingUserManager.default.currentUser else {
            #if DEBUG
            print("[更新用户LookingFor] [用户不存在]")
            #endif
            return
        }
        user.looking_for = lookingFor
        self._update(user: user) {
            GLDatingUserManager.default.lookingFor.accept(lookingFor)
            #if DEBUG
            print("[更新用户LookingFor成功]")
            #endif
        }
    }
    
    /// 更新用户AboutMe
    public func updateUserAboutMe(aboutMe: String?) {
        guard let user = GLDatingUserManager.default.currentUser else {
            #if DEBUG
            print("[更新用户AboutMe] [用户不存在]")
            #endif
            return
        }
        user.about_me = aboutMe
        self._update(user: user) {
            GLDatingUserManager.default.aboutMe.accept(aboutMe)
            #if DEBUG
            print("[更新用户AboutMe成功]")
            #endif
        }
    }
    
    /// 更新用户照片
    public func updateUserPhotos(photos: [String]) {
        guard let user = GLDatingUserManager.default.currentUser else {
            #if DEBUG
            print("[更新用户照片] [用户不存在]")
            #endif
            return
        }
        user.photos = photos.gl_jsonEncode
        self._update(user: user) {
            GLDatingUserManager.default.photos.accept(photos)
            #if DEBUG
            print("[更新用户照片成功]")
            #endif
        }
    }
    
    
    /// 更新用户职业
    public func updateUserProfession(profession: String?) {
        guard let user = GLDatingUserManager.default.currentUser else {
            #if DEBUG
            print("[更新用户职业] [用户不存在]")
            #endif
            return
        }
        user.profession = profession
        self._update(user: user) {
            GLDatingUserManager.default.profession.accept(profession)
            #if DEBUG
            print("[更新用户职业成功]")
            #endif
        }
    }
    
    /// 更新用户位置描述
    public func updateUserLocationDescription(locationDescription: String?) {
        guard let user = GLDatingUserManager.default.currentUser else {
            #if DEBUG
            print("[更新用户位置描述] [用户不存在]")
            #endif
            return
        }
        user.location_description = locationDescription
        self._update(user: user) {
            GLDatingUserManager.default.locationDescription.accept(locationDescription)
            #if DEBUG
            print("[更新用户位置描述成功]")
            #endif
        }
    }
    
    /// 更新用户城市
    public func updateUserCity(city: String?) {
        guard let user = GLDatingUserManager.default.currentUser else {
            #if DEBUG
            print("[更新用户城市] [用户不存在]")
            #endif
            return
        }
        user.city = city
        self._update(user: user) {
            GLDatingUserManager.default.city.accept(city)
            #if DEBUG
            print("[更新用户城市成功]")
            #endif
        }
    }
    
    /// 更新用户国家
    public func updateUserCountry(country: String?) {
        guard let user = GLDatingUserManager.default.currentUser else {
            #if DEBUG
            print("[更新用户国家] [用户不存在]")
            #endif
            return
        }
        user.country = country
        self._update(user: user) {
            GLDatingUserManager.default.country.accept(country)
            #if DEBUG
            print("[更新用户国家成功]")
            #endif
        }
    }
    
    /// 更新用户头像
    public func updateUserAvatar(avatarName: String?) {
        guard let user = GLDatingUserManager.default.currentUser else {
            #if DEBUG
            print("[更新用户头像] [用户不存在]")
            #endif
            return
        }
        user.avatar_name = avatarName
        self._update(user: user) {
            GLDatingUserManager.default.avatarName.accept(avatarName)
            #if DEBUG
            print("[更新用户头像成功]")
            #endif
        }
    }
    
    /// 更新用户年龄
    public func updateUserAge(age: Int) {
        guard let user = GLDatingUserManager.default.currentUser else {
            #if DEBUG
            print("[更新用户年龄] [用户不存在]")
            #endif
            return
        }
        user.age = age
        self._update(user: user) {
            GLDatingUserManager.default.age.accept(age)
            #if DEBUG
            print("[更新用户年龄成功]")
            #endif
        }
    }
    
    /// 更新用户身高
    public func updateUserHeight(height: Int) {
        guard let user = GLDatingUserManager.default.currentUser else {
            #if DEBUG
            print("[更新用户身高] [用户不存在]")
            #endif
            return
        }
        user.height = height
        self._update(user: user) {
            GLDatingUserManager.default.height.accept(height)
            #if DEBUG
            print("[更新用户身高成功]")
            #endif
        }
    }
    
    
    /// 更新用户昵称
    public func updateUserNickName(nickName: String?) {
        guard let user = GLDatingUserManager.default.currentUser else {
            #if DEBUG
            print("[更新用户昵称] [用户不存在]")
            #endif
            return
        }
        user.nick_name = nickName
        self._update(user: user) {
            GLDatingUserManager.default.nickName.accept(nickName)
            #if DEBUG
            print("[更新用户昵称成功]")
            #endif
        }
    }
    
    /// 更新用户vip状态
    public func updateUserVip(isVip: Bool) {
        guard let user = GLDatingUserManager.default.currentUser else {
            #if DEBUG
            print("[更新用户vip状态] [用户不存在]")
            #endif
            return
        }
        user.is_vip = isVip
        self._update(user: user) {
            GLDatingUserManager.default.isVip.accept(isVip)
            #if DEBUG
            print("[更新用户vip状态成功]")
            #endif
        }
    }
    
    /// 更新用户超级vip状态
    public func updateUserSuperVip(isSuperVip: Bool) {
        guard let user = GLDatingUserManager.default.currentUser else {
            #if DEBUG
            print("[更新用户超级vip状态] [用户不存在]")
            #endif
            return
        }
        user.is_super_vip = isSuperVip
        self._update(user: user) {
            GLDatingUserManager.default.isSuperVip.accept(isSuperVip)
            #if DEBUG
            print("[更新用户超级vip状态成功]")
            #endif
        }
    }
    
    /// 更新用户钻石（消费）
    public func updateDiamondWhenCost(costCount: Int) {
        guard let user = GLDatingUserManager.default.currentUser else {
            #if DEBUG
            print("[更新用户钻石（消费时）] [user不存在]")
            #endif
            return
        }
        var value = user.diamond - costCount
        if value < 0 {
            value = 0
        }
        user.diamond = value
        self._update(user: user) {
            GLDatingUserManager.default.diamond.accept(value)
            #if DEBUG
            print("[更新用户钻石（消费时）成功]")
            #endif
        }
    }
    
    /// 更新用户钻石（充值）
    public func updateDiamondWhenRecharge(rechargeCount: Int) {
        guard let user = GLDatingUserManager.default.currentUser else {
            #if DEBUG
            print("[更新用户钻石（充值时）] [user不存在]")
            #endif
            return
        }
        var value = user.diamond + rechargeCount
        if value < 0 {
            value = 0
        }
        user.diamond = value
        self._update(user: user) {
            GLDatingUserManager.default.diamond.accept(value)
            #if DEBUG
            print("[更新用户钻石（充值时）成功]")
            #endif
        }
    }
}

extension GLDatingUserManager {
    private func _update(user: GLDatingUser, completion: (() -> Void)?) {
        do {
            try self.dbQueue?.write({ (db) -> Void in
                try user.update(db)
            })
            completion?()
        } catch {
            #if DEBUG
            print("[更新用户信息失败] \(error.localizedDescription)")
            #endif
        }
    }
}
