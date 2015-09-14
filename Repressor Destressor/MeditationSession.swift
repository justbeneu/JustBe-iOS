//
//  MeditationSession.swift
//  Repressor Destressor
//
//  Created by Gavin King on 3/6/15.
//  Copyright (c) 2015 Group 2. All rights reserved.
//

import UIKit
import ObjectMapper

class MeditationSession: Mappable
{
    var id: Int?
    var meditationId: Int?
    var percentCompleted: Float?
    var createdAt:NSDate?
    
    required init?(_ map: Map)
    {
        mapping(map)
    }
    
    func mapping(mapper: Map)
    {
        id <- mapper["id"]
        meditationId <- mapper["meditation_id"]
        percentCompleted <- mapper["percent_completed"]
        createdAt <- (mapper["created_at"], DateTimeTransform())
    }
}