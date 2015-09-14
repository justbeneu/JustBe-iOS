//
//  UserDefaultsManager.swift
//  Repressor Destressor
//
//  Created by Gavin King on 3/19/15.
//  Copyright (c) 2015 Group 2. All rights reserved.
//

import UIKit
import ObjectMapper

private let SESSION_COOKIES_KEY = "session_cookies_key"
private let LOGGED_IN_USER_KEY = "logged_in_user_key"
private let EXERCISE_SESSIONS_KEY = "exercise_sessions_key"
private let MEDITATION_SESSIONS_KEY = "meditation_sessions_key"

private let NOTIFICATION_TIME_KEY = "notification_time_key"

private let _SharedInstance = ServerRequest()

class UserDefaultsManager: NSObject
{
    class var sharedInstance : UserDefaultsManager
    {
        struct Static
        {
            static var onceToken: dispatch_once_t = 0
            static var instance: UserDefaultsManager? = nil
        }
        
        dispatch_once(&Static.onceToken)
        {
            Static.instance = UserDefaultsManager()
        }
        
        return Static.instance!
    }
    
    // MARK: Exercise Sessions
    
    func setExerciseSessions(exerciseSessions: [ExerciseSession])
    {
        let exerciseSessionsJSON = Mapper().toJSONArray(exerciseSessions)
        NSUserDefaults.standardUserDefaults().setObject(exerciseSessionsJSON, forKey: EXERCISE_SESSIONS_KEY)
    }
    
    func exerciseSessions() -> [ExerciseSession]
    {
        let exerciseSessionsJSON: [[String: AnyObject]]? =  NSUserDefaults.standardUserDefaults().objectForKey(EXERCISE_SESSIONS_KEY) as? [[String: AnyObject]]
        
        let sessions = Mapper<ExerciseSession>().mapArray(exerciseSessionsJSON)
        
        if (sessions != nil)
        {
            return sessions!
        }
        else
        {
            return []
        }
    }

    // MARK: Meditation Sessions
    
    func setMeditationSessions(meditationSessions: [MeditationSession])
    {
        let meditationSessionsJSON = Mapper().toJSONArray(meditationSessions)
        NSUserDefaults.standardUserDefaults().setObject(meditationSessionsJSON, forKey: MEDITATION_SESSIONS_KEY)
    }
    
    func meditationSessions() -> [MeditationSession]
    {
        let meditationSessionsJSON: [[String: AnyObject]]? =  NSUserDefaults.standardUserDefaults().objectForKey(MEDITATION_SESSIONS_KEY) as? [[String: AnyObject]]
        let sessions = Mapper<MeditationSession>().mapArray(meditationSessionsJSON)
        
        if (sessions != nil)
        {
            return sessions!
        }
        else
        {
            return []
        }
    }

    // MARK: User
    
    func setSessionCookies(cookies: [NSHTTPCookie])
    {        
        let data = NSKeyedArchiver.archivedDataWithRootObject(cookies)
        NSUserDefaults.standardUserDefaults().setObject(data, forKey: SESSION_COOKIES_KEY)
    }
    
    func sessionCookies() -> [NSHTTPCookie]?
    {
        if let data = NSUserDefaults.standardUserDefaults().objectForKey(SESSION_COOKIES_KEY) as? NSData
        {
            return NSKeyedUnarchiver.unarchiveObjectWithData(data) as? [NSHTTPCookie]
        }
        
        return nil
    }
    
    func setLoggedInUser(user: User)
    {
        let userJSON = Mapper().toJSON(user)
        NSUserDefaults.standardUserDefaults().setObject(userJSON, forKey: LOGGED_IN_USER_KEY)
    }
    
    func loggedInUser() -> User?
    {
        let userJSON: [String : AnyObject]? = NSUserDefaults.standardUserDefaults().objectForKey(LOGGED_IN_USER_KEY) as? [String : AnyObject]
        return Mapper<User>().map(userJSON)
    }
    
    // MARK: Pebble
    
    func addNotificationTime(time: NotificationTime)
    {
        var notificationTimes = self.notificationTimes()
        notificationTimes.append(time)
        
        NSUserDefaults.standardUserDefaults().setObject(notificationTimes, forKey: NOTIFICATION_TIME_KEY)
    }
    
    func notificationTimes() -> [NotificationTime]
    {
        let notificationTimes = NSUserDefaults.standardUserDefaults().objectForKey(NOTIFICATION_TIME_KEY) as? [NotificationTime]
        
        if let notificationTimes = notificationTimes
        {
            return notificationTimes
        }
        
        return []
    }
    
    // MARK: Utils
    
    func clear()
    {
        for key in NSUserDefaults.standardUserDefaults().dictionaryRepresentation().keys
        {
            NSUserDefaults.standardUserDefaults().removeObjectForKey(key.description)
        }
    }
}
