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
        print("trying to refresh from exercise Manager script")
        ServerRequest.sharedInstance.exerciseSessions(nil, success: { (exerciseSessions) -> Void in
            print("sharedInstance 1")
            ServerRequest.sharedInstance.meditationSessions(nil, success: { (meditationSessions) -> Void in
                print("sharedInstance 2")
                UserDefaultsManager.sharedInstance.setMeditationSessions(meditationSessions)
                UserDefaultsManager.sharedInstance.setExerciseSessions(exerciseSessions)
                print("sharedInstance 3")
                // WE need a way to stop loader
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
        print("we're in current exercise inside ExerciseManager")
        let daysSinceStart = self.daysSinceStart()
        let exerciseIndex = Int(Float(daysSinceStart) / Float(EXERCISE_LENGTH_IN_DAYS))
        return self.exercises()[2]
        if (daysSinceStart < 0 || exerciseIndex >= self.exercises().count)
        {
            print("Plan has not yet started or has ended")
            return nil // Plan has not yet started or has ended
        }
        else
        {
            print("exerciseINDEX")
            return self.exercises()[exerciseIndex]
        }
    }

    func exercises() -> [Exercise]
    {
        let path = NSBundle.mainBundle().pathForResource("Exercises", ofType: "plist")
        let dictionary = NSDictionary(contentsOfFile: path!)!
        
        var exercises = Mapper<Exercise>().mapArray(dictionary.objectForKey("Exercises") as! [[String : AnyObject]])
        
        //exercises.sortInPlace({ $0.id < $1.id })
        exercises!.sortInPlace({$0.id < $1.id })
        
        return exercises!
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
        print("MeditationDICT", meditations)
        //meditations.sortInPlace({ $0.id < $1.id })
        meditations!.sortInPlace({ $0.id < $1.id })
        
        return meditations!
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
        return NSCalendar.currentCalendar().components(NSCalendarUnit.Day, fromDate: startDate(), toDate: NSDate(), options: []).day
    }
    
    func startDate() -> NSDate
    {
        let user = UserDefaultsManager.sharedInstance.loggedInUser()!
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        
        let exerciseWeekday = user.exerciseDayOfWeek!.weekday
        let exerciseHour = calendar.components(.Hour, fromDate: user.exerciseTime!).hour
        
        let components:NSDateComponents = calendar.components([.Year, .WeekOfYear, .Weekday, .Hour, .Minute, .Second], fromDate: user.createdAt!)
        
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
        return self.startDate().getDateAfterDays(self.exercises().indexOf(exercise)! * EXERCISE_LENGTH_IN_DAYS)
    }
}
