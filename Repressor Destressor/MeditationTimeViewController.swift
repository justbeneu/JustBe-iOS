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
    
    required init(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.doneButton.backgroundColor = UIColor.buttonGreen()
        self.doneButton.layer.cornerRadius = 4
        self.doneButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        
        self.timeLabel.textColor = UIColor.blackText()
    }
    
    @IBAction func done(sender: AnyObject)
    {
        // Register for push notifications before signing up
        
        var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.registerForPushNotifications { (token) -> () in
            
            if (token == nil)
            {
                UIAlertView(title: "Enable Notifications", message: "Please enable notifications by going to Nofications > Just Be in your phone settings.", delegate: nil, cancelButtonTitle: "OK").show()
                return
            }
            
            self.showLoader()
            
            ServerRequest.sharedInstance.setNotificationSettings(token!, exerciseDay: self.exerciseDay, exerciseTime: self.exerciseTime, meditationTime: self.timePicker.date, always: { () -> () in
                self.hideLoader()
                }, success: { () -> Void in
                    self.advanceToMeditationPage()
                }) { (error, message) -> () in
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
