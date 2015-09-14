//
//  UIColorExtension.swift
//  Repressor Destressor
//
//  Created by Gavin King on 3/20/15.
//  Copyright (c) 2015 Group 2. All rights reserved.
//

import UIKit

extension UIColor
{
    class func backgroundGreen() -> UIColor {
        return UIColor(rgba: "#AACF7C")
    }
    
    class func navBarGreen() -> UIColor {
        return backgroundGreen()
    }
    
    class func buttonGreen() -> UIColor {
        return backgroundGreen()
    }
    
    class func buttonOrange() -> UIColor {
        return UIColor(rgba: "#FFCB57")
    }
    
    class func blackText() -> UIColor {
        return UIColor(rgba: "#333333")
    }
    
    class func grayText() -> UIColor {
        return UIColor(rgba: "#CCCCCC")
    }
    
    class func orangeText() -> UIColor {
        return UIColor.buttonOrange()
    }
    
    class func whiteLowAlpha() -> UIColor {
        return UIColor(rgba: "#FFFFFF").colorWithAlphaComponent(0.08)
    }
    
    class func whiteMediumAlpha() -> UIColor {
        return UIColor(rgba: "#FFFFFF").colorWithAlphaComponent(0.32)
    }
    
    class func whiteHighAlpha() -> UIColor {
        return UIColor(rgba: "#FFFFFF").colorWithAlphaComponent(0.64)
    }
    
    class func lightYellow() -> UIColor {
        return UIColor(rgba: "#FDCA63")
    }
    
    class func darkYellow() -> UIColor {
        return UIColor(rgba: "#FCB24C")
    }
    
    private convenience init(rgba: String)
    {
        var red:   CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue:  CGFloat = 0.0
        var alpha: CGFloat = 1.0
        
        if rgba.hasPrefix("#")
        {
            let index = advance(rgba.startIndex, 1)
            let hex = rgba.substringFromIndex(index)
            let scanner = NSScanner(string: hex)
            var hexValue: CUnsignedLongLong = 0
            
            if scanner.scanHexLongLong(&hexValue)
            {
                switch (count(hex))
                {
                case 3:
                    red = CGFloat((hexValue & 0xF00) >> 8) / 15.0
                    green = CGFloat((hexValue & 0x0F0) >> 4) / 15.0
                    blue = CGFloat(hexValue & 0x00F) / 15.0
                case 4:
                    red = CGFloat((hexValue & 0xF000) >> 12) / 15.0
                    green = CGFloat((hexValue & 0x0F00) >> 8) / 15.0
                    blue = CGFloat((hexValue & 0x00F0) >> 4) / 15.0
                    alpha = CGFloat(hexValue & 0x000F) / 15.0
                case 6:
                    red = CGFloat((hexValue & 0xFF0000) >> 16) / 255.0
                    green = CGFloat((hexValue & 0x00FF00) >> 8) / 255.0
                    blue = CGFloat(hexValue & 0x0000FF) / 255.0
                case 8:
                    red = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                    green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                    blue = CGFloat((hexValue & 0x0000FF00) >> 8) / 255.0
                    alpha = CGFloat(hexValue & 0x000000FF) / 255.0
                default:
                    print("Invalid RGB string, number of characters after '#' should be either 3, 4, 6 or 8")
                }
            }
            else
            {
                println("Scan hex error")
            }
        }
        else
        {
            print("Invalid RGB string, missing '#' as prefix")
        }
        
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
}