//
//  SleepTimeControllerViewController.swift
//  Just Be
//
//  Created by Bhavin Haresh Vora on 3/23/16.
//  Copyright © 2016 Group 2. All rights reserved.
//

import UIKit

class SleepTimeControllerViewController: UIViewController {

    
    var exerciseDay:DayOfWeek!
    var exerciseTime:NSDate!
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var timeLabel: UILabel!
    
    init(exerciseDay: DayOfWeek, exerciseTime: NSDate)
    {
        self.exerciseDay = exerciseDay
        self.exerciseTime = exerciseTime
        
        super.init(nibName: "SleepTimeControllerViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.nextButton.backgroundColor = UIColor.buttonGreen()
        self.nextButton.layer.cornerRadius = 4
        self.nextButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        
        self.timeLabel.textColor = UIColor.blackText()
        
        if !Reachability.isConnectedToNetwork() {
            self.showInternetAlert()
        }
    }

    
    @IBAction func next(sender: AnyObject)
    {
        let exerciseDay = self.exerciseDay
        let exerciseTime = self.exerciseTime
        let sleepTime = self.timePicker.date
        
        let wakeUpTimeViewController = WakeUpTimeViewController(exerciseDay: exerciseDay, exerciseTime: exerciseTime, sleepTime: sleepTime)
        
        print("trying to push first exercise")
        var toPost:NSNumber!
        toPost = NSNumber(integer:0)
        ServerRequest.sharedInstance.exercisePush(toPost, always: nil, success: {
            (response) -> () in
            print(response)
            // success()
            }, failure: {
                (error) -> Void in
                print("error trying to push first exercise")
        })
        var percent:NSNumber!
        percent = NSNumber(float:0.0)
        ServerRequest.sharedInstance.meditate(toPost, percentCompleted : percent, always: nil, success: {
            (response) -> () in
            print(response)
            // success()
            }, failure: {
                (error) -> Void in
                print("error trying to push first meditation")
        })
        self.navigationController?.pushViewController(wakeUpTimeViewController, animated: true)
    }

    
    
    
/*    @IBAction func next(sender: AnyObject)
    {
        let exerciseDay = self.exerciseDay
        let exerciseTime = self.sleepTime
        
        let meditationTimeViewController = MeditationTimeViewController(exerciseDay: exerciseDay, exerciseTime: exerciseTime, sleepTime: sleepTime)
        
        print("trying to push first exercise")
        var toPost:NSNumber!
        toPost = NSNumber(integer:0)
        ServerRequest.sharedInstance.exercisePush(toPost, always: nil, success: {
            (response) -> () in
            print(response)
            // success()
            }, failure: {
                (error) -> Void in
                print("error trying to push first exercise")
        })
        var percent:NSNumber!
        percent = NSNumber(float:0.0)
        ServerRequest.sharedInstance.meditate(toPost, percentCompleted : percent, always: nil, success: {
            (response) -> () in
            print(response)
            // success()
            }, failure: {
                (error) -> Void in
                print("error trying to push first meditation")
        })
        self.navigationController?.pushViewController(meditationTimeViewController, animated: true)
    }
*/
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
