//
//  PoetryDBManager.swift
//  SwiftCase
//
//  Created by 伍腾飞 on 2017/5/21.
//  Copyright © 2017年 Shepherd. All rights reserved.
//

import UIKit

// DAO 诗词数据访问接口
class PoetryDBManager: NSObject {
    
    static let shared = PoetryDBManager()
    
    var db: OpaquePointer?
    
    override init() {
        super.init()
        
        // 移动数据库到Documents中, 会自动备份(iTunes,iCloud)
        var srcPath: String?
        var desPath: String?
        if let path = Bundle.main.path(forResource: "Poetry", ofType: "bundle") {
            srcPath = path + "sqlite.db"
        }
        if let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
            desPath = path + "poetry.sqlite"
        }
        guard srcPath != nil && desPath != nil else {
            return
        }
        if !FileManager.default.fileExists(atPath: desPath!) {
            try? FileManager.default.copyItem(atPath: srcPath!, toPath: desPath!)
        } else {
            
        }
        // 数据库的操作句柄
        let ret = sqlite3_open(desPath!, &db)
        if ret != SQLITE_OK {
            print("打开数据库失败：\(sqlite3_errmsg(db))")
        }
    }
    
    // 获取诗词所有类型 五言古诗、七言律诗
    class func getPoetryKinds() -> [PoetryKind] {
        // 最好不要用 select * from T_KIND
        let sql = "SELECT D_KIND, D_NUM, D_INTROKIND, D_INTROKIND2 FROM T_KIND"
        var stmt: OpaquePointer?
        if let db = PoetryDBManager.shared.db {
            if sqlite3_prepare_v2(db, sql, -1, &stmt, nil) == SQLITE_OK {
                var kinds: [PoetryKind] = []
                while sqlite3_step(stmt) == SQLITE_ROW {
                    let kind = PoetryKind()
                    kind.kindName = String(cString: sqlite3_column_text(stmt, 1)!)
                    kind.kindID = Int(String(cString: sqlite3_column_text(stmt, 2)!)) ?? 0
                    kind.kindDesc = String(cString: sqlite3_column_text(stmt, 3)!)
                    kind.kindComment = String(cString: sqlite3_column_text(stmt, 4)!)
                    kinds.append(kind)
                }
                sqlite3_finalize(stmt)
                return kinds
            } else {
                print("query error")
            }
        }
        return []
    }
    
    // 查询此分类下的所有古诗
    class func getPoetries(by kindName: String) -> [Poetry] {
        
        return []
    }
    
    // 根据分类删除古诗
    class func deletePoetry(byKindName kindName: String) -> Bool {
        
        return false
    }
    
    // 删除某一首古诗
    class func deletePoetry(byID ID: Int) -> Bool {
        
        return false
    }
    
}
