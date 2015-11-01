//
//  SignupViewController.swift
//  Repressor Destressor
//
//  Created by Gavin King on 2/13/15.
//  Copyright (c) 2015 Group 2. All rights reserved.
//

import UIKit


class SignupViewController: UIViewController
{
    let user = User()
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollContainer: UIView!
    @IBOutlet weak var containerWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var birthday: UITextField!
    @IBOutlet weak var gender: UISegmentedControl!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var passwordConf: UITextField!
    
    var setup = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .Date
        datePicker.addTarget(self, action: "birthdayChanged", forControlEvents: .ValueChanged)
        self.birthday.inputView = datePicker
        
        self.signupButton.backgroundColor = UIColor.buttonGreen()
        self.signupButton.layer.cornerRadius = 4
        self.signupButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        
        self.loginButton.setTitleColor(UIColor.buttonGreen(), forState: UIControlState.Normal)
        
        self.gender.tintColor = UIColor.buttonOrange();
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidHide:", name: UIKeyboardDidHideNotification, object: nil)
    }
    
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardDidHideNotification, object: nil)
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        
        if (!setup)
        {
            self.containerWidthConstraint.constant = self.view.frame.size.width
            self.containerHeightConstraint.constant = self.view.frame.size.height
            
            self.setup = true
        }
    }
    
    func keyboardDidShow (notification: NSNotification)
    {
        let info : NSDictionary = notification.userInfo!
        
        if let keyboardSize: CGSize = info[UIKeyboardFrameEndUserInfoKey]?.CGRectValue.size
        {
            self.containerHeightConstraint.constant = self.view.frame.size.height + keyboardSize.height
        }
    }
    
    func keyboardDidHide (notification: NSNotification)
    {
        let info : NSDictionary = notification.userInfo!

        if let keyboardSize: CGSize = info[UIKeyboardFrameEndUserInfoKey]?.CGRectValue.size
        {
            self.containerHeightConstraint.constant = self.view.frame.size.height - keyboardSize.height
        }
    }
    
    func birthdayChanged()
    {
        let date = (self.birthday.inputView as! UIDatePicker).date
        
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.MediumStyle
        
        self.birthday.text = formatter.stringFromDate(date)
    }
    
    @IBAction func logIn(sender: UIButton)
    {
        let loginViewController = LoginViewController(nibName: "LoginViewController", bundle: nil)
        self.navigationController?.setViewControllers([loginViewController], animated: false)
    }
    
    @IBAction func signUp(sender: UIButton)
    {
        // Validate the password
        
        if (self.password.text != self.passwordConf.text)
        {
            UIAlertView(title: "Error", message: "Passwords must match.", delegate: nil, cancelButtonTitle: "OK").show()
            return
        }
            
        self.user.firstName = self.firstName.text
        self.user.lastName = self.lastName.text
        self.user.email = self.email.text
        self.user.username = self.userName.text
        self.user.birthday = (self.birthday.inputView as! UIDatePicker).date
        self.user.gender = Gender(rawValue:self.gender.selectedSegmentIndex)
        
        self.showLoader()
        
        ServerRequest.sharedInstance.signUp(self.user, password: self.password.text!, always: { () -> () in
            self.hideLoader()
        }, success: { (user) -> Void in
            self.advanceToExerciseSettings()
        }) { (error, message) -> () in
            UIAlertView(title: "Error", message: message, delegate: nil, cancelButtonTitle: "OK").show()
        }
    }
    
    func advanceToExerciseSettings()
    {
        let exerciseSettingsViewController = ExerciseSettingsViewController(nibName:"ExerciseSettingsViewController", bundle:nil);
        self.navigationController?.pushViewController(exerciseSettingsViewController, animated: true)
    }
}
