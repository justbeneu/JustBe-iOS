//
//  ExerciseManager.swift
//  Repressor Destressor
//
//  Created by Gavin King on 3/20/15.
//  Copyright (c) 2015 Group 2. All rights reserved.
//

import UIKit
import ObjectMapper

private let MEDITATION_ID_KEY = "meditation_id"
private let MEDITATION_AUDIO_FILENAME_KEY = "audio_filename"

typealias RefreshActivityBlock = (success: Bool) -> ()

class ExerciseManager: NSObject
{
    class var sharedInstance : ExerciseManager
    {
        struct Static
        {
            static var onceToken: dispatch_once_t = 0
            static var instance: ExerciseManager? = nil
        }
        
        dispatch_once(&Static.onceToken)
        {
            Static.instance = ExerciseManager()
        }
        
        return Static.instance!
    }
    
    func refreshActivity(completion: RefreshActivityBlock)
    {
        ServerRequest.sharedInstance.exerciseSessions(nil, success: { (exerciseSessions) -> Void in
            
            ServerRequest.sharedInstance.meditationSessions(nil, success: { (meditationSessions) -> Void in
                
                UserDefaultsManager.sharedInstance.setMeditationSessions(meditationSessions)
                UserDefaultsManager.sharedInstance.setExerciseSessions(exerciseSessions)
                
                completion(success: true)
                
            }) { (error) -> () in
                completion(success: false)
            }
            
        }) { (error) -> () in
            completion(success: false)
        }
    }
    
    // MARK: Exercises

    func currentExercise() -> Exercise?
    {
        let daysSinceStart = self.daysSinceStart()
        let exerciseIndex = Int(Float(daysSinceStart) / Float(EXERCISE_LENGTH_IN_DAYS))
        
        if (daysSinceStart < 0 || exerciseIndex >= self.exercises().count)
        {
            return nil // Plan has not yet started or has ended
        }
        else
        {
            return self.exercises()[exerciseIndex]
        }
    }

    func exercises() -> [Exercise]
    {
        let path = NSBundle.mainBundle().pathForResource("Exercises", ofType: "plist")
        let dictionary = NSDictionary(contentsOfFile: path!)!
        
        var exercises = Mapper<Exercise>().mapArray(dictionary.objectForKey("Exercises") as! [[String : AnyObject]])
        
        exercises.sort({ $0.id < $1.id })
        
        return exercises
    }
    
    func exerciseSessions() -> [ExerciseSession]
    {
        return UserDefaultsManager.sharedInstance.exerciseSessions()
    }
    
    // MARK: Meditations
    
    func meditations() -> [Meditation]
    {
        let path = NSBundle.mainBundle().pathForResource("Meditations", ofType: "plist")
        let dictionary = NSDictionary(contentsOfFile: path!)!
        
        var meditations = Mapper<Meditation>().mapArray(dictionary.objectForKey("Meditations") as! [[String : AnyObject]])
        
        meditations.sort({ $0.id < $1.id })
        
        return meditations
    }
    
    func meditationSessions() -> [MeditationSession]
    {
        return UserDefaultsManager.sharedInstance.meditationSessions()
    }
    
    func meditationWithId(meditationId: Int) -> Meditation?
    {
        for meditation in self.meditations()
        {
            if (meditation.id == meditationId)
            {
                return meditation
            }
        }
        
        return nil
    }
    
    func saveMeditationSession(meditationId: Int, percentCompleted: Float)
    {
        ServerRequest.sharedInstance.meditate(meditationId, percentCompleted: percentCompleted, always: nil, success: { () -> Void in }, failure: nil)
    }
    
    // MARK: Utils
    
    func daysSinceStart() -> Int
    {
        return NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitDay, fromDate: startDate(), toDate: NSDate(), options: nil).day
    }
    
    func startDate() -> NSDate
    {
        let user = UserDefaultsManager.sharedInstance.loggedInUser()!
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        
        let exerciseWeekday = user.exerciseDayOfWeek!.weekday
        let exerciseHour = calendar.components(.CalendarUnitHour, fromDate: user.exerciseTime!).hour
        
        let components:NSDateComponents = calendar.components(.CalendarUnitYear | .CalendarUnitWeekOfYear | .CalendarUnitWeekday | .CalendarUnitHour | .CalendarUnitMinute | .CalendarUnitSecond, fromDate: user.createdAt!)
        
        if (components.weekday > exerciseWeekday)
        {
            components.weekOfYear++
        }
        
        components.weekday = exerciseWeekday
        components.hour = exerciseHour
        components.minute = 0
        components.second = 0

        let startDate = calendar.dateFromComponents(components)
        
        return startDate!
    }
    
    func startDateForExercise(exercise: Exercise) -> NSDate
    {
        return self.startDate().getDateAfterDays(find(self.exercises(), exercise)! * EXERCISE_LENGTH_IN_DAYS)
    }
}