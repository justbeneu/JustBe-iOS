//
//  CAMediaTimingFunctionEasingsExtension.swift
//  Repressor Destressor
//
//  Created by Gavin King on 3/20/15.
//  Copyright (c) 2015 Group 2. All rights reserved.
//

import UIKit

extension CAMediaTimingFunction
{
    class func bounceEaseOut() -> CAMediaTimingFunction
    {
        return CAMediaTimingFunction(controlPoints: 0.42, 1.4, 0.42, 0.94)
    }
}