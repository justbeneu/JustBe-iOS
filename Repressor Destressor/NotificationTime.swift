//
//  NotificationTime.swift
//  Just Be
//
//  Created by Gavin King on 5/2/15.
//  Copyright (c) 2015 Group 2. All rights reserved.
//

import UIKit
import ObjectMapper

class NotificationTime: Mappable
{
    var notificationTime: NSDate?
    
    init(notificationTime: NSDate)
    {
        self.notificationTime = notificationTime
    }
    
    required init?(_ map: Map)
    {
        mapping(map)
    }
    
    func mapping(mapper: Map)
    {
        notificationTime <- (mapper["notification_time"], DateTimeTransform())
    }
}