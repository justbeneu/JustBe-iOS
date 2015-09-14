//
//  TimeTransform.swift
//  Repressor Destressor
//
//  Created by Gavin King on 4/15/15.
//  Copyright (c) 2015 Group 2. All rights reserved.
//

import ObjectMapper

public class TimeTransform: TransformType
{
    public typealias Object = NSDate
    public typealias JSON = String
    
    public init() {}
    
    public func transformFromJSON(value: AnyObject?) -> NSDate?
    {
        if let date = value as? String
        {
            var dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "HH:mm:ss"
            
            return dateFormatter.dateFromString(date)
        }
        
        return nil
    }
    
    public func transformToJSON(value: NSDate?) -> String?
    {
        if let date = value
        {
            var formatter: NSDateFormatter = NSDateFormatter()
            formatter.dateFormat = "HH:mm:ss"
            return formatter.stringFromDate(date)
        }
        
        return nil
    }
}
