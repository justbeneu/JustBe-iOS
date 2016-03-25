//
//  SignupViewController.swift
//  Repressor Destressor
//
//  Created by Gavin King on 2/13/15.
//  Copyright (c) 2015 Group 2. All rights reserved.
//
//  Modified by Bhavin Vora on 3/25/16.
//  Copyright (c) 2016. All rights reserved.
//

import UIKit


extension String {
    
    func containsValidCharacters() -> Bool {
        
        var charSet = NSCharacterSet(charactersInString: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
        charSet = charSet.invertedSet
        
        let range = (self as NSString).rangeOfCharacterFromSet(charSet)
        
        if range.location != NSNotFound {
            return false
        }
        
        return true
    }
    
}


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
        
        print("Hey we tried to open the signup view")
        
        //let datePicker = UIDatePicker()
        //datePicker.datePickerMode = .Date
        //datePicker.addTarget(self, action: "birthdayChanged", forControlEvents: .ValueChanged)
        //self.birthday.inputView = datePicker
        
        self.signupButton.backgroundColor = UIColor.buttonGreen()
        self.signupButton.layer.cornerRadius = 4
        self.signupButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        
        self.loginButton.setTitleColor(UIColor.buttonGreen(), forState: UIControlState.Normal)
        
        //self.gender.tintColor = UIColor.buttonOrange();
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidHide:", name: UIKeyboardDidHideNotification, object: nil)
        print("above reachability")
        if !Reachability.isConnectedToNetwork() {
            print("not connected to network")
            self.showInternetAlert()
        }
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
    
    //validateEmail
    func validateEmail(enteredEmail:String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluateWithObject(enteredEmail)
    }

     func validateName(enteredName:String) -> Bool {
        let nameFormat = "[A-Za-z]*"
        let namePredicate = NSPredicate(format:"SELF MATCHES %@", nameFormat)
        return namePredicate.evaluateWithObject(nameFormat)
    }
    
    
 /*   func containsOnlyCharactersIn(matchCharacters: String) -> Bool {
        let disallowedCharacterSet = NSCharacterSet(charactersInString: matchCharacters).invertedSet
        return self.rangeOfCharacterFromSet(disallowedCharacterSet) == nil
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
*/
    
/*    func birthdayChanged()
    {
        let date = (self.birthday.inputView as! UIDatePicker).date
        
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.MediumStyle
        
        self.birthday.text = formatter.stringFromDate(date)
    }
*/
    //login fucntion
    @IBAction func logIn(sender: UIButton)
    {
        let loginViewController = LoginViewController(nibName: "LoginViewController", bundle: nil)
        self.navigationController?.setViewControllers([loginViewController], animated: false)
    }
    
    //sign up function
    @IBAction func signUp(sender: UIButton)
    {
        // Validate the password
        if (self.password.text != self.passwordConf.text)
        {
            let alert = UIAlertController(title: "Error", message: "Passwords must match.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: { (ACTION : UIAlertAction!) in print("User exits alert")}))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        //check for empty fields
        if (self.firstName.text == "" || self.firstName.text == nil)
        {
            let alert = UIAlertController(title: "Error", message: "Enter First Name", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: { (ACTION : UIAlertAction!) in print("User exits alert")}))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        } else if (self.lastName.text == "" || self.lastName.text == nil)
        {
            let alert = UIAlertController(title: "Error", message: "Enter Last Name", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: { (ACTION : UIAlertAction!) in print("User exits alert")}))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        } else if (self.email.text == "" || self.email.text == nil)
        {
            let alert = UIAlertController(title: "Error", message: "Enter Email", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: { (ACTION : UIAlertAction!) in print("User exits alert")}))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        } else if (self.userName.text == "" || self.userName.text == nil)
        {
            let alert = UIAlertController(title: "Error", message: "Enter User Name", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: { (ACTION : UIAlertAction!) in print("User exits alert")}))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        } else if (self.password.text == "" || self.password.text == nil)
        {
            let alert = UIAlertController(title: "Error", message: "Enter Password", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: { (ACTION : UIAlertAction!) in print("User exits alert")}))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        //validate email
        if(validateEmail(self.email.text!)){
            print("the email is valid")
        } else {
            let alert = UIAlertController(title: "Error", message: "Enter valid Email", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: { (ACTION : UIAlertAction!) in print("User exits alert")}))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        //validate first name
        let fname = self.firstName.text!
        let validCharFname = fname.containsValidCharacters()
        print(validCharFname)
        
        let fnamelen = fname.characters.count
        
        if(fnamelen > 1 || fnamelen < 25){
            print("First name is valid in length")
        } else {
            let alert = UIAlertController(title: "Error", message: "Enter First Name between 1 to 25 characters", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: { (ACTION : UIAlertAction!) in print("User exits alert")}))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        if(validCharFname){
            print("First name is valid")
        } else {
            let alert = UIAlertController(title: "Error", message: "Enter valid First Name. Use only a-z/A-Z alphabets", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: { (ACTION : UIAlertAction!) in print("User exits alert")}))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        
        //validate last name
        let lname = self.lastName.text!
        let validCharLname = lname.containsValidCharacters()
        print(validCharLname)
        
        let lnamelen = lname.characters.count
        
        if(lnamelen > 1 || lnamelen < 25){
            print("Last name is valid in length")
        } else {
            let alert = UIAlertController(title: "Error", message: "Enter Last Name between 1 to 25 characters", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: { (ACTION : UIAlertAction!) in print("User exits alert")}))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        if(validCharLname){
            print("Last name is valid")
        } else {
            let alert = UIAlertController(title: "Error", message: "Enter valid Last Name. Use only a-z/A-Z alphabets", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: { (ACTION : UIAlertAction!) in print("User exits alert")}))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        //validate user name
        let uname = self.userName.text!
        let validCharUname = uname.containsValidCharacters()
        print(validCharUname)
        
        let unamelen = uname.characters.count
        
        if(unamelen > 6 || unamelen < 25){
            print("User name is valid in length")
        } else {
            let alert = UIAlertController(title: "Error", message: "Enter User Name between 6 to 25 characters", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: { (ACTION : UIAlertAction!) in print("User exits alert")}))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        if(validCharLname){
            print("User name is valid")
        } else {
            let alert = UIAlertController(title: "Error", message: "Enter valid User Name. Use only a-z/A-Z alphabets", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: { (ACTION : UIAlertAction!) in print("User exits alert")}))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        //validate password
        let pword = self.password.text!
        let validCharPword = pword.containsValidCharacters()
        print(validCharPword)
        
        let pwordlen = pword.characters.count
        
        if(pwordlen > 6 || pwordlen < 25){
            print("Password is valid in length")
        } else {
            let alert = UIAlertController(title: "Error", message: "Enter Password between 6 to 25 characters", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: { (ACTION : UIAlertAction!) in print("User exits alert")}))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        if(validCharPword){
            print("Password is valid")
        } else {
            let alert = UIAlertController(title: "Error", message: "Enter valid Password. Use only a-z/A-Z alphabets", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: { (ACTION : UIAlertAction!) in print("User exits alert")}))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }

        
        /**
        * As psychological studies protect subjects' personally identifiable information,
        * we cannot currently include these fields
        **/
        self.user.firstName = self.firstName.text
        self.user.lastName = self.lastName.text
        self.user.email = self.email.text
        self.user.username = self.userName.text
        
        var dataString = "April 01, 1969" as String
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        dateFormatter.timeZone = NSTimeZone.localTimeZone()
        
        // convert string into date
        let dateValue = dateFormatter.dateFromString(dataString) as NSDate!
        self.user.birthday = dateValue //(self.birthday.inputView as! UIDatePicker).date
        self.user.gender = Gender(rawValue:self.gender.selectedSegmentIndex)
        
        self.showLoader()
        
        ServerRequest.sharedInstance.signUp(self.user, password: self.password.text!, always: { () -> () in
            self.hideLoader()
        }, success: { (user) -> Void in
            self.advanceToExerciseSettings()
            self.hideLoader()
        }) { (error, message) -> () in
            self.hideLoader()
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: { (ACTION : UIAlertAction!) in print("User exits alert")}))
            self.presentViewController(alert, animated: false, completion: nil)
        }
    }
    
    func advanceToExerciseSettings()
    {
        let exerciseSettingsViewController = ExerciseSettingsViewController(nibName:"ExerciseSettingsViewController", bundle:nil);
        self.navigationController?.pushViewController(exerciseSettingsViewController, animated: true)
    }
}
