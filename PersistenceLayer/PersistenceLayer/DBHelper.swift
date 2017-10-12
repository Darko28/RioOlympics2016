//
//  DBHelper.swift
//  PersistenceLayer
//
//  Created by Darko on 2017/10/12.
//  Copyright © 2017年 Darko. All rights reserved.
//

import Foundation
import SQLite3

let DB_FILE_NAME = "app.db"

public class DBHelper {
    
    // sqlite3 *db
    static var db: OpaquePointer? = nil
    
    // obtain application sandbox document directory's full path
    static func applicationDocumentsDirectoryFile(fileName: NSString) -> [CChar]? {
        
        let documentDirectory: [NSString] = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true) as [NSString]
        let path = documentDirectory[0].strings(byAppendingPaths: [DB_FILE_NAME])
        let cpath = path[0].cString(using: String.Encoding.utf8)
        return cpath
    }
    
    // initialization and load data
    public static func initDB() {
        
        let frameworkBundle = Bundle(for: DBHelper.self)
        
        let configTablePath = frameworkBundle.path(forResource: "DBConfig", ofType: "plist")
        
        let configTable = NSDictionary(contentsOfFile: configTablePath!)
        
        // obtain the database version number from the configuration file
        var dbConfigVersion = configTable?["DB_VERSION"] as? NSNumber
        if (dbConfigVersion == nil) {
            dbConfigVersion = 0
        }
        
        // database version number obtained from DBVersionInfo table
        let versionNumber = DBHelper.dbVersionNumber()
        
        // version number is not the same
        if dbConfigVersion!.intValue != versionNumber {
            
            let dbFilePath = DBHelper.applicationDocumentsDirectoryFile(fileName: DB_FILE_NAME as NSString)
            if sqlite3_open(dbFilePath!, &db) == SQLITE_OK {
                // load data to the business table
                print("database upgrade ...")
                
                let createtablePath = frameworkBundle.path(forResource: "create_load", ofType: "sql")
                let sql = try? NSString(contentsOfFile: createtablePath!, encoding: String.Encoding.utf8.rawValue)
                let csql = sql?.cString(using: String.Encoding.utf8.rawValue)
                
                sqlite3_exec(db, csql!, nil, nil, nil)
                
                // write the current version number back to the file
                let usql = NSString(format: "update DBVersionInfo set version_number = %i", dbConfigVersion!.intValue)
                let cusql = usql.cString(using: String.Encoding.utf8.rawValue)
                
                sqlite3_exec(db, cusql!, nil, nil, nil)
            } else {
                print("database opened failure")
            }
            sqlite3_close(db)
        }
    }
    
    static func dbVersionNumber() -> Int32 {
        
        var versionNumber: Int32 = -1
        
        let dbFilePath = DBHelper.applicationDocumentsDirectoryFile(fileName: DB_FILE_NAME as NSString)
        
        if sqlite3_open(dbFilePath!, &db) == SQLITE_OK {
            
            let sql = "create table if not exists DBVersionInfo ( version_number int )"
            let cSql = sql.cString(using: String.Encoding.utf8)
            
            sqlite3_exec(db, cSql!, nil, nil, nil)
            
            let qsql = "select version_number from DBVersionInfo"
            let cqsql = qsql.cString(using: String.Encoding.utf8)
            
            var statement: OpaquePointer? = nil
            
            // preprocess
            if sqlite3_prepare_v2(db, cqsql!, -1, &statement, nil) == SQLITE_OK {
                // execute acquirement
                if (sqlite3_step(statement) == SQLITE_ROW) {
                    // have data
                    print("have data")
                    versionNumber = Int32(sqlite3_column_int(statement, 0))
                } else {
                    print("no data")
                    let insertSql = "insert into DBVersionInfo (version_number) values(-1)"
                    let cInsertSql = insertSql.cString(using: String.Encoding.utf8)
                    sqlite3_exec(db, cInsertSql!, nil, nil, nil)
                }
            }
            sqlite3_finalize(statement)
            sqlite3_close(db)
        } else {
            sqlite3_close(db)
        }
        return versionNumber
    }
    
    
}
