//
//  MeditationViewController.swift
//  Repressor Destressor
//
//  Created by Daniel Moreh on 3/15/15.
//  Copyright (c) 2015 Group 2. All rights reserved.
//

import UIKit

class MeditationViewController: UIViewController, AudioPlayerViewDelegate, MenuViewControllerDelegate
{
    @IBOutlet weak var audioPlayerView: AudioPlayerView!
    @IBOutlet weak var meditationProgressView: MeditationProgressView!
    @IBOutlet weak var exerciseButton: UIButton!
    @IBOutlet weak var returnToThisWeekButton: UIButton!
    
    var exercise: Exercise?
    {
        didSet
        {
            self.populateInterface()
            self.showAlertsIfNecessary()
        }
    }
    
    init()
    {
        super.init(nibName: "MeditationViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.backgroundGreen()
        
        self.exerciseButton.backgroundColor = UIColor.whiteMediumAlpha()
        self.exerciseButton.layer.cornerRadius = 4
        self.exerciseButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        
        self.returnToThisWeekButton.backgroundColor = UIColor.whiteMediumAlpha()
        self.returnToThisWeekButton.layer.cornerRadius = 4
        self.returnToThisWeekButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "applicationDidBecomeActive", name:UIApplicationDidBecomeActiveNotification, object: nil)

        self.audioPlayerView.delegate = self
    }
    
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIApplicationDidBecomeActiveNotification, object: nil)
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.refreshExerciseActivity()
    }
    
    func applicationDidBecomeActive()
    {
        self.refreshExerciseActivity()
        self.getPendingAssessment()
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        if let exercise = self.exercise
        {
            if (self.audioPlayerView.percentage > 0.0)
            {
                // Save the meditation session since we're navigating away from this page
                ExerciseManager.sharedInstance.saveMeditationSession(exercise.meditation!.id!, percentCompleted: self.audioPlayerView.percentage)
            }
        }
    }
    
    private func getPendingAssessment()
    {
        ServerRequest.sharedInstance.pendingAssessment(nil, success: { (assessment) -> Void in
            
            if (self.navigationController!.visibleViewController!.isEqual(self))
            {
                let navigationController = AssessmentNavigationController(assessment: assessment)
                self.navigationController!.presentViewController(navigationController, animated: true, completion: nil)
            }
            
        }, failure: nil)
    }
    
    private func refreshExerciseActivity()
    {
        if (self.exercise == nil)
        {
            self.showLoader()
        }
        
        ExerciseManager.sharedInstance.refreshActivity { (success) -> () in
            
            self.hideLoader()

            if (success)
            {
                self.exercise = ExerciseManager.sharedInstance.currentExercise()
            }
            else
            {
                self.showErrorAlert()
            }
        }
    }
    
    private func populateInterface()
    {
        self.populateMeditationProgress()
        self.populateMeditationAudio()
        self.populateExerciseButton()
        self.populateReturnToThisWeekButton()
    }
    
    private func showAlertsIfNecessary()
    {
        if (self.exercise == nil)
        {
            if (ExerciseManager.sharedInstance.daysSinceStart() < 0)
            {
                UIAlertView(title: "Welcome to Just Be!", message: "Your exercises have not yet started. You will receive a push notification on your start date.", delegate: nil, cancelButtonTitle: "OK").show()
            }
            else
            {
                UIAlertView(title: "Thanks!", message: "Your exercises have ended. We hope you enjoyed Just Be!", delegate: nil, cancelButtonTitle: "OK").show()
            }
        }
    }
    
    func populateMeditationProgress()
    {
        self.meditationProgressView.exercise = self.exercise
    }

    func populateMeditationAudio()
    {
        if let exercise = self.exercise
        {
            let splitFilename = exercise.meditation?.audioFilename?.componentsSeparatedByString(".")
            self.audioPlayerView.audioFileUrl = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(splitFilename?[0], ofType: splitFilename?[1])!)
        }
    }
    
    func populateReturnToThisWeekButton()
    {
        let currentExercise = ExerciseManager.sharedInstance.currentExercise()
        self.returnToThisWeekButton.hidden = self.exercise?.id == currentExercise?.id
    }
    
    func populateExerciseButton()
    {
        // Populate the title
        
        let currentExercise = ExerciseManager.sharedInstance.currentExercise()
        
        if (self.exercise?.id == currentExercise?.id)
        {
            self.exerciseButton.setTitle("This Week's Exercise", forState: .Normal)
        }
        else
        {
            self.exerciseButton.setTitle(self.exercise?.name, forState: .Normal)
        }
        
        // Populate the check
        
        if (self.exercise?.session == nil)
        {
            self.exerciseButton.setImage(UIImage(named: "check_gray"), forState: .Normal)
        }
        else
        {
            self.exerciseButton.setImage(UIImage(named: "check_green"), forState: .Normal)
        }
    }
    
    // MARK: AudioPlayerViewDelegate

    func audioPlayerViewDidPause(audioPlayerView: AudioPlayerView)
    {

    }
    
    func audioPlayerViewDidPlay(audioPlayerView: AudioPlayerView)
    {

    }
    
    // MARK: MenuViewControllerDelegate

    func menuViewControllerDidSelectExercise(menuViewController: MenuViewController, exercise: Exercise)
    {
        self.dismissPopupViewController()
        self.exercise = exercise
    }
    
    // MARK: Actions
    
    @IBAction func showMenu()
    {
        let menuViewController = MenuViewController(nibName: "MenuViewController", bundle: nil)
        menuViewController.delegate = self
        self.presentPopupViewController(menuViewController, popupDismissalBlock: nil)
    }
    
    @IBAction func exerciseButtonTapped(sender: AnyObject?)
    {
        if let exercise = self.exercise
        {
            let exerciseViewController = ExerciseViewController(exercise: exercise)
            let navigationController = UINavigationController(rootViewController: exerciseViewController)
            self.navigationController!.presentViewController(navigationController, animated: true, completion: nil)
        }
    }
    
    @IBAction func returnToThisWeekButtonTapped(sender: AnyObject?)
    {
        self.exercise = ExerciseManager.sharedInstance.currentExercise()
    }

    @IBAction func settingsButtonTapped(sender: AnyObject?)
    {
        let settingsViewController = SettingsViewController(nibName: "SettingsViewController", bundle: nil)
        self.navigationController?.pushViewController(settingsViewController, animated: true)
    }
    
    // MARK: Notifications

//    @objc func receivedExerciseNotification(notification: NSNotification)
//    {
//        self.refreshExerciseActivity { (success) -> () in
//            
//            if (success)
//            {
//                self.exerciseButtonTapped(nil)
//            }
//        }
//    }
//    
//    @objc func receivedAssessmentNotification(notification: NSNotification)
//    {
//        let assessmentId:Int = (notification.userInfo![ID_KEY] as! String).toInt()!
//        
//        let assessmentFlowViewController = AssessmentFlowViewController(assessmentId: assessmentId)
//        let navigationController = UINavigationController(rootViewController: assessmentFlowViewController)
//        self.presentViewController(navigationController, animated: true, completion: nil)
//    }
}
