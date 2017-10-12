//
//  EventsDAO.swift
//  PersistenceLayer
//
//  Created by Darko on 2017/10/12.
//  Copyright © 2017年 Darko. All rights reserved.
//

import Foundation
import SQLite3


public class EventsDAO: BaseDAO {
    
    public func create(model: Events) -> Int {
        
        if self.openDB() {
            
            let sql = "INSERT INTO EVENTS (EventName, EventIcon, KeyInfo, BasicsInfo, OlympicInfo) VALUES (?,?,?,?,?)"
            
            var statement: OpaquePointer? = nil
            
            // preprocess
            if sqlite3_prepare_v2(db, sql.cString(using: String.Encoding.utf8)!, -1, &statement, nil) == SQLITE_OK {
                
                // start to bind parameter
                sqlite3_bind_text(statement, 1, model.eventName!.cString(using: String.Encoding.utf8.rawValue), -1, nil)
                sqlite3_bind_text(statement, 2, model.eventIcon!.cString(using: String.Encoding.utf8.rawValue), -1, nil)
                sqlite3_bind_text(statement, 3, model.keyInfo!.cString(using: String.Encoding.utf8.rawValue), -1, nil)
                sqlite3_bind_text(statement, 4, model.basicsInfo!.cString(using: String.Encoding.utf8.rawValue), -1, nil)
                sqlite3_bind_text(statement, 5, model.olympicsInfo!.cString(using: String.Encoding.utf8.rawValue), -1, nil)
                
                // execute insertion
                if (sqlite3_step(statement) != SQLITE_DONE) {
                    sqlite3_finalize(statement)
                    sqlite3_close(db)
                    assert(false, "insert data failed")
                }
            }
            sqlite3_finalize(statement)
            sqlite3_close(db)
        }
        return 0
    }
    
    
    
}
