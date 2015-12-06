//
//  ExerciseViewController.swift
//  Repressor Destressor
//
//  Created by Daniel Moreh on 3/15/15.
//  Copyright (c) 2015 Group 2. All rights reserved.
//

import UIKit

private let BUTTON_VERTICAL_MARGIN:CGFloat = 16.0

class ExerciseViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollContainer: UIView!
    @IBOutlet weak var containerWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var completeButton: UIButton!
    
    var exercise:Exercise
    
    var setup = false
    
    init(exercise: Exercise)
    {
        self.exercise = exercise

        super.init(nibName: "ExerciseViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.title = "Exercise"
        
        let closeButton : UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "close"), style: .Plain, target: self, action: "close")
        self.navigationItem.leftBarButtonItem = closeButton
        
        self.completeButton.backgroundColor = UIColor.buttonGreen()
        self.completeButton.layer.cornerRadius = 4
        self.completeButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        
        if (self.exercise.session != nil)
        {
            self.completeButton.enabled = false
            self.completeButton.alpha = 0.5;
            self.completeButton.setTitle("Completed", forState: .Normal)
        }
        
        if !Reachability.isConnectedToNetwork() {
            self.showInternetAlert()
        }
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        
        if (!setup)
        {
            let exerciseView = self.loadViewWithName(self.exercise.viewName!)
            
            var frame = exerciseView.frame
            frame.size.width = self.view.frame.size.width
            exerciseView.frame = frame
            
            exerciseView.compressTextSubviews()
            exerciseView.layoutIfNeeded()
            exerciseView.resizeToFitSubviews()
            
            self.containerWidthConstraint.constant = exerciseView.frame.size.width
            self.containerHeightConstraint.constant = exerciseView.frame.size.height + (BUTTON_VERTICAL_MARGIN * 4) + self.completeButton.frame.size.height
            self.scrollContainer.layoutIfNeeded()
            
            self.scrollContainer.addSubview(exerciseView)
            
            self.setup = true
        }
    }
    
    @IBAction func didTapCompleteExercise(sender: UIButton)
    {
        self.showLoader()
        
        ServerRequest.sharedInstance.completeExercise(self.exercise.id!, always: { () -> () in
           
        }, success: { () -> Void in
            self.hideLoader()
            PebbleHelper.instance.pushNewExerciseMessage(self.exercise.pebbleMessage!)
            self.close()
            
        }) { (error, message) -> () in
            self.hideLoader()
            self.showErrorAlert()
        }
    }
    
    func close()
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func loadViewWithName(name: String) -> UIView
    {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: name, bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        
        return view
    }
}