//
//  ScheduleBL.swift
//  BusinessLogicLayer
//
//  Created by Darko on 2017/10/13.
//  Copyright © 2017年 Darko. All rights reserved.
//

import Foundation
import PersistenceLayer

public class ScheduleBL: NSObject {
    
    // search all data
    public func readData() -> NSMutableDictionary {
        
        let scheduleDAO = ScheduleDAO.sharedInstance
        let schedules = scheduleDAO.findAll()
        let resDict = NSMutableDictionary()
        
        let eventsDAO = EventsDAO.sharedInstance
        
        // lazy load Events data
        for item in schedules {
            
            let schedule = item as! Schedule
            let event = eventsDAO.findById(schedule.Event!)
            
            let allkey = resDict.allKeys as NSArray
            
            // turn NSMutableArray to NSMutableDictionary
            if allkey.contains(schedule.gameDate!) {
                let value = resDict[schedule.gameDate!] as! NSMutableArray
                value.add(schedule)
            } else {
                let value = NSMutableArray()
                value.add(schedule)
                resDict[schedule.gameDate!] = value
            }
        }
        
        return resDict
    }
    
    
}
