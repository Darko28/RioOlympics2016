//
//  ScheduleDAO.swift
//  PersistenceLayer
//
//  Created by Darko on 2017/10/13.
//  Copyright © 2017年 Darko. All rights reserved.
//

import Foundation
import SQLite3

public class ScheduleDAO: BaseDAO {
    
    public static let sharedInstance: ScheduleDAO = {
        let instance = ScheduleDAO()
        return instance
    }()
    
    public func create(model: Schedule) -> Int {
        
        if self.openDB() {
            
            let sql = "INSERT INTO Schedule (gameDate, gameTime, gameInfo, eventID) VALUES (?,?,?,?)"
            
            var statement: OpaquePointer? = nil
            
            // preprocess
            if sqlite3_prepare_v2(db, sql.cString(using: String.Encoding.utf8)!, -1, &statement, nil) == SQLITE_OK {
                
                // start to bind parameter
                sqlite3_bind_text(statement, 1, model.gameDate!.cString(using: String.Encoding.utf8.rawValue), -1, nil)
                sqlite3_bind_text(statement, 2, model.gameTime!.cString(using: String.Encoding.utf8.rawValue), -1, nil)
                sqlite3_bind_text(statement, 3, model.gameInfo!.cString(using: String.Encoding.utf8.rawValue), -1, nil)
                sqlite3_bind_int(statement, 4, Int32(model.event!.eventID!))
                
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
    
    public func remove(model: Schedule) -> Int {
        
        if self.openDB() {
            
            let sql = "DELETE from Schedule where scheduleID=?"
            
            var statement: OpaquePointer? = nil
            
            if sqlite3_prepare_v2(db, sql.cString(using: String.Encoding.utf8), -1, &statement, nil) == SQLITE_OK {
                sqlite3_bind_int(statement, 1, Int32(model.scheduleId!))
                
                if (sqlite3_step(statement) != SQLITE_DONE) {
                    sqlite3_finalize(statement)
                    sqlite3_close(db)
                    assert(false, "remove data failed")
                }
            }
            sqlite3_finalize(statement)
            sqlite3_close(db)
        }
        
        return 0
    }
    
    public func findAll() -> NSMutableArray {
        
        let listData = NSMutableArray()
        
        if self.openDB() {
            
            let qsql = "SELECT gameDate, gameTime, gameInfo, eventID, scheduleID FROM Schedule"
            
            var statement: OpaquePointer? = nil
            
            // preprocess
            if sqlite3_prepare_v2(db, qsql.cString(using: String.Encoding.utf8)!, -1, &statement, nil) == SQLITE_OK {
                
                // execute
                while sqlite3_step(statement) == SQLITE_ROW {
                    
                    let schedule = Schedule()
                    let event = Events()
                    schedule.event = event
                    
                    //                    let cEventName = UnsafePointer<Int8>(sqlite3_column_text(statement, 0))
                    //                    events.eventName = String.cString(cEventName)
                    
//                    var cEventIcon = UnsafePointer(sqlite3_column_text(statement, 1))?.withMemoryRebound(to: Int8.self, capacity: 0) { $0.pointee }
//                    schedule.eventIcon = NSString.init(cString: &cEventIcon!, encoding: String.Encoding.utf8.rawValue)
                    
                    if let cGameDate = UnsafeRawPointer.init(sqlite3_column_text(statement, 0)) {
                        let uGameDate = cGameDate.bindMemory(to: CChar.self, capacity: 0)
                        schedule.gameDate = NSString.init(cString: uGameDate, encoding: String.Encoding.utf8.rawValue)
                    }
                    
                    let cGameTime = UnsafeRawPointer(sqlite3_column_text(statement, 1))
                    schedule.gameTime = NSString.init(cString: (cGameTime!.bindMemory(to: CChar.self, capacity: 0)), encoding: String.Encoding.utf8.rawValue)
                    
                    if let cGameInfo = UnsafeRawPointer(sqlite3_column_text(statement, 2)) {
                        schedule.gameInfo = String(validatingUTF8: cGameInfo.bindMemory(to: CChar.self, capacity: 0))! as NSString
                    }
                    
                    schedule.event!.eventID = Int(sqlite3_column_int(statement, 3))
                    schedule.scheduleId = Int(sqlite3_column_int(statement, 4))
                    
                    listData.add(schedule)
                }
            }
            sqlite3_finalize(statement)
            sqlite3_close(db)
        }
        return listData
    }
    
    
    public func findById(model: Schedule) -> Schedule? {
        
        if self.openDB() {
            
            let qsql = "SELECT gameDate, gameTime,gameInfo,eventID,scheduleID FROM Schedule where scheduleID=?"
            
            var statement: OpaquePointer? = nil
            
            // preprocess
            if sqlite3_prepare_v2(db, qsql.cString(using: String.Encoding.utf8), -1, &statement, nil) == SQLITE_OK {
                
                // start to bind parameter
                sqlite3_bind_int(statement, 1, Int32(model.scheduleId!))
                
                // execute
                if sqlite3_step(statement) == SQLITE_ROW {
                    
                    let schedule = Schedule()
                    let event  = Events()
                    schedule.event = event
                    
                    if let cGameDate = UnsafeRawPointer.init(sqlite3_column_text(statement, 0)) {
                        let uGameDate = cGameDate.bindMemory(to: CChar.self, capacity: 0)
                        schedule.gameDate = NSString.init(cString: uGameDate, encoding: String.Encoding.utf8.rawValue)
                    }
                    
                    let cGameTime = UnsafeRawPointer(sqlite3_column_text(statement, 1))
                    schedule.gameTime = NSString.init(cString: (cGameTime!.bindMemory(to: CChar.self, capacity: 0)), encoding: String.Encoding.utf8.rawValue)
                    
                    if let cGameInfo = UnsafeRawPointer(sqlite3_column_text(statement, 2)) {
                        schedule.gameInfo = String(validatingUTF8: cGameInfo.bindMemory(to: CChar.self, capacity: 0))! as NSString
                    }

                    schedule.event!.eventID = Int(sqlite3_column_int(statement, 3))
                    schedule.scheduleId = Int(sqlite3_column_int(statement, 4))
                    
                    sqlite3_finalize(statement)
                    sqlite3_close(db)
                    
                    return schedule
                }
            }
            sqlite3_finalize(statement)
            sqlite3_close(db)
        }
        
        return nil
    }
    
    public func modify(model: Schedule) -> Int {
        
        if self.openDB() {
            
            let sql = "UPDATE Schedule set gameInfo=?,eventID=?,gameDate =?,gameTime=? where scheduleID=?"
            
            var statement: OpaquePointer? = nil
            //预处理过程
            if sqlite3_prepare_v2(db, sql.cString(using: String.Encoding.utf8), -1, &statement, nil) == SQLITE_OK {
                
                //绑定参数开始
                sqlite3_bind_text(statement, 1, model.gameInfo!.cString(using: String.Encoding.utf8.rawValue), -1, nil)
                sqlite3_bind_int(statement, 2, Int32(model.event!.eventID!))
                sqlite3_bind_text(statement, 3, model.gameDate!.cString(using: String.Encoding.utf8.rawValue), -1, nil)
                sqlite3_bind_text(statement, 4, model.gameTime!.cString(using: String.Encoding.utf8.rawValue), -1, nil)
                sqlite3_bind_int(statement, 5, Int32(model.scheduleId!))
                
                //执行插入
                if (sqlite3_step(statement) != SQLITE_DONE) {
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
