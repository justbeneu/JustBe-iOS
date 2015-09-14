//
//  NSDateExtension.swift
//  Just Be
//
//  Created by Gavin King on 4/21/15.
//  Copyright (c) 2015 Group 2. All rights reserved.
//

import UIKit

extension NSDate
{
    func isBefore(date: NSDate) -> Bool
    {
        return self.timeIntervalSinceReferenceDate < date.timeIntervalSinceReferenceDate
    }
    
    func isSameDayAs(date: NSDate) -> Bool
    {
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let comps1 = calendar.components(.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay, fromDate:self);
        let comps2 = calendar.components(.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay, fromDate:date);
        
        return comps1.day == comps2.day && comps1.month == comps2.month && comps1.year == comps2.year
    }
    
    func getDateAfterDays(numDays: Int) -> NSDate
    {
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        
        let components = NSDateComponents()
        components.day = numDays
        
        return calendar.dateByAddingComponents(components, toDate: self, options: NSCalendarOptions(0))!
    }
}