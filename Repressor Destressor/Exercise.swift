//
//  Exercise.swift
//  Repressor Destressor
//
//  Created by Gavin King on 3/23/15.
//  Copyright (c) 2015 Group 2. All rights reserved.
//

import UIKit
import ObjectMapper

let EXERCISE_LENGTH_IN_DAYS = 7

class Exercise: Mappable, Equatable
{
    var id: Int?
    var name: String?
    var viewName: String?
    var pebbleMessage: String?
    var meditation: Meditation?
    
    private var meditationId: Int?
    
    var session: ExerciseSession?
    {
        for session in UserDefaultsManager.sharedInstance.exerciseSessions()
        {
            if (session.exerciseId == self.id)
            {
                return session
            }
        }
        
        return nil
    }
    
    required init?(_ map: Map)
    {
        mapping(map)
        
        meditation = ExerciseManager.sharedInstance.meditationWithId(self.meditationId!)
    }
    
    func mapping(mapper: Map)
    {
        id <- mapper["id"]
        name <- mapper["name"]
        meditationId <- mapper["meditation_id"]
        viewName <- mapper["view_name"]
        pebbleMessage <- mapper["pebble_message"]
    }
}

// MARK: Equatable

func == (lhs: Exercise, rhs: Exercise) -> Bool
{
    return lhs.id == rhs.id
}
