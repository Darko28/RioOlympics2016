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
    
    
}
