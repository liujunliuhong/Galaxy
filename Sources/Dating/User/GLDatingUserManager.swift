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
    public let sex = BehaviorRelay<GLDatingSexType>(value: .man)
    /// 昵称
    public let nickName = BehaviorRelay<String?>(value: nil)
    /// 年龄
    public let age = BehaviorRelay<Int>(value: 20)
    /// 寻找的性别
    public let lookingForSex = BehaviorRelay<GLDatingSexType>(value: .women)
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
    /// 生日
    public let birth = BehaviorRelay<String?>(value: nil)
    /// 体型（苗条、健美型、很胖等等）
    public let bodyTypeStatus = BehaviorRelay<String?>(value: nil)
    /// 关系状态（单身、离异等等）
    public let relationshipStatus = BehaviorRelay<String?>(value: nil)
    /// 小孩状态（没有小孩、有小孩但是不住在一起等等）
    public let childrenStatus = BehaviorRelay<String?>(value: nil)
    /// 吸烟状态（从不吸烟、偶尔吸烟、经常吸烟等等）
    public let smokeStatus = BehaviorRelay<String?>(value: nil)
    /// 饮酒状态（从不饮酒、偶尔饮酒、经常饮酒等等）
    public let drinkStatus = BehaviorRelay<String?>(value: nil)
    /// 种族（白种人、黄种人等等）
    public let ethnicitiesStatus = BehaviorRelay<String?>(value: nil)
    
    
    /// 是否登录
    public var isLogin: Bool {
        if let _ = UserDefaults.standard.gl_dating_getUserID() {
            GLDatingLog("[已登录]")
            return true
        }
        GLDatingLog("[未登录]")
        return false
    }
    
    private init() {
        
    }
}

extension GLDatingUserManager {
    /// 初始化数据库
    private func _initDatabase() {
        guard let basePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last else { return }
        let dirPath = basePath + "/" + tableDirectory
        var isDirectory: ObjCBool = true
        if !FileManager.default.fileExists(atPath: dirPath, isDirectory: &isDirectory) {
            try? FileManager.default.createDirectory(atPath: dirPath, withIntermediateDirectories: true, attributes: nil)
        }
        let path = dirPath + "/" + tablePath
        
        GLDatingLog("用户信息数据库路径:\(path)")
        
        var configuration = GRDB.Configuration()
        configuration.busyMode = .timeout(10)
        configuration.readonly = false
        do {
            let dbQueue = try DatabaseQueue(path: path, configuration: configuration)
            self.dbQueue = dbQueue
            GLDatingLog("初始化用户数据库成功")
        } catch {
            GLDatingLog("初始化用户数据库失败: \(error.localizedDescription)")
        }
    }
    
    /// 创建用户数据库
    private func _creatUserDatabase() {
        guard let dbQueue = self.dbQueue else {
            GLDatingLog("数据库队列不存在，不能创建用户数据库")
            return
        }
        do {
            try dbQueue.write({ (db) in
                if try db.tableExists(GLDatingUserTableName) {
                    throw GLDatingError.error("用户表已存在，不能再创建")
                }
                try db.create(table: GLDatingUserTableName, temporary: false, ifNotExists: true, body: { (t) in
                    t.column(GLDatingUser.CodingKeys.user_id.rawValue, .text).primaryKey().indexed()
                    t.column(GLDatingUser.CodingKeys.email.rawValue, .text)
                    t.column(GLDatingUser.CodingKeys.sex.rawValue, .integer).defaults(to: GLDatingSexType.man)
                    t.column(GLDatingUser.CodingKeys.looking_for_sex.rawValue, .integer).defaults(to: GLDatingSexType.women)
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
                    t.column(GLDatingUser.CodingKeys.birth.rawValue, .text)
                    t.column(GLDatingUser.CodingKeys.body_type_status.rawValue, .text)
                    t.column(GLDatingUser.CodingKeys.relationship_status.rawValue, .text)
                    t.column(GLDatingUser.CodingKeys.children_status.rawValue, .text)
                    t.column(GLDatingUser.CodingKeys.drink_status.rawValue, .text)
                    t.column(GLDatingUser.CodingKeys.smoke_status.rawValue, .text)
                    t.column(GLDatingUser.CodingKeys.ethnicities_status.rawValue, .text)
                })
            })
            GLDatingLog("用户表创建成功")
        } catch {
            GLDatingLog("用户表创建失败: \(error.localizedDescription)")
        }
    }
}

extension GLDatingUserManager {
    
    /// 创建用户数据库
    public func creatDataBase() {
        self._initDatabase()
        self._creatUserDatabase()
    }
    
    /// 加载用户信息，应该先调用`isLogin`判断是否登录，如果登录了，再调用此方法
    public func loadUserInfo() throws {
        if !self.isLogin {
            GLDatingLog("[获取用户信息] [用户未登录]")
            throw GLDatingError.error("Please sign in")
        }
        guard let userID = UserDefaults.standard.gl_dating_getUserID() else {
            GLDatingLog("[获取用户信息] [userID不存在]")
            throw GLDatingError.error("Please sign in")
        }
        guard let dbQueue = self.dbQueue else {
            GLDatingLog("[获取用户信息] 数据库队列不存在")
            throw GLDatingError.unknownError
        }
        do {
            let user = try dbQueue.write({ (db) -> GLDatingUser? in
                let predicate: GRDB.SQLSpecificExpressible = Column(GLDatingUser.CodingKeys.user_id.rawValue) == userID
                return try GLDatingUser.filter(predicate).fetchOne(db)
            })
            if user == nil {
                throw GLDatingError.error("user not exists")
            }
            self.currentUser = user!
            self.refreshUserInfo()
            GLDatingLog("[获取用户信息成功] \(user!.description)")
        } catch {
            GLDatingLog("[获取用户信息失败] \(error.localizedDescription)")
            throw error
        }
    }
    
    /// 检查邮箱是否重复
    public func checkEmailIsRepeat(email: String) -> Bool {
        guard let dbQueue = self.dbQueue else {
            GLDatingLog("[检查邮箱是否重复] 数据库队列不存在")
            return false
        }
        let count = (try? dbQueue.write({ (db) -> Int in
            let predicate: GRDB.SQLSpecificExpressible = Column(GLDatingUser.CodingKeys.email.rawValue) == email
            return try GLDatingUser.filter(predicate).fetchCount(db)
        })) ?? 0
        GLDatingLog("[检查邮箱是否重复] \(count > 0)")
        return count > 0
    }
    
    /// 注册(如果注册成功，就把用户ID存进UserDefaults)
    public func register(sex: GLDatingSexType,
                         email: String,
                         password: String,
                         nickName: String? = nil,
                         looking_for_sex: GLDatingSexType = .women,
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
                         isSuperVip: Bool = false,
                         birth: String? = nil,
                         bodyTypeStatus: String? = nil,
                         relationshipStatus: String? = nil,
                         childrenStatus: String? = nil,
                         drinkStatus: String? = nil,
                         smokeStatus: String? = nil,
                         ethnicitiesStatus: String? = nil) throws {
        if self.checkEmailIsRepeat(email: email) {
            throw GLDatingError.error("Email has been registered")
        }
        guard let dbQueue = self.dbQueue else {
            GLDatingLog("[注册失败] 数据库队列不存在")
            throw GLDatingError.unknownError
        }
        
        let user = GLDatingUser()
        user.sex = sex
        user.email = email
        user.password = password
        user.nick_name = nickName
        user.age = age
        user.avatar_name = avatar
        user.looking_for_sex = looking_for_sex
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
        user.birth = birth
        user.body_type_status = bodyTypeStatus
        user.relationship_status = relationshipStatus
        user.children_status = childrenStatus
        user.drink_status = drinkStatus
        user.smoke_status = smokeStatus
        user.ethnicities_status = ethnicitiesStatus
        
        do {
            try dbQueue.write({ (db) in
                do {
                    try user.insert(db)
                } catch {
                    throw error
                }
            })
            UserDefaults.standard.gl_dating_set(userID: user.user_id) // 存userID
            GLDatingLog("[注册成功]")
        } catch {
            GLDatingLog("[注册失败] \(error.localizedDescription)")
            throw error
        }
    }
    
    /// 测试账号注册
    public func registerTestAccount(email: String, password: String, sex: GLDatingSexType) {
        guard let dbQueue = self.dbQueue else {
            GLDatingLog("[测试账号注册失败] 数据库队列不存在")
            return
        }
        
        if self.checkEmailIsRepeat(email: email) {
            GLDatingLog("[测试账号已存在，不能再注册]")
            return
        }
        
        let user = GLDatingUser()
        user.sex = sex
        user.email = email
        user.password = password
        user.nick_name = "admin"
        
        do {
            try dbQueue.write({ (db) in
                do {
                    try user.insert(db)
                } catch {
                    throw error
                }
            })
            GLDatingLog("[测试账号注册成功]")
        } catch {
            GLDatingLog("[测试账号注册失败] \(error.localizedDescription)")
        }
    }
    
    /// 登录(根据邮箱和密码在数据库里面查找，如果查询到用户，就把用户ID存进UserDefaults)
    public func login(email: String,
                      password: String) throws {
        guard let dbQueue = self.dbQueue else {
            GLDatingLog("[登录失败] 数据库队列不存在")
            throw GLDatingError.unknownError
        }
        
        do {
            let user = try dbQueue.write({ (db) -> GLDatingUser? in
                let predicate: GRDB.SQLSpecificExpressible =
                    Column(GLDatingUser.CodingKeys.email.rawValue) == email &&
                    Column(GLDatingUser.CodingKeys.password.rawValue) == password
                return try GLDatingUser.filter(predicate).fetchOne(db)
            })
            if user == nil {
                throw GLDatingError.error("Incorrect email or password")
            }
            UserDefaults.standard.gl_dating_set(userID: user!.user_id) // 存userID
            GLDatingLog("[登录成功]")
        } catch {
            GLDatingLog("[登录失败] \(error)")
            throw error
        }
    }
    
    /// 退出登录(会把单列里面的所有信息清除)
    public func logout() {
        self.clearUserInfo()
        self.dbQueue = nil
    }
    
    
    
    /// 删除用户(把当前用户从本地数据库删除)
    public func delete() throws {
        guard let user = self.currentUser else {
            GLDatingLog("[删除用户] [当前用户不存在]")
            throw GLDatingError.unknownError
        }
        guard let dbQueue = self.dbQueue else {
            GLDatingLog("[删除用户] 数据库队列不存在")
            throw GLDatingError.unknownError
        }
        do {
            try dbQueue.write({ (db) -> Void in
                try user.delete(db)
            })
            self.clearUserInfo()
            GLDatingLog("[删除用户成功]")
        } catch {
            GLDatingLog("[删除用户失败] \(error)")
            throw error
        }
    }
    
    /// 打印用户信息
    public func printUserInfo() {
        if !self.isLogin {
            GLDatingLog("[打印用户信息] [用户未登录]")
            return
        }
        guard let userID = UserDefaults.standard.gl_dating_getUserID() else {
            GLDatingLog("[打印用户信息] [userID不存在]")
            return
        }
        guard let dbQueue = self.dbQueue else {
            GLDatingLog("[打印用户信息] 数据库队列不存在")
            return
        }
        do {
            let user = try dbQueue.write({ (db) -> GLDatingUser? in
                let predicate: GRDB.SQLSpecificExpressible = Column(GLDatingUser.CodingKeys.user_id.rawValue) == userID
                return try GLDatingUser.filter(predicate).fetchOne(db)
            })
            if user == nil {
                throw GLDatingError.error("user not exists")
            }
            GLDatingLog("[打印用户信息成功] \(user!.description)")
        } catch {
            GLDatingLog("[打印用户信息失败] \(error.localizedDescription)")
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
        self.lookingForSex.accept(user.looking_for_sex)
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
        self.birth.accept(user.birth)
        self.bodyTypeStatus.accept(user.body_type_status)
        self.relationshipStatus.accept(user.relationship_status)
        self.childrenStatus.accept(user.children_status)
        self.drinkStatus.accept(user.drink_status)
        self.smokeStatus.accept(user.smoke_status)
        self.ethnicitiesStatus.accept(user.ethnicities_status)
    }
    
    private func clearUserInfo() {
        self.currentUser = nil
        UserDefaults.standard.gl_dating_removeUserID()
        self.email.accept(nil)
        self.sex.accept(.man)
        self.lookingForSex.accept(.women)
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
        self.birth.accept(nil)
        self.bodyTypeStatus.accept(nil)
        self.relationshipStatus.accept(nil)
        self.childrenStatus.accept(nil)
        self.drinkStatus.accept(nil)
        self.smokeStatus.accept(nil)
        self.ethnicitiesStatus.accept(nil)
    }
}

extension GLDatingUserManager {
    /// 更新用户性别
    public func updateUserSex(sex: GLDatingSexType) {
        guard let user = GLDatingUserManager.default.currentUser else {
            GLDatingLog("[更新用户性别] [用户不存在]")
            return
        }
        user.sex = sex
        self._update(user: user) {
            GLDatingUserManager.default.sex.accept(sex)
            GLDatingLog("[更新用户性别成功]")
        }
    }
    
    /// 更新用户寻找性别
    public func updateUserLookingForSex(lookingForSex: GLDatingSexType) {
        guard let user = GLDatingUserManager.default.currentUser else {
            GLDatingLog("[更新用户寻找性别] [用户不存在]")
            return
        }
        user.looking_for_sex = lookingForSex
        self._update(user: user) {
            GLDatingUserManager.default.lookingForSex.accept(lookingForSex)
            GLDatingLog("[更新用户寻找性别成功]")
        }
    }
    
    /// 更新用户LookingFor
    public func updateUserLookingFor(lookingFor: String?) {
        guard let user = GLDatingUserManager.default.currentUser else {
            GLDatingLog("[更新用户LookingFor] [用户不存在]")
            return
        }
        user.looking_for = lookingFor
        self._update(user: user) {
            GLDatingUserManager.default.lookingFor.accept(lookingFor)
            GLDatingLog("[更新用户LookingFor成功]")
        }
    }
    
    /// 更新用户AboutMe
    public func updateUserAboutMe(aboutMe: String?) {
        guard let user = GLDatingUserManager.default.currentUser else {
            GLDatingLog("[更新用户AboutMe] [用户不存在]")
            return
        }
        user.about_me = aboutMe
        self._update(user: user) {
            GLDatingUserManager.default.aboutMe.accept(aboutMe)
            GLDatingLog("[更新用户AboutMe成功]")
        }
    }
    
    /// 更新用户照片
    public func updateUserPhotos(photos: [String]) {
        guard let user = GLDatingUserManager.default.currentUser else {
            GLDatingLog("[更新用户照片] [用户不存在]")
            return
        }
        user.photos = photos.gl_jsonEncode
        self._update(user: user) {
            GLDatingUserManager.default.photos.accept(photos)
            GLDatingLog("[更新用户照片成功]")
        }
    }
    
    
    /// 更新用户职业
    public func updateUserProfession(profession: String?) {
        guard let user = GLDatingUserManager.default.currentUser else {
            GLDatingLog("[更新用户职业] [用户不存在]")
            return
        }
        user.profession = profession
        self._update(user: user) {
            GLDatingUserManager.default.profession.accept(profession)
            GLDatingLog("[更新用户职业成功]")
        }
    }
    
    /// 更新用户位置描述
    public func updateUserLocationDescription(locationDescription: String?) {
        guard let user = GLDatingUserManager.default.currentUser else {
            GLDatingLog("[更新用户位置描述] [用户不存在]")
            return
        }
        user.location_description = locationDescription
        self._update(user: user) {
            GLDatingUserManager.default.locationDescription.accept(locationDescription)
            GLDatingLog("[更新用户位置描述成功]")
        }
    }
    
    /// 更新用户城市
    public func updateUserCity(city: String?) {
        guard let user = GLDatingUserManager.default.currentUser else {
            GLDatingLog("[更新用户城市] [用户不存在]")
            return
        }
        user.city = city
        self._update(user: user) {
            GLDatingUserManager.default.city.accept(city)
            GLDatingLog("[更新用户城市成功]")
        }
    }
    
    /// 更新用户国家
    public func updateUserCountry(country: String?) {
        guard let user = GLDatingUserManager.default.currentUser else {
            GLDatingLog("[更新用户国家] [用户不存在]")
            return
        }
        user.country = country
        self._update(user: user) {
            GLDatingUserManager.default.country.accept(country)
            GLDatingLog("[更新用户国家成功]")
        }
    }
    
    /// 更新用户头像
    public func updateUserAvatar(avatarName: String?) {
        guard let user = GLDatingUserManager.default.currentUser else {
            GLDatingLog("[更新用户头像] [用户不存在]")
            return
        }
        user.avatar_name = avatarName
        self._update(user: user) {
            GLDatingUserManager.default.avatarName.accept(avatarName)
            GLDatingLog("[更新用户头像成功]")
        }
    }
    
    /// 更新用户年龄
    public func updateUserAge(age: Int) {
        guard let user = GLDatingUserManager.default.currentUser else {
            GLDatingLog("[更新用户年龄] [用户不存在]")
            return
        }
        user.age = age
        self._update(user: user) {
            GLDatingUserManager.default.age.accept(age)
            GLDatingLog("[更新用户年龄成功]")
        }
    }
    
    /// 更新用户身高
    public func updateUserHeight(height: Int) {
        guard let user = GLDatingUserManager.default.currentUser else {
            GLDatingLog("[更新用户身高] [用户不存在]")
            return
        }
        user.height = height
        self._update(user: user) {
            GLDatingUserManager.default.height.accept(height)
            GLDatingLog("[更新用户身高成功]")
        }
    }
    
    
    /// 更新用户昵称
    public func updateUserNickName(nickName: String?) {
        guard let user = GLDatingUserManager.default.currentUser else {
            GLDatingLog("[更新用户昵称] [用户不存在]")
            return
        }
        user.nick_name = nickName
        self._update(user: user) {
            GLDatingUserManager.default.nickName.accept(nickName)
            GLDatingLog("[更新用户昵称成功]")
        }
    }
    
    /// 更新用户vip状态
    public func updateUserVip(isVip: Bool) {
        guard let user = GLDatingUserManager.default.currentUser else {
            GLDatingLog("[更新用户vip状态] [用户不存在]")
            return
        }
        user.is_vip = isVip
        self._update(user: user) {
            GLDatingUserManager.default.isVip.accept(isVip)
            GLDatingLog("[更新用户vip状态成功]")
        }
    }
    
    /// 更新用户超级vip状态
    public func updateUserSuperVip(isSuperVip: Bool) {
        guard let user = GLDatingUserManager.default.currentUser else {
            GLDatingLog("[更新用户超级vip状态] [用户不存在]")
            return
        }
        user.is_super_vip = isSuperVip
        self._update(user: user) {
            GLDatingUserManager.default.isSuperVip.accept(isSuperVip)
            GLDatingLog("[更新用户超级vip状态成功]")
        }
    }
    
    /// 更新用户钻石（消费）
    public func updateDiamondWhenCost(costCount: Int) {
        guard let user = GLDatingUserManager.default.currentUser else {
            GLDatingLog("[更新用户钻石（消费时）] [user不存在]")
            return
        }
        var value = user.diamond - costCount
        if value < 0 {
            value = 0
        }
        user.diamond = value
        self._update(user: user) {
            GLDatingUserManager.default.diamond.accept(value)
            GLDatingLog("[更新用户钻石（消费时）成功]")
        }
    }
    
    /// 更新用户钻石（充值）
    public func updateDiamondWhenRecharge(rechargeCount: Int) {
        guard let user = GLDatingUserManager.default.currentUser else {
            GLDatingLog("[更新用户钻石（充值时）] [user不存在]")
            return
        }
        var value = user.diamond + rechargeCount
        if value < 0 {
            value = 0
        }
        user.diamond = value
        self._update(user: user) {
            GLDatingUserManager.default.diamond.accept(value)
            GLDatingLog("[更新用户钻石（充值时）成功]")
        }
    }
    
    /// 更新用户生日
    public func updateUserBirth(birth: String?) {
        guard let user = GLDatingUserManager.default.currentUser else {
            GLDatingLog("[更新用户生日] [用户不存在]")
            return
        }
        user.birth = birth
        self._update(user: user) {
            GLDatingUserManager.default.birth.accept(birth)
            GLDatingLog("[更新用户生日成功]")
        }
    }
    
    /// 更新用户体型（苗条、健美型、很胖等等）
    public func updateUserBodyTypeStatus(bodyTypeStatus: String?) {
        guard let user = GLDatingUserManager.default.currentUser else {
            GLDatingLog("[更新用户体型] [用户不存在]")
            return
        }
        user.body_type_status = bodyTypeStatus
        self._update(user: user) {
            GLDatingUserManager.default.bodyTypeStatus.accept(bodyTypeStatus)
            GLDatingLog("[更新用户体型成功]")
        }
    }
    
    /// 更新用户关系状态（单身、离异等等）
    public func updateUserRelationshipStatus(relationshipStatus: String?) {
        guard let user = GLDatingUserManager.default.currentUser else {
            GLDatingLog("[更新用户关系状态] [用户不存在]")
            return
        }
        user.relationship_status = relationshipStatus
        self._update(user: user) {
            GLDatingUserManager.default.relationshipStatus.accept(relationshipStatus)
            GLDatingLog("[更新用户关系状态成功]")
        }
    }
    
    /// 更新用户小孩状态（没有小孩、有小孩但是不住在一起等等）
    public func updateUserChildrenStatus(childrenStatus: String?) {
        guard let user = GLDatingUserManager.default.currentUser else {
            GLDatingLog("[更新用户小孩状态] [用户不存在]")
            return
        }
        user.children_status = childrenStatus
        self._update(user: user) {
            GLDatingUserManager.default.childrenStatus.accept(childrenStatus)
            GLDatingLog("[更新用户小孩状态成功]")
        }
    }
    
    /// 更新用户吸烟状态（从不吸烟、偶尔吸烟、经常吸烟等等）
    public func updateUserSmokeStatus(smokeStatus: String?) {
        guard let user = GLDatingUserManager.default.currentUser else {
            GLDatingLog("[更新用户吸烟状态] [用户不存在]")
            return
        }
        user.smoke_status = smokeStatus
        self._update(user: user) {
            GLDatingUserManager.default.smokeStatus.accept(smokeStatus)
            GLDatingLog("[更新用户吸烟状态成功]")
        }
    }
    
    /// 更新用户饮酒状态（从不饮酒、偶尔饮酒、经常饮酒等等）
    public func updateUserDrinkStatus(drinkStatus: String?) {
        guard let user = GLDatingUserManager.default.currentUser else {
            GLDatingLog("[更新用户饮酒状态] [用户不存在]")
            return
        }
        user.drink_status = drinkStatus
        self._update(user: user) {
            GLDatingUserManager.default.drinkStatus.accept(drinkStatus)
            GLDatingLog("[更新用户饮酒状态成功]")
        }
    }
    
    /// 更新用户种族（白种人、黄种人等等）
    public func updateUserEthnicitiesStatus(ethnicitiesStatus: String?) {
        guard let user = GLDatingUserManager.default.currentUser else {
            GLDatingLog("[更新用户种族] [用户不存在]")
            return
        }
        user.ethnicities_status = ethnicitiesStatus
        self._update(user: user) {
            GLDatingUserManager.default.ethnicitiesStatus.accept(ethnicitiesStatus)
            GLDatingLog("[更新用户种族成功]")
        }
    }
}

extension GLDatingUserManager {
    private func _update(user: GLDatingUser, completion: (() -> Void)?) {
        guard let dbQueue = self.dbQueue else {
            GLDatingLog("[更新用户信息失败] 数据库队列不存在")
            return
        }
        do {
            try dbQueue.write({ (db) -> Void in
                try user.update(db)
            })
            completion?()
        } catch {
            GLDatingLog("[更新用户信息失败] \(error.localizedDescription)")
        }
    }
}
