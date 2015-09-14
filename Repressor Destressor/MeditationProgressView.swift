//
//  MeditationProgressView.swift
//  Repressor Destressor
//
//  Created by Gavin King on 4/7/15.
//  Copyright (c) 2015 Group 2. All rights reserved.
//

import UIKit

private let COMPLETED_PERCENTAGE:Float = 0.90

class MeditationProgressView: UIView
{
    var view: UIView!
    
    @IBOutlet weak var checkContainer: UIView!
    
    @IBOutlet var dayLabels: [UILabel]!
    @IBOutlet var checkImages: [UIImageView]!
    
    var exercise: Exercise?
    {
        didSet
        {
            refresh()
        }
    }

    override init(frame: CGRect)
    {
        super.init(frame: frame)

        self.dayLabels.sort({ $0.frame.origin.x < $1.frame.origin.x })
        self.checkImages.sort({ $0.frame.origin.x < $1.frame.origin.x })
    }
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    func setup()
    {
        self.view = loadViewFromNib()
        self.view.frame = bounds
        self.view.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        self.addSubview(view)
        
        self.backgroundColor = UIColor.clearColor()
        self.checkContainer.layer.cornerRadius = 4
        self.checkContainer.backgroundColor = UIColor.whiteLowAlpha()
    }
    
    func loadViewFromNib() -> UIView
    {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "MeditationProgressView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
    }
    
    func refresh()
    {
        if let exercise = self.exercise
        {
            let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
            
            let exerciseStartDate = ExerciseManager.sharedInstance.startDateForExercise(exercise)
            let exerciseStartWeekday = calendar.components(.CalendarUnitWeekday, fromDate: exerciseStartDate).weekday
            
            for (var i = 0; i < EXERCISE_LENGTH_IN_DAYS; i++)
            {
                let dayLabel = self.dayLabels[i]
                let checkImage = self.checkImages[i]
                
                let meditationDate = exerciseStartDate.getDateAfterDays(i)
                let meditationWeekday = (exerciseStartWeekday + i) % EXERCISE_LENGTH_IN_DAYS
                
                // Set today as bold
                
                if (meditationDate.isSameDayAs(NSDate()))
                {
                    dayLabel.font = UIFont.boldSystemFontOfSize(dayLabel.font.pointSize)
                    dayLabel.textColor = UIColor.whiteColor()
                }
                else
                {
                    dayLabel.font = UIFont.systemFontOfSize(dayLabel.font.pointSize)
                    dayLabel.textColor = UIColor.whiteMediumAlpha()
                }
                
                // Set the label
                
                let meditationWeekdayDescription = DayOfWeek.getDayOfWeekForWeekday(meditationWeekday).description
                let range = Range(start: meditationWeekdayDescription.startIndex, end: advance(meditationWeekdayDescription.startIndex, 1))
                dayLabel.text = meditationWeekdayDescription.substringWithRange(range)
                
                // Set the check image
                
                var sessions = exercise.meditation!.sessionsForDay(meditationDate)
                sessions.sort({ $0.percentCompleted > $1.percentCompleted })
                checkImage.highlighted = (sessions.count > 0 && sessions[0].percentCompleted > COMPLETED_PERCENTAGE)
            }
        }
    }
}
