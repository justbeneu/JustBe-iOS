//
//  AppDelegate.swift
//  Repressor Destressor
//
//  Created by Daniel Moreh on 2/12/15.
//  Copyright (c) 2015 Group 2. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics

typealias NotificationTokenHandler = (token: String?) -> ()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    var window: UIWindow?
    
    var notificationsHandler: NotificationTokenHandler?

    func application(application: UIApplication,didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool
    {
        // UserDefaultsManager.sharedInstance.clear()

        Fabric.with([Crashlytics()])

        UINavigationBar.appearance().barStyle = .Default
        UINavigationBar.appearance().translucent = false
        UINavigationBar.appearance().barTintColor = UIColor.navBarGreen()
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont.systemFontOfSize(20)];
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.makeKeyAndVisible()
        
        var viewController:UIViewController? = nil
        
        if let loggedInUser = UserDefaultsManager.sharedInstance.loggedInUser()
        {
            if (loggedInUser.exerciseDayOfWeek == nil || loggedInUser.exerciseTime == nil || loggedInUser.meditationTime == nil)
            {
                viewController = ExerciseSettingsViewController(nibName:"ExerciseSettingsViewController", bundle:nil);
            }
            else
            {
                viewController = MeditationViewController()
            }
        }
        else
        {
            viewController = SignupViewController(nibName: "SignupViewController", bundle: nil)
        }
    
        let navigationController: UINavigationController = UINavigationController(rootViewController: viewController!)
        navigationController.setNavigationBarHidden(true, animated: false)
        self.window!.rootViewController = navigationController
        
        // Setup Pebble
        
        let pebbleHelper = PebbleHelper.instance
        
        if (pebbleHelper.watch != nil)
        {
            pebbleHelper.UUID = "3f5e2157-f75b-4493-9339-56037c985560"
        }
        
        return true
    }

    func applicationWillResignActive(application: UIApplication)
    {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication)
    {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication)
    {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication)
    {
        print("sending pebble notification time")
        ServerRequest.sharedInstance.sendPebbleNotificationTimes(UserDefaultsManager.sharedInstance.notificationTimes(), always: nil, success: { () -> Void in
            print("pebble notification time send was successfull")
        }, failure: nil)
    }

    func applicationWillTerminate(application: UIApplication)
    {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData)
    {
        let characterSet: NSCharacterSet = NSCharacterSet( charactersInString: "<>" )
        let deviceTokenString: String = (deviceToken.description as NSString).stringByTrimmingCharactersInSet(characterSet).stringByReplacingOccurrencesOfString(" ", withString: "") as String
        
        self.notificationsHandler?(token: deviceTokenString)
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError)
    {
        print("Failed to register for push notifications.", terminator: "")
        
        self.notificationsHandler?(token: nil)
    }
    
    func registerForPushNotifications(handler: NotificationTokenHandler)
    {
        let type: UIUserNotificationType = [UIUserNotificationType.Badge, UIUserNotificationType.Alert, UIUserNotificationType.Sound];
        let setting = UIUserNotificationSettings(forTypes: type, categories: nil);
        print("In Register for push notifications")
        UIApplication.sharedApplication().registerUserNotificationSettings(setting);
        print("registered user notification settings")
        UIApplication.sharedApplication().registerForRemoteNotifications();
        
        print("registered for remote notifications\n")
        print(handler)
        
        self.notificationsHandler = handler;
    }
}
