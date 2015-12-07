//
//  ExerciseSettingsViewController.swift
//  Repressor Destressor
//
//  Created by Kyle Venn on 3/17/15.
//  Copyright (c) 2015 Group 2. All rights reserved.
//

import UIKit

class ExerciseSettingsViewController: UIViewController
{
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var dayOfWeek: UISegmentedControl!
    @IBOutlet weak var timeOfDay: UIDatePicker!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.nextButton.backgroundColor = UIColor.buttonGreen()
        self.nextButton.layer.cornerRadius = 4
        self.nextButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        
        self.dayOfWeek.tintColor = UIColor.buttonOrange();
        
        self.dayLabel.textColor = UIColor.blackText()
        self.timeLabel.textColor = UIColor.blackText()
    }
    
    @IBAction func next(sender: AnyObject)
    {
        let exerciseDay = DayOfWeek(rawValue: self.dayOfWeek.selectedSegmentIndex)!
        let exerciseTime = self.timeOfDay.date
        
        let meditationTimeViewController = MeditationTimeViewController(exerciseDay: exerciseDay, exerciseTime: exerciseTime)
        
        print("trying to push first exercise")
        ServerRequest.sharedInstance.exercisePush(0, always: nil, success: {
            (response) -> () in
            print(response)
           // success()
            }, failure: {
                (error) -> Void in
                print("error trying to push first exercise")
            })
        ServerRequest.sharedInstance.meditate(0, percentCompleted : 0.0, always: nil, success: {
            (response) -> () in
            print(response)
            // success()
            }, failure: {
                (error) -> Void in
                print("error trying to push first meditation")
        })
        
        self.navigationController?.pushViewController(meditationTimeViewController, animated: true)
    }
}
