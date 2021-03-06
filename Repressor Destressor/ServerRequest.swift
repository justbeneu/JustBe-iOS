//
//  ServerRequest.swift
//  Repressor Destressor
//
//  Created by Gavin King on 2/15/15.
//  Copyright (c) 2015 Group 2. All rights reserved.
//
//  Modified by Bhavin Haresh Vora on 3/24/16.
//  Copyright © 2016 Group 2. All rights reserved.

import Foundation
import Alamofire
import ObjectMapper
import SwiftyJSON
import UIKit

typealias SuccessBlock = (response: [String: AnyObject]?) -> ()
typealias FailureBlock = (error: NSError, message: String?)-> ()
typealias AlwaysBlock = () -> ()

private let URL = "https://secure-headland-8362.herokuapp.com/api/v1/"

private let _SharedInstance = ServerRequest()

class ServerRequest
{
    class var sharedInstance : ServerRequest
    {
        struct Static
        {
            static var onceToken: dispatch_once_t = 0
            static var instance: ServerRequest? = nil
        }
        
        dispatch_once(&Static.onceToken)
        {
            Static.instance = ServerRequest()
            
            if let cookies = UserDefaultsManager.sharedInstance.sessionCookies()
            {
                for cookie in cookies
                {
                    NSHTTPCookieStorage.sharedHTTPCookieStorage().setCookie(cookie)
                }
            }
        }
        
        return Static.instance!
    }
    
    // MARK: Utils
    
    func setSession()
    {
        let cookies:[NSHTTPCookie] = NSHTTPCookieStorage.sharedHTTPCookieStorage().cookies! as [NSHTTPCookie]
        UserDefaultsManager.sharedInstance.setSessionCookies(cookies)
    }
    
    func JSONStringify(value: AnyObject, prettyPrinted: Bool = false) -> String
    {
        let options : NSJSONWritingOptions? = prettyPrinted ? NSJSONWritingOptions.PrettyPrinted : nil
        
        if NSJSONSerialization.isValidJSONObject(value)
        {
            if let data = try? NSJSONSerialization.dataWithJSONObject(value, options: options!)
            {
                if let string = NSString(data: data, encoding: NSUTF8StringEncoding)
                {
                    return string as String
                }
            }
        }
        return ""
    }

    // MARK: Requests
    
    private func get(uri: String, always: AlwaysBlock?, success: SuccessBlock?, failure: FailureBlock?)
    {
        let emptyDic = [String: String]() // Passing empty parameter dictionary
        //        self.request(.GET, url: URL + uri, params: emptyDic, always : always, success : success, failure : failure)
        
        let url = URL + uri
        print("THIS IS A GET REQUEST TO " + url + " with params " + emptyDic.description);
        
        let request = Alamofire
            .request(.GET, url)
            .validate()
            .responseJSON {
                response in
                let data = JSON(response.data!)
                let subresponse = response.response
                let result = response.result
                let request = response.request
                
                if let JSON = result.value {
                    print("JSON: \(JSON)")
                }
                
                switch (result) {
                    case .Success(let data):
                        let objs = data as! [String : AnyObject]
                        print("RECEIVED:\n" + result.description)
                        
                        if ((objs["meta"]) != nil) {
                            let total = objs["meta"]!["total_count"] as! Int
                        
                            if (total == 0 && uri == "exercise_session/") {
                                print("** GOT 0 RESULTS **")
                            
                            // We want to give back the first exercise_session or meditation_session
                            } else {
                                    success!(response: objs)
                            }
                         
                            if (always != nil) {always!()}
                        }
                        else { success!(response: objs) }
                    

                    case .Failure(let error):
                        failure!(error: error, message: error.description)
                        print("FAILED:\n" + error.description)
                        // TODO: on failure STOP GOING
                }
        }
        
        debugPrint(request)
    }
    
    func exercisePush(exerciseId: NSNumber, always: AlwaysBlock?, success: () -> Void, failure: FailureBlock?)
    {
        let params : [String : AnyObject] = ["exercise_id": exerciseId]
        ServerRequest.sharedInstance.post("exercise_session/", params: params, always: always, success: {
            (response) -> () in
            print("we're pushing a starter exercise session")
            //let exerciseSessions = Mapper<ExerciseSession>().mapArray(response!["objects"])
            
            success()
            
            //            }, failure: {
            //                if (count <= realFail) {
            //                    self.exerciseSessions(always, success : success, failure : failure)
            //                    count = count + 1
            //                }
            //                failure()
            //            })
            }, failure: failure)

        // TODO: Post {exercise_session:0}
        
        //        self.Push("exercise_session/", always: always, success: {
        //            (response) -> () in
        //            print("we're in the call to get exercise session data")
        //            let exerciseSessions = Mapper<ExerciseSession>().mapArray(response!["objects"])
        //            print("this is what we got: " + exerciseSessions!.description)
        //
        //            success(exerciseSessions!)
        //
        //            //            }, failure: {
        //            //                if (count <= realFail) {
        //            //                    self.exerciseSessions(always, success : success, failure : failure)
        //            //                    count = count + 1
        //            //                }
        //            //                failure()
        //            //            })
        //            }, failure: failure)
        
    }
    
    private func post(uri: String, params: [String: AnyObject], always: AlwaysBlock?, success: SuccessBlock?, failure: FailureBlock?)
    {
        print("Posting")
        self.request(.POST, url: URL + uri, params: params, always : always, success : success, failure : failure)
    }

    private func put(uri: String, params: [String: AnyObject], always: AlwaysBlock?, success: SuccessBlock?, failure: FailureBlock?)
    {
        self.request(.PUT, url: URL + uri, params: params, always : always, success : success, failure : failure)
    }
    
    private func patch(uri: String, params: [String: AnyObject], always: AlwaysBlock?, success: SuccessBlock?, failure: FailureBlock?)
    {
        self.request(.PATCH, url: URL + uri, params: params, always : always, success : success, failure : failure)
    }

    private func request(method: Alamofire.Method, url: String, params: [String: AnyObject], always: AlwaysBlock?, success: SuccessBlock?, failure: FailureBlock?)
    {
        print("requesting " + " -- " + url + " params " + params.description);
        
//        if (method == .GET) {
//            print("THIS IS A GET REQUEST TO " + url)// + " with params " + params.description);
//            
//            let request = Alamofire
//                .request(method, url)
//                .validate()
//                .responseJSON {
//                    response in
//                    let data = JSON(response.data!)
//                    let subresponse = response.response
//                    let result = response.result
//                    let request = response.request
//                    
//                    if let JSON = result.value {
//                        print("JSON: \(JSON)")
//                    }
//                    
//                    switch (result) {
//                    case .Success(let data):
//                        success!(response: data as! [String : AnyObject])
//                        print("RECEIVED:\n" + result.description)
//                    case .Failure(let error):
//                        //let errorDictionary:[String: AnyObject]? = data["error"] as? [String: AnyObject]
//                        //let errorMessage:String? = error.valueForKey("message") as! String
//                        failure!(error: error, message: error.description)
//                        print("FAILED:\n" + error.description)
//                        // TODO: on failure STOP GOING
//                    }
//                    
//                    //                //(request, response, data, error) in
//                    //
//                    //                let responseDictionary:[String: AnyObject]? = (data as? [String: AnyObject])
//                    //
//                    //                if (always != nil)
//                    //                {
//                    //                    always!()
//                    //                }
//                    //                if (failure != nil)
//                    //                {
//                    //                    let error = result.result.error!
//                    //                    let errorDictionary = data["error"]
//                    //                    let errorMessage = errorDictionary["message"].stringValue
//                    //
//                    //                    failure!(error: error, message: errorMessage)
//                    //                }
//                    
//            }
//            
//            debugPrint(request)
//        } else {
        
            
            let request = Alamofire
                .request(method, url, parameters: params, encoding: .JSON)
                .validate()
                .responseJSON {
                    response in
                    let data = JSON(response.data!)
                    let subresponse = response.response
                    let result = response.result
                    let request = response.request
                    
                    if let JSON = result.value {
                        print("JSON: \(JSON)")
                    }
                    
                    switch (result) {
                        case .Success(let data):
                            success!(response: data as! [String : AnyObject])
                            print("RECEIVED:\n" + result.description)
                        case .Failure(let error):
                            /*let errorDictionary:[String: AnyObject]? = data["error"] as? [String: AnyObject]
                            let errorMessage:String? = error.valueForKey("message") as! String
*/
//                            print(error.description + "qqqqqqqqqqqqqqqqqqq")
                            
                            if(error.description.lowercaseString.rangeOfString("JSON could not be serialized. Input data was nil or zero length.") != nil) {
                                failure!(error: error, message: (error as NSError).localizedDescription)
                                print("FAILED:\n" + error.description)
                            }
                            else {
                                failure!(error: error, message: (error as NSError).localizedDescription)
                                print("FAILEEEEEEEED:\n" + error.description + "FAILEEEEEEEED:\n")
                                return
                        }
                        // TODO: on failure STOP GOING
                    }
                    
                    //                //(request, response, data, error) in
                    //            
                    //                let responseDictionary:[String: AnyObject]? = (data as? [String: AnyObject])
                    //
                    //                if (always != nil)
                    //                {
                    //                    always!()
                    //                }
                    //                if (failure != nil)
                    //                {
                    //                    let error = result.result.error!
                    //                    let errorDictionary = data["error"]
                    //                    let errorMessage = errorDictionary["message"].stringValue
                    //
                    //                    failure!(error: error, message: errorMessage)
                    //                }
            }
        
        
            debugPrint(request)
        

        print("this is the last thing in Get")
        return
//        }
    }
    
    // MARK: User API
    
    func logIn(username: String, password: String, always: AlwaysBlock?, success: (User) -> Void, failure: FailureBlock?)
    {
        let params = ["username": username, "password": password];
        
        ServerRequest.sharedInstance.post("user/login/", params: params, always: always, success: {
            (response) -> () in
            
            let user = Mapper<User>().map(response)
            
            UserDefaultsManager.sharedInstance.setLoggedInUser(user!)
            self.setSession()

            success(user!)
            
        }, failure: failure)
    }
    
    func signUp(user: User, password:String, always: AlwaysBlock?, success: (User) -> Void, failure: FailureBlock?)
    {
        var userJSON = Mapper().toJSON(user)
        userJSON["raw_password"] = password
        let params = userJSON
        
        ServerRequest.sharedInstance.post("create_user/", params: params, always: always, success: {
            (response) -> () in
            
            let user = Mapper<User>().map(response)
            
            UserDefaultsManager.sharedInstance.setLoggedInUser(user!)
            self.setSession()
            
            success(user!)
            
        }, failure: failure)
    }

    
    
    
    func setNotificationSettings(token: String, exerciseDay: DayOfWeek, exerciseTime:NSDate, meditationTime:NSDate,wakeUpTime:NSDate,goToSleepTime:NSDate, always: AlwaysBlock?, success: () -> Void, failure: FailureBlock?)
    {
        var params:[String: AnyObject] = [:]
        params["apns_token"] = token
        params["exercise_day_of_week"] = exerciseDay.rawValue
        params["exercise_time"] = TimeTransform().transformToJSON(exerciseTime)
        params["meditation_time"] = TimeTransform().transformToJSON(meditationTime)
        params["wake_up_time"] = TimeTransform().transformToJSON(wakeUpTime)
        params["go_to_sleep_time"] = TimeTransform().transformToJSON(goToSleepTime)
        print("Notifications set to:", params.description)
        ServerRequest.sharedInstance.patch("user_profile/", params: params, always: always, success: {
            (response) -> () in
            
            let user = UserDefaultsManager.sharedInstance.loggedInUser()!
            
            user.exerciseDayOfWeek = exerciseDay
            user.exerciseTime = exerciseTime
            user.meditationTime = meditationTime
            user.wakeUpTime = wakeUpTime
            user.goToSleepTime = goToSleepTime
            
            UserDefaultsManager.sharedInstance.setLoggedInUser(user)
            
            success()
            
            }, failure: failure)
    }

    
    func logOut(always: AlwaysBlock?, success: () -> Void, failure: () -> ())
    {
        print("log out outer layer")
        ServerRequest.sharedInstance.get("user/logout/", always: always, success: {
            (response) -> () in
            print("successful log out")
            UserDefaultsManager.sharedInstance.clear()
            success()
            
            }, failure: {
                (error) -> () in
                print("we failed in logging out!!", error)
            failure()
            })
    }
    
    // MARK: Exercise API
    
    func completeExercise(exerciseId: NSNumber, always: AlwaysBlock?, success: () -> Void, failure: FailureBlock?)
    {
       // var params:[String: AnyObject] = [:]
        let params : [String : AnyObject] = ["exercise_id": exerciseId]
        //let params = ["exercise_id": exerciseId];
        //params["exercise_id"] = exerciseId;
        ServerRequest.sharedInstance.post("exercise_session/", params: params, always: always, success: {
            (response) -> () in

            success()
            
        }, failure: failure)
    }
    
    func exerciseSessions(always: AlwaysBlock?, success: ([ExerciseSession]) -> Void, failure: FailureBlock?)
    {
//        let realFail = 10
//        let count= 0
        print("inside exerciseSessions in side ExerciseManager")
        ServerRequest.sharedInstance.get("exercise_session/", always: always, success: {
            (response) -> () in
            print("we're in the call to get exercise session data")
            let exerciseSessions = Mapper<ExerciseSession>().mapArray(response!["objects"])
            print("this is what we got: " + exerciseSessions!.description)
            
            success(exerciseSessions!)
            
//            }, failure: {
//                if (count <= realFail) {
//                    self.exerciseSessions(always, success : success, failure : failure)
//                    count = count + 1
//                }
//                failure()
//            })
            }, failure: failure)

    }
    
    func exercisePush(always: AlwaysBlock?, success: ([ExerciseSession]) -> Void, failure: FailureBlock?)
    {
        // TODO: Post {exercise_session:0}
        
//        self.Push("exercise_session/", always: always, success: {
//            (response) -> () in
//            print("we're in the call to get exercise session data")
//            let exerciseSessions = Mapper<ExerciseSession>().mapArray(response!["objects"])
//            print("this is what we got: " + exerciseSessions!.description)
//            
//            success(exerciseSessions!)
//            
//            //            }, failure: {
//            //                if (count <= realFail) {
//            //                    self.exerciseSessions(always, success : success, failure : failure)
//            //                    count = count + 1
//            //                }
//            //                failure()
//            //            })
//            }, failure: failure)
        
    }

    
    // MARK: Meditation API
    
    func meditate(meditationId: NSNumber, percentCompleted: NSNumber, always: AlwaysBlock?, success: () -> Void, failure: FailureBlock?)
    {
        var params:[String: AnyObject] = [:]
        params["meditation_id"] = meditationId
        params["percent_completed"] = percentCompleted
        
        ServerRequest.sharedInstance.post("meditation_session/", params: params, always: always, success: {
            (response) -> () in
            
            success()
            
        }, failure: failure)
    }
    
    func meditationSessions(always: AlwaysBlock?, success: ([MeditationSession]) -> Void, failure: FailureBlock?)
    {
        ServerRequest.sharedInstance.get("meditation_session/", always: always, success: {
            (response) -> () in
            
            let meditationSessions = Mapper<MeditationSession>().mapArray(response!["objects"])
            print("Meditation Session response: " + (response?.description)! + " objs " + (meditationSessions?.description)!)
            
            success(meditationSessions!)
            
        }, failure: failure)
    }
    
    // MARK: Assessments API
    
    func pendingAssessment(always: AlwaysBlock?, success: (assessment: Assessment) -> Void, failure: FailureBlock?)
    {
        print("inside pending assessment api")
        ServerRequest.sharedInstance.get("assessment/get_pending_assessment/", always: always, success: {
            (response) -> () in
            print("inside success of assessment")
            if (response != nil && response!.count > 0)
            {
                print("actually mapping the assessment")
                let assessment = Mapper<Assessment>().map(response)
                
                success(assessment: assessment!)
            }
            
        }, failure: failure)
    }
    
    func completeAssessment(responses: [Response], always: AlwaysBlock?, success: () -> Void, failure: FailureBlock?)
    {
        let params:[String: [[String: AnyObject]]] = ["objects": responses.map { $0.jsonValue() } ]
        
        ServerRequest.sharedInstance.patch("response", params: params, always: always, success: {
            (response) -> () in
            
            success()
            
        }, failure: failure)
    }
    
    // MARK: Pebble API
    
    func sendPebbleNotificationTimes(notificationTimes: [NotificationTime], always: AlwaysBlock?, success: () -> Void, failure: FailureBlock?)
    {
        let params = ["objects": Mapper().toJSONArray(notificationTimes)];
        
        ServerRequest.sharedInstance.patch("exercise_reminder/", params: params, always: always, success: {
            (response) -> () in
            
            success()
            
        }, failure: failure)
    }
}
