//
//  UIViewControllerExtension.swift
//  Just Be
//
//  Created by Gavin King on 4/21/15.
//  Copyright (c) 2015 Group 2. All rights reserved.
//

import UIKit

extension UIViewController
{
    func showErrorAlert()
    {
        UIAlertView(title: "Error", message: "Oops! Something went wrong. Please try again.", delegate: nil, cancelButtonTitle: "OK").show()
    }
}
