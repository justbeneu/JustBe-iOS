//
//  Just_BeTests.swift
//  Just BeTests
//
//  Created by Xiang Fan on 11/15/15.
//  Copyright © 2015 Group 2. All rights reserved.
//

import XCTest
import UIKit

//@testable import Just_Be

class Just_BeTests: XCTestCase {
    
    let x = " sss"
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    //test StringExtension, takes in a string and return itself with leading and trailing whitespace omitted
    func testStringExtension() {
        XCTAssertEqual("sss", x.trim())
    }
    //test users. Creats an user and print out the information
    func testUsers() {
        let user = User()
        user.id = 333
        print(user)
        
    }

    
    //test day transform, takes in anything and return a NSDate if satisfied
    func testDayTransformFromJSON() {
        let dateString = "2014-07-15" // change to your date format
        
        let daytransform = DayTransform()
        let transformDate = daytransform.transformFromJSON(dateString)
        print(transformDate)
        XCTAssertNotEqual(transformDate, "2014-07-15")
    }
    
    //takes in a NSDate and return a string
    func testDayTransformToJSON() {
        let dataString = "2015-04-01"
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd";
        // convert string into date
        let dateValue = dateFormatter.dateFromString(dataString)
        let dateValue2 = dateFormatter.dateFromString("")
        let daytransform = DayTransform()
        let transfromDate = daytransform.transformToJSON(dateValue)
        XCTAssertEqual(transfromDate, "2015-04-01")
        XCTAssertEqual(daytransform.transformToJSON(dateValue2), nil)
    }
    
    //test for DateTimeTransform, takes in any objects and return a NSDate if satisfied
    
    func testDateTimeTransformFromJSON() {
        let dateString = "2015-03-03T02:36:44"
        
        let daytimetransform = DateTimeTransform()
        let transformDate = daytimetransform.transformFromJSON(dateString)
        XCTAssertNil(transformDate)
        XCTAssertEqual(daytimetransform.transformFromJSON(000), nil)
        
    }
    
    //test for DateTimeTransform, takes in a NSDate and return a string
    
    func testDateTimeTransformToJSON() {
        let dataString = "2015-03-03"
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd";
        // convert string into date
        let dateValue = dateFormatter.dateFromString(dataString)
        let dateValue2 = dateFormatter.dateFromString("")
        let daytimetransform = DateTimeTransform()
        let transfromDate = daytimetransform.transformToJSON(dateValue)
        XCTAssertEqual(transfromDate, "2015-03-03T00:00:00.000000")
        XCTAssertEqual(daytimetransform.transformToJSON(dateValue2), nil)
    }
    
    //test TimeTransform
    
    func testTimeTransformFromJSON() {
        let dateString = "2015-03-03T02:36:44"
        
        let timetransform = TimeTransform()
        let transformDate = timetransform.transformFromJSON(dateString)
        XCTAssertNil(transformDate)
        XCTAssertEqual(timetransform.transformFromJSON(000), nil)
        
        
    }
    
    func testTimeTransformToJSON() {
        let dataString = "2015-03-03"
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd";
        // convert string into date
        let dateValue = dateFormatter.dateFromString(dataString)
        let dateValue2 = dateFormatter.dateFromString("")
        let timetransform = TimeTransform()
        let transfromDate = timetransform.transformToJSON(dateValue)
        XCTAssertEqual(transfromDate, "00:00:00")
        XCTAssertEqual(timetransform.transformToJSON(dateValue2), nil)
        
    }
    
   // test GenderTransform, takes in any object and return a Gender if satisfied
    func testGenderTransformFromJSON() {
        let gendertransform = GenderTransform()
        let genderdata = gendertransform.transformFromJSON(1)
        let rawdata = genderdata?.rawValue
        XCTAssertEqual(rawdata, 1)
        XCTAssertEqual(gendertransform.transformFromJSON(""), nil)
        

    }
    //takes in a Gender and return an Int.
    func testGenderTransformToJSON() {
        let gendertransform = GenderTransform()
        let genderdata = gendertransform.transformFromJSON(1)
        let genderjson = gendertransform.transformToJSON(genderdata)
        
        XCTAssertEqual(genderjson, 1)
        
    }
    
    //test DayOfWeekTransform, takes in anything and return a DayOfWeek if satisfied.
    func testDayOfWeekTransformFromJSON() {
        
        let dateString = "2015-03-03T02:36:44"
        
        let timetransform = DayOfWeekTransform()
        let transformDate = timetransform.transformFromJSON(dateString)
        XCTAssertNil(transformDate)
        XCTAssertNotEqual(timetransform.transformFromJSON(000), nil)
        
    }
    
    //takes in a DayOfWeek and return an Int
    func testDayOfWeekTransformToJSON() {
        
        let timetransform = DayOfWeekTransform()
        let test = DayOfWeek(rawValue: 0)
        XCTAssertEqual(timetransform.transformToJSON(test), 0)
        XCTAssertEqual(timetransform.transformToJSON(nil), nil)
        
    }
    
    //check if the showErrorAlert() method return the correct error message.
    func testShowErrorAlert() {
        
    }
    
    
    //test for isBefore(), it takes in a NSDate and return a Boolean
    func testIsBefore() {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd";

        let pastday = dateFormatter.dateFromString("2015-12-05")
        
        XCTAssertTrue(pastday!.isBefore(NSDate()))
        
        
    }
    
    //test for isSameDayAs(), it takes in a NSDate and returns a Boolean.
    func testIsSameDayAs() {
        let today = NSDate()
        XCTAssertTrue(today.isSameDayAs(NSDate()))
    
    }
    
    //test for getDeateAfterDays(), it takes in an Int and return a NSDate.
    func testGetDateAfterDays() {
        let today = NSDate()
        let tomorrow = NSCalendar.currentCalendar().dateByAddingUnit(
            .Day,
            value: 1,
            toDate: today,
            options: NSCalendarOptions(rawValue: 0))
        XCTAssertEqual(today.getDateAfterDays(1), tomorrow)
        
    }
    
    //test day transform, takes in anything and return a NSDate if satisfied
/*    func testfn() {
        let s = "Bhavin" // change to your date format
        let signUpView = SignupViewController()
        let u = signUpView.validateName(s);
        XCTAssertFalse(u)
    }
*/
    
   // var vc:SignUpViewController!
    
    
    
/*    func testFn(){
        
        let s = "#$%"
        let u = s.containsValidCharacters()
        

    }*/
    
    
    

}
