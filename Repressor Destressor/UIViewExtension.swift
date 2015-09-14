//
//  UIViewExtension.swift
//  Just Be
//
//  Created by Gavin King on 4/22/15.
//  Copyright (c) 2015 Group 2. All rights reserved.
//

import UIKit

extension UIView
{
    func resizeToFitSubviews()
    {
        var lowestBottom:CGFloat = 0.0
        
        for view in self.subviews
        {
            let viewBottom:CGFloat = view.frame.origin.y + view.frame.size.height
            
            if (viewBottom > lowestBottom)
            {
                lowestBottom = viewBottom
            }
        }
        
        var frame = self.frame
        frame.size.height = lowestBottom
        self.frame = frame
    }
    
    func compressTextSubviews()
    {
        for view in self.subviews
        {
            let view = view as! UIView
            
            if (view.isKindOfClass(UILabel) || view.isKindOfClass(UITextView))
            {
                let size = view.sizeThatFits(CGSizeMake(view.frame.size.width, CGFloat.max))
                var frame = view.frame
                frame.size.height = size.height
                view.frame = frame
            }
        }
    }
}