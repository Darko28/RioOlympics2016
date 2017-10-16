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
    
    public static let sharedInstance: EventsDAO = {
        let instance = EventsDAO()
        return instance
    }()
    
    public func create(model: Events) -> Int {
        
        if self.openDB() {
            
            let sql = "INSERT INTO Events (EventName, EventIcon, KeyInfo, BasicsInfo, OlympicInfo) VALUES (?,?,?,?,?)"
            
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
    
    public func remove(model: Events) -> Int {
        
        if self.openDB() {
            // first delete the sub-table(Schedule table) relate data
            let sqlScheduleStr = NSString(format: "DELETE from Schedule where eventID=%i", model.eventID!)
            // start transaction, commit previous transaction immediately
            sqlite3_exec(db, "BEGIN IMMEDIATE TRANSACTION", nil, nil, nil)
            
            if sqlite3_exec(db, sqlScheduleStr.cString(using: String.Encoding.utf8.rawValue), nil, nil, nil) != SQLITE_OK {
                // roll back the transaction
                sqlite3_exec(db, "ROLLBACK TRANSACTION", nil, nil, nil)
                assert(false, "delete data failed")
            }
            
            // delete main table (Events) data
            let sqlEventsStr = NSString(format: "DELETE from Events where eventID=%i", model.eventID!)
            if sqlite3_exec(db, sqlEventsStr.cString(using: String.Encoding.utf8.rawValue), nil, nil, nil) != SQLITE_OK {
                // roll back transaction
                sqlite3_exec(db, "ROLLBACK TRANSACTION", nil, nil, nil)
                assert(false, "failed to delete data")
            }
            
            // commit transaction
            sqlite3_exec(db, "COMMIT TRANSACTION", nil, nil, nil)
            
            sqlite3_close(db)
        }
        
        return 0
    }
    
    public func findAll() -> NSMutableArray {
        
        let listData = NSMutableArray()
        
        if self.openDB() {
            
            let qsql = "SELECT eventName, eventIcon, keyInfo, basicsInfo, olympicInfo, eventID FROM Events"
            
            var statement: OpaquePointer? = nil
            
            // preprocess
            if sqlite3_prepare_v2(db, qsql.cString(using: String.Encoding.utf8)!, -1, &statement, nil) == SQLITE_OK {
                
                // execute
                while sqlite3_step(statement) == SQLITE_ROW {
                    
                    let events = Events()
                    
//                    let cEventName = UnsafePointer<Int8>(sqlite3_column_text(statement, 0))
//                    events.eventName = String.cString(cEventName)
                    
                    var cEventIcon = UnsafePointer(sqlite3_column_text(statement, 1))?.withMemoryRebound(to: Int8.self, capacity: 0) { $0.pointee }
                    events.eventIcon = NSString.init(cString: &cEventIcon!, encoding: String.Encoding.utf8.rawValue)

                    if let cKeyInfo = UnsafeRawPointer.init(sqlite3_column_text(statement, 2)) {
                        let uKeyInfo = cKeyInfo.bindMemory(to: CChar.self, capacity: 0)
                        events.keyInfo = NSString.init(cString: uKeyInfo, encoding: String.Encoding.utf8.rawValue)
                    }

                    let cBasicsInfo = UnsafeRawPointer(sqlite3_column_text(statement, 3))
                    events.basicsInfo = NSString.init(cString: (cBasicsInfo?.bindMemory(to: CChar.self, capacity: 0))!, encoding: String.Encoding.utf8.rawValue)

                    if let cOlympicInfo = UnsafeRawPointer(sqlite3_column_text(statement, 4)) {
                        events.olympicsInfo = String(validatingUTF8: cOlympicInfo.bindMemory(to: CChar.self, capacity: 0))! as NSString
                    }

                    events.eventID = Int(sqlite3_column_int(statement, 5))
                    
                    listData.add(events)
                }
            }
            sqlite3_finalize(statement)
            sqlite3_close(db)
        }
        return listData
    }
    
    
    public func findById(model: Events) -> Events? {
        
        if self.openDB() {
            
            let qsql = "SELECT eventName,eventIcon,keyInfo,basicsInfo,olympicInfo,eventID FROM Events where EventID =?"
            var statement: OpaquePointer? = nil
            
            //预处理过程
            if sqlite3_prepare_v2(db, qsql.cString(using: String.Encoding.utf8)!, -1, &statement, nil) == SQLITE_OK {
                //绑定参数开始
                sqlite3_bind_int(statement, 1, Int32(model.eventID!))
                //执行
                while sqlite3_step(statement) == SQLITE_ROW {
                    
                    let events = Events()
                    
                    //                    let cEventName = UnsafePointer<Int8>(sqlite3_column_text(statement, 0))
                    //                    events.eventName = String.cString(cEventName)
                    
                    var cEventIcon = UnsafePointer(sqlite3_column_text(statement, 1))?.withMemoryRebound(to: Int8.self, capacity: 0) { $0.pointee }
                    events.eventIcon = NSString.init(cString: &cEventIcon!, encoding: String.Encoding.utf8.rawValue)
                    
                    if let cKeyInfo = UnsafeRawPointer.init(sqlite3_column_text(statement, 2)) {
                        let uKeyInfo = cKeyInfo.bindMemory(to: CChar.self, capacity: 0)
                        events.keyInfo = NSString.init(cString: uKeyInfo, encoding: String.Encoding.utf8.rawValue)
                    }
                    
                    let cBasicsInfo = UnsafeRawPointer(sqlite3_column_text(statement, 3))
                    events.basicsInfo = NSString.init(cString: (cBasicsInfo?.bindMemory(to: CChar.self, capacity: 0))!, encoding: String.Encoding.utf8.rawValue)
                    
                    if let cOlympicInfo = UnsafeRawPointer(sqlite3_column_text(statement, 4)) {
                        events.olympicsInfo = String(validatingUTF8: cOlympicInfo.bindMemory(to: CChar.self, capacity: 0))! as NSString
                    }
                    
                    events.eventID = Int(sqlite3_column_int(statement, 5))
                    
                    sqlite3_finalize(statement)
                    sqlite3_close(db)
                    
                    return events
                }
                sqlite3_finalize(statement)
                sqlite3_close(db)
            }
        }
        
        return nil
    }
    
    public func modify(model: Events) -> Int {
        
        if self.openDB() {
            
            let sql = "UPDATE Events set eventName=?, eventIcon=?, keyInfo=?, basicsInfo=?, olympicInfo=? where eventID=?"
            
            var statement: OpaquePointer? = nil
            
            if sqlite3_prepare_v2(db, sql.cString(using: String.Encoding.utf8), -1, &statement, nil) == SQLITE_OK {
                // bind parameter
                sqlite3_bind_text(statement, 1, model.eventName!.cString(using: String.Encoding.utf8.rawValue), -1, nil)
                sqlite3_bind_text(statement, 2, model.eventIcon!.cString(using: String.Encoding.utf8.rawValue), -1, nil)
                sqlite3_bind_text(statement, 3, model.keyInfo!.cString(using: String.Encoding.utf8.rawValue), -1, nil)
                sqlite3_bind_text(statement, 5, model.basicsInfo!.cString(using: String.Encoding.utf8.rawValue), -1, nil)
                sqlite3_bind_text(statement, 4, model.olympicsInfo!.cString(using: String.Encoding.utf8.rawValue), -1, nil)
                sqlite3_bind_int(statement, 6, Int32(model.eventID!))
                
                // execute insertion
                if sqlite3_step(statement) != SQLITE_DONE {
                    sqlite3_finalize(statement)
                    sqlite3_close(db)
                    assert(false, "modify data failed")
                }
            }
            sqlite3_finalize(statement)
            sqlite3_close(db)
        }
        return 0
    }
    
}
