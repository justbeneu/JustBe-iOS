//
//  MeditationTimeViewController.swift
//  Repressor Destressor
//
//  Created by Kyle Venn on 3/15/15.
//  Copyright (c) 2015 Group 2. All rights reserved.
//

import UIKit

class MeditationTimeViewController: UIViewController
{
    var exerciseDay:DayOfWeek!
    var exerciseTime:NSDate!
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var timeLabel: UILabel!
    
    init(exerciseDay: DayOfWeek, exerciseTime: NSDate)
    {
        self.exerciseDay = exerciseDay
        self.exerciseTime = exerciseTime
        
        super.init(nibName: "MeditationTimeViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.doneButton.backgroundColor = UIColor.buttonGreen()
        self.doneButton.layer.cornerRadius = 4
        self.doneButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        
        self.timeLabel.textColor = UIColor.blackText()
        
        if !Reachability.isConnectedToNetwork() {
            self.showInternetAlert()
        }
    }
    
    @IBAction func done(sender: AnyObject)
    {
        // Register for push notifications before signing up
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.registerForPushNotifications { (token) -> () in
            
            if (token == nil)
            {
                let notice = UIAlertController(title: "Enable Notifications", message: "Please enable notifications by going to Nofications > Just Be in your phone settings.", preferredStyle: UIAlertControllerStyle.Alert)
                notice.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: { (ACTION : UIAlertAction!) in print("User exits alert")}))
                self.presentViewController(notice, animated: true, completion: nil)
                return
            }
            
            self.showLoader()
            
            ServerRequest.sharedInstance.setNotificationSettings(token!, exerciseDay: self.exerciseDay, exerciseTime: self.exerciseTime, meditationTime: self.timePicker.date, always: { () -> () in
    
                }, success: { () -> Void in
                    self.hideLoader()
                    self.advanceToMeditationPage()
                }) { (error, message) -> () in
                    self.hideLoader()
                    self.showErrorAlert()
            }
        }
    }
    
    func advanceToMeditationPage()
    {
        let meditationViewController = MeditationViewController()
        self.navigationController?.setViewControllers([meditationViewController], animated: true);
    }
}
