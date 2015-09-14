//
//  ExerciseSession.swift
//  Repressor Destressor
//
//  Created by Gavin King on 3/6/15.
//  Copyright (c) 2015 Group 2. All rights reserved.
//

import UIKit
import ObjectMapper

class ExerciseSession: Mappable
{
    var id: Int?
    var exerciseId: Int?
    var createdAt:NSDate?
    
    required init?(_ map: Map)
    {
        mapping(map)
    }
    
    func mapping(mapper: Map)
    {
        id <- mapper["id"]
        exerciseId <- mapper["exercise_id"]
        createdAt <- (mapper["created_at"], DateTimeTransform())
    }
}
