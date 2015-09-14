//
//  UIViewControllerPopupExtension.swift
//  Repressor Destressor
//
//  Created by Gavin King on 3/20/15.
//  Copyright (c) 2015 Group 2. All rights reserved.
//

import UIKit

private let POPUP_WIDTH: CGFloat = 300.0
private let POPUP_HEIGHT: CGFloat = 168.0

private let DIMMER_ALPHA: CGFloat = 0.5

private let SHOW_DURATION = 0.2
private let HIDE_DURATION = 0.15

private let CORNER_RADIUS:CGFloat = 4.0

typealias PopupDismissalBlock = () -> ()

class PopupDismissalBlockObject
{
    var popupDismissalBlock:PopupDismissalBlock?
    
    init(popupDismissalBlock: PopupDismissalBlock?)
    {
        self.popupDismissalBlock = popupDismissalBlock
    }
}

extension UIViewController
{
    private struct AssociatedKeys
    {
        static var PopupViewControllerKey = "PopupViewControllerKey"
        static var DimmerViewKey = "DimmerViewKey"
        static var DismissalBlockObjectKey = "DismissalBlockObjectKey"
    }
    
    var popupViewController: UIViewController!
    {
        get
        {
            return objc_getAssociatedObject(self, &AssociatedKeys.PopupViewControllerKey) as? UIViewController
        }
        set(newValue)
        {
            objc_setAssociatedObject(self, &AssociatedKeys.PopupViewControllerKey, newValue, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
        }
    }
    
    var dimmerView: UIView!
    {
        get
        {
            return objc_getAssociatedObject(self, &AssociatedKeys.DimmerViewKey) as? UIView
        }
        set(newValue)
        {
            objc_setAssociatedObject(self, &AssociatedKeys.DimmerViewKey, newValue, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
        }
    }
    
    var popupDismissalBlockObject:PopupDismissalBlockObject!
    {
        get
        {
            return objc_getAssociatedObject(self, &AssociatedKeys.DismissalBlockObjectKey) as? PopupDismissalBlockObject
        }
        set(newValue)
        {
            objc_setAssociatedObject(self, &AssociatedKeys.DismissalBlockObjectKey, newValue, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
        }
    }
    
    func presentPopupViewController(popupViewController: UIViewController, popupDismissalBlock: PopupDismissalBlock?)
    {
        self.popupViewController = popupViewController
        self.popupViewController.view.layer.cornerRadius = CORNER_RADIUS
        self.popupViewController.view.clipsToBounds = true

        self.popupDismissalBlockObject = PopupDismissalBlockObject(popupDismissalBlock: popupDismissalBlock)
        
        self.dimmerView = UIView(frame: self.view.bounds)
        self.dimmerView.backgroundColor = UIColor.blackColor()
        self.dimmerView.alpha = 0
        
        self.view.addSubview(self.dimmerView)
        
        UIView.animateWithDuration(SHOW_DURATION, animations: { () -> Void in
            self.dimmerView.alpha = DIMMER_ALPHA
        })
        
        self.addChildViewController(self.popupViewController)
        let frame = CGRectMake((self.view.frame.size.width - POPUP_WIDTH) / 2, (self.view.frame.size.height - POPUP_HEIGHT) / 2, POPUP_WIDTH, POPUP_HEIGHT)
        self.popupViewController.view.frame = frame
        self.view.addSubview(self.popupViewController.view)
        self.popupViewController.didMoveToParentViewController(self)
        
        let scale = CABasicAnimation(keyPath: "transform.scale")
        scale.fromValue = 0.5
        scale.toValue = 1.0
        scale.timingFunction = CAMediaTimingFunction.bounceEaseOut()
        
        let fade = CABasicAnimation(keyPath: "opacity")
        fade.fromValue = 0.0
        fade.toValue = 1.0
        fade.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        
        let group = CAAnimationGroup()
        group.duration = SHOW_DURATION
        group.animations = [scale, fade]
        
        self.popupViewController.view.layer.addAnimation(group, forKey: "animation")
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "dismissPopupViewController")
        self.dimmerView.addGestureRecognizer(tapRecognizer)
    }
    
    func dismissPopupViewController()
    {
        UIView.animateWithDuration(HIDE_DURATION, animations: { () -> Void in
            self.popupViewController.view.alpha = 0
            self.dimmerView.alpha = 0
        }) { (Bool) -> Void in
            self.popupViewController.willMoveToParentViewController(nil)
            self.popupViewController.view.removeFromSuperview()
            self.popupViewController.removeFromParentViewController()
            
            self.dimmerView.removeFromSuperview()
            
            if ((self.popupDismissalBlockObject.popupDismissalBlock) != nil)
            {
                self.popupDismissalBlockObject.popupDismissalBlock!()
            }
            
            self.popupViewController = nil
            self.dimmerView = nil
            self.popupDismissalBlockObject = nil
        }
    }
}
