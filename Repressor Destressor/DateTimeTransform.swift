//
//  TimeTransform.swift
//  Repressor Destressor
//
//  Created by Gavin King on 4/15/15.
//  Copyright (c) 2015 Group 2. All rights reserved.
//

import ObjectMapper

public class DateTimeTransform: TransformType
{
    public typealias Object = NSDate
    public typealias JSON = String
    
    public init() {}
    
    public func transformFromJSON(value: AnyObject?) -> NSDate?
    {
        if let date = value as? String
        {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
            
            let newDate = dateFormatter.dateFromString(date)
            return newDate
        }
        
        return nil
    }
    
    public func transformToJSON(value: NSDate?) -> String?
    {
        if let date = value
        {
            let formatter: NSDateFormatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
            return formatter.stringFromDate(date)
        }
        
        return nil
    }
}