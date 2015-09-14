//
//  TallSlider.swift
//  Repressor Destressor
//
//  Created by Daniel Moreh on 4/14/15.
//  Copyright (c) 2015 Group 2. All rights reserved.
//

import UIKit

class TallSlider: UISlider {
    
    let kTrackHeight: CGFloat = 8
    
    override func trackRectForBounds(bounds: CGRect) -> CGRect {
        super.trackRectForBounds(bounds)
        return CGRect(origin: CGPointZero, size: CGSize(width: bounds.size.width, height: kTrackHeight))
    }
    
}
