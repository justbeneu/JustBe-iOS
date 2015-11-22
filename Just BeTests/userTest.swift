//
//  userTest.swift
//  Just Be
//
//  Created by Thomas Hay on 11/22/15.
//  Copyright © 2015 Group 2. All rights reserved.
//

import XCTest

class userTest: XCTestCase {
    
    let user = User()
    let transform = DayTransform()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        user.firstName = "Robert"
        user.lastName = "Brimley"
        user.email = "R.Brimley@gmail.com"
        user.username = "Brimmesiter"
        user.birthday = transform.transformFromJSON("1942-10-10")
        user.gender = Gender(rawValue: 0)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func userBirthdayTest() {
        XCTAssertEqual(user.birthday, "1942-10-10", "What was it? \(user.birthday)")
    }
    
}
