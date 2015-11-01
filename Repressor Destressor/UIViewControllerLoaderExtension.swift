//
//  UIViewControllerLoaderExtension.swift
//  Just Be
//
//  Created by Gavin King on 4/19/15.
//  Copyright (c) 2015 Group 2. All rights reserved.
//

import UIKit

extension UIViewController
{
    private struct AssociatedKeys
    {
        static var LoaderContainerKey = "LoaderContainerKey"
        static var LoaderCountKey = "LoaderCountKey"
    }
    
    var loaderContainer: UIView?
    {
        get
        {
            return objc_getAssociatedObject(self, &AssociatedKeys.LoaderContainerKey) as? UIView
        }
        set(newValue)
        {
            objc_setAssociatedObject(self, &AssociatedKeys.LoaderContainerKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var loaderCount: Int?
    {
        get
        {
            return objc_getAssociatedObject(self, &AssociatedKeys.LoaderCountKey) as? Int
        }
        set(newValue)
        {
            objc_setAssociatedObject(self, &AssociatedKeys.LoaderCountKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    func showLoader()
    {
        if (self.loaderCount == nil)
        {
            self.loaderCount = 0
        }
        
        if (self.loaderCount == 0)
        {
            self.addView()
        }
        
        self.loaderCount!++
    }
    
    func hideLoader()
    {
        
        self.loaderCount!--
        
        if (self.loaderCount == 0)
        {
            self.removeView()
        }
    }
    
    private func addView()
    {
        self.view.userInteractionEnabled = false
        
        let loaderContainer: UIView = UIView()
        loaderContainer.frame = UIScreen.mainScreen().bounds
        
        let loaderBackground: UIView = UIView()
        loaderBackground.frame = CGRectMake(0, 0, 80, 80)
        loaderBackground.center = CGPointMake(loaderContainer.frame.size.width / 2, loaderContainer.frame.size.height / 2);
        loaderBackground.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.64)
        loaderBackground.clipsToBounds = true
        loaderBackground.layer.cornerRadius = 10
        
        let loader: UIActivityIndicatorView = UIActivityIndicatorView()
        loader.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
        loader.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        loader.center = CGPointMake(loaderBackground.frame.size.width / 2, loaderBackground.frame.size.height / 2);
        loaderBackground.addSubview(loader)
        loaderContainer.addSubview(loaderBackground)
        
        self.loaderContainer = loaderContainer
        
        if (self.navigationController != nil)
        {
            self.navigationController!.view.addSubview(loaderContainer)
        }
        else
        {
            self.view.addSubview(loaderContainer)
        }
        
        loader.startAnimating()
    }
    
    private func removeView()
    {
        self.loaderContainer?.removeFromSuperview()
        self.loaderContainer = nil
        
        self.view.userInteractionEnabled = true
    }
}
