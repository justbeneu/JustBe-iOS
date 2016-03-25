//
//  User.swift
//  Repressor Destressor
//
//  Created by Gavin King on 2/15/15.
//  Copyright (c) 2015 Group 2. All rights reserved.
//

import UIKit
import ObjectMapper

public enum Gender: Int
{
    case Male = 0
    case Female = 1
}

public enum DayOfWeek: Int
{
    case Monday = 0
    case Tuesday = 1
    case Wednesday = 2
    case Thursday = 3
    case Friday = 4
    case Saturday = 5
    case Sunday = 6
    
    var description : String
    {
        switch self
        {
        case .Monday: return "Monday";
        case .Tuesday: return "Tuesday";
        case .Wednesday: return "Wednesday";
        case .Thursday: return "Thursday";
        case .Friday: return "Friday";
        case .Saturday: return "Saturday";
        case .Sunday: return "Sunday";
        }
    }
    
    var weekday: Int
    {
        switch self
        {
        case .Monday: return 2;
        case .Tuesday: return 3;
        case .Wednesday: return 4;
        case .Thursday: return 5;
        case .Friday: return 6;
        case .Saturday: return 7;
        case .Sunday: return 1;
        }
    }
    
    static func getDayOfWeekForWeekday(weekday: Int) -> DayOfWeek
    {
        switch weekday
        {
        case DayOfWeek.Monday.weekday: return .Monday;
        case DayOfWeek.Tuesday.weekday: return .Tuesday;
        case DayOfWeek.Wednesday.weekday: return .Wednesday;
        case DayOfWeek.Thursday.weekday: return .Thursday;
        case DayOfWeek.Friday.weekday: return .Friday;
        case DayOfWeek.Saturday.weekday: return .Saturday;
        default: return .Sunday
        }
    }
}

class User: Mappable
{
    var id: Int?
    var firstName: String?
    var lastName: String?
    var email: String?
    var apnsToken: String?
    var username: String?
    var birthday: NSDate?
    var gender: Gender?
    var meditationTime: NSDate?
    var exerciseDayOfWeek: DayOfWeek?
    var exerciseTime: NSDate?
    var createdAt: NSDate?
    var wakeUpTime: NSDate?
    var goToSleepTime: NSDate?
    
    init(){}
    
    required init?(_ map: Map)
    {
        mapping(map)
    }
    
    func mapping(mapper: Map)
    {
        id <- mapper["id"]
        firstName <- mapper["first_name"]
        lastName <- mapper["last_name"]
        email <- mapper["email"]
        apnsToken <- mapper["apns_token"]
        username <- mapper["username"]
        birthday <- (mapper["birthday"], DayTransform())
        gender <- (mapper["gender"], GenderTransform())
        meditationTime <- (mapper["meditation_time"], TimeTransform())
        exerciseDayOfWeek <- (mapper["exercise_day_of_week"], DayOfWeekTransform())
        exerciseTime <- (mapper["exercise_time"], TimeTransform())
        createdAt <- (mapper["created_at"], DateTimeTransform())
        wakeUpTime <- (mapper["wake_up_time"], TimeTransform())
        goToSleepTime <- (mapper["go_to_sleep_time"], TimeTransform())
    }
}
