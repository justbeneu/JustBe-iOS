//
//  ExerciseCell.swift
//  Repressor Destressor
//
//  Created by Gavin King on 3/23/15.
//  Copyright (c) 2015 Group 2. All rights reserved.
//

import UIKit

class ExerciseCell: UITableViewCell
{
    @IBOutlet weak var checkIcon: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    var exercise:Exercise?
    {
        didSet
        {
            if (self.exercise == nil)
            {
                return
            }
            
            let currentExercise = ExerciseManager.sharedInstance.currentExercise()
            
            // Set the title
            
            if (self.exercise?.id == currentExercise?.id)
            {
                self.label.text = "This Week's Exercise"
                self.label.font = UIFont.boldSystemFontOfSize(self.label.font.pointSize)
            }
            else
            {
                self.label.text = self.exercise?.name
                self.label.font = UIFont.systemFontOfSize(self.label.font.pointSize)
            }
            
            // Set the check image
            
            if (self.exercise?.session != nil)
            {
                self.checkIcon.image = UIImage(named: "check_green")
            }
            
            // Disable future exercises
            
            if (self.exercise!.id > currentExercise?.id)
            {
                self.label.textColor = UIColor.grayText()
                self.userInteractionEnabled = false
            }
        }
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        self.setStyle()
    }
    
    override func prepareForReuse()
    {
        super.prepareForReuse()

        self.setStyle()
    }
    
    func setStyle()
    {
        self.exercise = nil;

        self.label.textColor = UIColor.blackText()
        self.checkIcon.image = UIImage(named: "check_gray")
        self.userInteractionEnabled = true
    }
}
