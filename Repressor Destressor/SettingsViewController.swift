//
//  SettingsViewController.swift
//  Just Be
//
//  Created by Gavin King on 4/21/15.
//  Copyright (c) 2015 Group 2. All rights reserved.
//

import UIKit
import MessageUI

private let CELL_NAME = "SettingsCell"
private let CONTACT_EMAIL = "justbecontact@gmail.com"

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate
{
    @IBOutlet weak var tableView: UITableView!
    
    let user = UserDefaultsManager.sharedInstance.loggedInUser()!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.registerNib(UINib(nibName: CELL_NAME, bundle: nil), forCellReuseIdentifier: CELL_NAME)
        
        self.title = "Settings"

        let closeButton : UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "back"), style: .Plain, target: self, action: "close")
        self.navigationItem.leftBarButtonItem = closeButton
        
        if !Reachability.isConnectedToNetwork() {
            self.showInternetAlert()
        }
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func close()
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func sendEmail()
    {
        let composeViewController = MFMailComposeViewController()
        composeViewController.mailComposeDelegate = self
        composeViewController.setToRecipients([CONTACT_EMAIL])
        self.navigationController!.presentViewController(composeViewController, animated: true, completion: nil)
    }
    
    func logOut()
    {
        self.showLoader()
        print("outer logout")
        ServerRequest.sharedInstance.logOut(nil, success: { () -> Void in
            print("inner logout")
            self.hideLoader()
            let loginViewController = LoginViewController(nibName: "LoginViewController", bundle: nil)
            self.navigationController?.setViewControllers([loginViewController], animated: true);
        }, failure: {
            () -> () in
            print("error message in logout")
            self.hideLoader()
            self.showErrorAlert()
        })
        self.hideLoader()
        advanceToSignUp()
    }
    
    // MARK: UITableView Delegate
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 6
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 44.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier(CELL_NAME) as! SettingsCell

        switch indexPath.row
        {
            /*
        case 0:
            //cell.label.text = "First Name"
            //cell.value.text = self.user.firstName
            break
        case 1:
            //cell.label.text = "Last Name"
            //cell.value.text = self.user.lastName
            break
*/
        case 0:
            cell.label.text = "Username"
            cell.value.text = self.user.username
            break
            /*
        case 3:
            //cell.label.text = "Email"
            //cell.value.text = self.user.email
            break
*/
        case 1:
            cell.label.text = "Exercise Day"
            cell.value.text = self.user.exerciseDayOfWeek?.description
            break
        case 2:
            cell.label.text = "Exercise Time"
            let timeFormatter = NSDateFormatter()
            timeFormatter.dateFormat = "h:mm a";
            cell.value.text = timeFormatter.stringFromDate(self.user.exerciseTime!)
            break
        case 3:
            cell.label.text = "Meditation Time"
            let timeFormatter = NSDateFormatter()
            timeFormatter.dateFormat = "h:mm a";
            cell.value.text = timeFormatter.stringFromDate(self.user.meditationTime!)
            break
        case 4:
            cell.label.text = "Send Feedback"
            cell.label.font = UIFont.boldSystemFontOfSize(cell.label.font.pointSize)
            break
        case 5:
            cell.label.text = "Log Out"
            cell.label.font = UIFont.boldSystemFontOfSize(cell.label.font.pointSize)
            cell.label.textColor = UIColor.orangeText()
            break
        default:
            break
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath)
    {
        cell.separatorInset.left = CGFloat(0.0)
        tableView.layoutMargins = UIEdgeInsetsZero
        cell.layoutMargins.left = CGFloat(0.0)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        switch indexPath.row
        {
        case 4:
            self.sendEmail()
            break
        case 5:
            self.logOut()
            break
        default:
            break
        }
    }
    
    // MARK: MFMailComposeViewController Delegate
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?)
    {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func advanceToSignUp()
    {
        let signupViewController = SignupViewController(nibName:"SignupViewController", bundle:nil);
        self.navigationController?.pushViewController(signupViewController, animated: true)
    }
}