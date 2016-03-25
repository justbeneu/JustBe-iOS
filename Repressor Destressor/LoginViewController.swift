//
//  ViewController.swift
//  Repressor Destressor
//
//  Created by Daniel Moreh on 2/12/15.
//  Copyright (c) 2015 Group 2. All rights reserved.
//
//  Modified by Bhavin Vora on 3/25/16.
//  Copyright (c) 2016. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController
{
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.loginButton.backgroundColor = UIColor.buttonGreen()
        self.loginButton.layer.cornerRadius = 4
        self.loginButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        
        self.signupButton.setTitleColor(UIColor.buttonGreen(), forState: UIControlState.Normal)
    
        if !Reachability.isConnectedToNetwork() {
            self.showInternetAlert()
        }
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    @IBAction func logIn(sender: UIButton)
    {
        let username = self.usernameField.text?.trim()
        let password = self.passwordField.text
        
  //      if (username != "" && password != "" && username != nil && password != nil)
  //      {
        
            if (self.usernameField.text == "" || self.usernameField.text == nil)
            {
                let alert = UIAlertController(title: "Error", message: "Enter User Name", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: { (ACTION : UIAlertAction!) in print("User exits alert")}))
                self.presentViewController(alert, animated: true, completion: nil)
                return
            } else if (self.passwordField.text == "" || self.passwordField.text == nil)
            {
                let alert = UIAlertController(title: "Error", message: "Enter Password", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: { (ACTION : UIAlertAction!) in print("User exits alert")}))
                self.presentViewController(alert, animated: true, completion: nil)
                return
            }
            
            //validate user name
            let uname = self.usernameField.text!
            let validCharUname = uname.containsValidCharacters()
            print(validCharUname)
        
        
        let unamelen = uname.characters.count
        
        if(unamelen > 6 || unamelen < 25){
            print("User name is valid in length")
        } else {
            let alert = UIAlertController(title: "Error", message: "Enter User Name between 6 to 25 characters Use only a-z/A-Z alphabets", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: { (ACTION : UIAlertAction!) in print("User exits alert")}))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }

            if(validCharUname){
                print("User name is valid")
            } else {
                let alert = UIAlertController(title: "Error", message: "Enter valid User Name", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: { (ACTION : UIAlertAction!) in print("User exits alert")}))
                self.presentViewController(alert, animated: true, completion: nil)
                return
            }
            
            //validate password
            let pword = self.passwordField.text!
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
                let alert = UIAlertController(title: "Error", message: "Enter valid Password", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: { (ACTION : UIAlertAction!) in print("User exits alert")}))
                self.presentViewController(alert, animated: true, completion: nil)
                return
            }
        
            self.showLoader()
        
            ServerRequest.sharedInstance.logIn(username!, password: password!, always: { () -> () in
                print("hiding in Login")
            }, success: { (user) -> Void in
                self.hideLoader()
                self.advanceToMeditationPage()
            }, failure: { (error) -> () in
                self.hideLoader()
                self.showErrorAlert()
            })
        }
        
        
//    }
    
    @IBAction func signUp(sender: UIButton)
    {
        let signupViewController = SignupViewController(nibName: "SignupViewController", bundle: nil)
        self.navigationController?.setViewControllers([signupViewController], animated: false);
    }
    
    func advanceToMeditationPage()
    {
        let meditationViewController = MeditationViewController()
        self.navigationController?.setViewControllers([meditationViewController], animated: true);
    }
}

