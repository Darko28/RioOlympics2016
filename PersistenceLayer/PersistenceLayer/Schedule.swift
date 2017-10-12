//
//  Schedule.swift
//  PersistenceLayer
//
//  Created by Darko on 2017/10/12.
//  Copyright © 2017年 Darko. All rights reserved.
//

import Foundation

public class Schedule: NSObject {
    
    public var ScheduleID: Int?
    public var GameDate: NSString?
    public var GameTime: NSString?
    public var GameInfo: NSString?
    
    public var Event: Events?
    
}
