//
//  BaseDAO.swift
//  PersistenceLayer
//
//  Created by Darko on 2017/10/12.
//  Copyright © 2017年 Darko. All rights reserved.
//

import Foundation
import SQLite3

public class BaseDAO: NSObject {
    
    // sqlite3 *db
    var db: OpaquePointer? = nil
    
    override public init() {
        //database initialization
        DBHelper.initDB()
    }
    
    // open SQLite database
    public func openDB() -> Bool {
        
        // database file full path
        let dbFilePath = DBHelper.applicationDocumentsDirectoryFile(fileName: DB_FILE_NAME as NSString)!
        
        print("DBFilePath = \(String(cString: dbFilePath))")
        
        if sqlite3_open(dbFilePath, &db) != SQLITE_OK {
            sqlite3_close(db)
            print("open database failed")
            return false
        }
        return true
    }
}
