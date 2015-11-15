//
//  ViewController.swift
//  Repressor Destressor
//
//  Created by Daniel Moreh on 2/12/15.
//  Copyright (c) 2015 Group 2. All rights reserved.
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
        
        if (username != "" && password != "" && username != nil && password != nil)
        {
            self.showLoader()
            
            ServerRequest.sharedInstance.logIn(username!, password: password!, always: { () -> () in
                self.hideLoader()
            }, success: { (user) -> Void in
                self.advanceToMeditationPage()
            }, failure: { (error) -> () in
                self.showErrorAlert()
            })
        }
    }
    
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

