//
//  EventsDAOTests.swift
//  EventsDAOTests
//
//  Created by Darko on 2017/10/12.
//  Copyright © 2017年 Darko. All rights reserved.
//

import XCTest

class EventsDAOTests: XCTestCase {
    
    var dao: EventsDAO!
    var theEvents: Events!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // create EventsDAO object
        self.dao = EventsDAO.sharedInstance
        
        // create Events object
        self.theEvents = Events()
        self.theEvents.eventName = "test EventName"
        self.theEvents.eventIcon = "test EventIcon"
        self.theEvents.keyInfo = "test KeyInfo"
        self.theEvents.basicsInfo = "test BasicsInfo"
        self.theEvents.olympicsInfo = "test OlympicsInfo"
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        self.dao = nil
        super.tearDown()
    }
    
    func test_1_Create() {
        let res = self.dao.create(model: self.theEvents)
        
        // no exception of the assertion, return 0
        XCTAssert(res == 0)
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
