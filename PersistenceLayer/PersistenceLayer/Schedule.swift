//
//  Schedule.swift
//  PersistenceLayer
//
//  Created by Darko on 2017/10/12.
//  Copyright © 2017年 Darko. All rights reserved.
//

import Foundation

public class Schedule: NSObject {
    
    public var scheduleId: Int?
    public var gameDate: NSString?
    public var gameTime: NSString?
    public var gameInfo: NSString?
    public var event: Events?
    
}
