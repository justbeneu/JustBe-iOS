//
//  Assessment.swift
//  Just Be
//
//  Created by Gavin King on 4/26/15.
//  Copyright (c) 2015 Group 2. All rights reserved.
//

import UIKit
import ObjectMapper

class Assessment: Mappable
{
    var id: Int?
    var isMomentary: Bool?
    
    required init?(_ map: Map)
    {
        mapping(map)
    }
    
    func mapping(mapper: Map)
    {
        id <- mapper["assessment"]
        isMomentary <- mapper["is_momentary"]
    }
}