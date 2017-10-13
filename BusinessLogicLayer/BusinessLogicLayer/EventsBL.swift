//
//  EventsBL.swift
//  BusinessLogicLayer
//
//  Created by Darko on 2017/10/13.
//  Copyright © 2017年 Darko. All rights reserved.
//

import Foundation
import PersistenceLayer

public class EventsBL: NSObject {
    
    // search all data
    public func readData() -> NSMutableArray {
        let dao = EventsDAO.sharedInstance
        let list = dao.findAll()
        return list
    }
    
    
    
    
}
