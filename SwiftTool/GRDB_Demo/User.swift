//
//  User.swift
//  SwiftTool
//
//  Created by Yule on 2020/12/10.
//  Copyright © 2020 yinhe. All rights reserved.
//

import Foundation
import GRDB

struct DataBaseName {
    /// 数据库名字
    static let test = "test.db"
}

/// 数据库表名
struct TableName {
    /// 学生
    static let student = "student"
}


class DBManager {
    /// 数据库路径
    private static var dbPath: String = {
        let filePath: String = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first!.appending("/\(DataBaseName.test)")
        return filePath
    }()
    
    /// 数据库配置
    private static var configuration: Configuration {
        var configuration = Configuration()
        configuration.busyMode = .timeout(10)
        return configuration
    }
    
    
    static let `default` = DBManager()
    
    let dbQueue: DatabaseQueue?
    
    init() {
        let dbQueue = try? DatabaseQueue(path: DBManager.dbPath, configuration: DBManager.configuration)
        dbQueue?.releaseMemory()
        self.dbQueue = dbQueue
    }
    
    
}

extension DBManager {
    /// 创建表
    func creatTable() {
        try? self.dbQueue?.inDatabase({ (db) in
            if try db.tableExists(TableName.student) {
                MyLog("数据库表存在，不能创建")
                return
            }
            try? db.create(table: TableName.student, temporary: false, ifNotExists: true) { (t) in
                t.column(Student.MyColumns.ID.rawValue, .text).notNull().primaryKey().indexed()
                t.column(Student.MyColumns.student_name.rawValue, .text)
                t.column(Student.MyColumns.age.rawValue, .integer)
                MyLog("数据库表创建成功")
            }
        })
    }
    /// 插入
    func insert(student: Student) {
        try? self.dbQueue?.inTransaction{ (db) -> Database.TransactionCompletion in
            do {
                var student = student
                try student.insert(db) // 要实现`MutablePersistableRecord`协议，才能执行insert
                MyLog("插入数据成功")
                return .commit
            } catch {
                return .rollback
            }
        }
    }
    
    /// 查询
    func query(studentName: String?) -> [Student]? {
        return try? self.dbQueue?.read({ (db) -> [Student]? in
            return try? Student.filter(Column(Student.MyColumns.student_name.rawValue) == studentName).fetchAll(db)
        })
    }
}



class Student: Codable {
    var ID: String = UUID().uuidString
    var student_name: String?
    var age: Int = 20
    
    
    enum MyColumns: String, CodingKey, ColumnExpression {
        case ID
        case student_name
        case age
    }
}

extension Student: MutablePersistableRecord, FetchableRecord, TableRecord {
    
    
    
    
}
