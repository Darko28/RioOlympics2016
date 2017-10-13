//
//  EventsBLTests.swift
//  EventsBLTests
//
//  Created by Darko on 2017/10/13.
//  Copyright © 2017年 Darko. All rights reserved.
//

import Foundation
import XCTest
import PersistenceLayer

class EventsBLTests: XCTestCase {
    
    var bl: EventsBL!
    var theEvents: Events!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // create EventsBL object
        self.bl = EventsBL()
        // create Events object
        self.theEvents = Events()
        self.theEvents.eventName = "test eventName"
        self.theEvents.eventIcon = "test eventIcon"
        self.theEvents.keyInfo = "test keyInfo"
        self.theEvents.basicsInfo = "test basicsInfo"
        self.theEvents.olympicsInfo = "test olympicsInfo"
        
        // insert test data
        let dao = EventsDAO.sharedInstance
        dao.create(model: self.theEvents)
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        // delete test data
        self.theEvents.eventID = "41"
        let dao = EventsDAO.sharedInstance
        dao.remove(model: self.theEvents)
        self.bl = nil
        
        super.tearDown()
    }
    
    func testFindAll() {
    
        let list = self.bl.readData()
        
        XCTAssertEqual(list.count, 41)
        let resEvents = list[40] as! Events
        
        // Assertion
        XCTAssertEqual(self.theEvents.eventName!, resEvents.eventName!)
        XCTAssertEqual(self.theEvents.eventIcon!, resEvents.eventIcon!)
        XCTAssertEqual(self.theEvents.keyInfo!, resEvents.keyInfo!)
        XCTAssertEqual(self.theEvents.basicsInfo!, resEvents.basicsInfo!)
        XCTAssertEqual(self.theEvents.olympicsInfo!, resEvents.olympicsInfo!)
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
