//
//  Meditation.swift
//  Repressor Destressor
//
//  Created by Gavin King on 3/23/15.
//  Copyright (c) 2015 Group 2. All rights reserved.
//

import UIKit
import ObjectMapper

class Meditation: Mappable
{
    var id: Int?
    var audioFilename: String?
    
    var sessions: [MeditationSession]
    {
        var sessions:[MeditationSession] = []
        
        for session in UserDefaultsManager.sharedInstance.meditationSessions()
        {
            if (session.meditationId == self.id)
            {
                sessions.append(session)
            }
        }
        
        return sessions
    }
    
    required init?(_ map: Map)
    {
        mapping(map)
    }
    
    func mapping(mapper: Map)
    {
        id <- mapper["id"]
        audioFilename <- mapper["audio_filename"]
    }
    
    func sessionsForDay(day: NSDate) -> [MeditationSession]
    {
        var sessions:[MeditationSession] = []
        
        for session in self.sessions
        {
            if (session.createdAt!.isSameDayAs(day))
            {
                sessions.append(session)
            }
        }
        
        return sessions
    }
}