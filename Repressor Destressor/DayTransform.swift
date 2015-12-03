//
//  DateTransform.swift
//  Repressor Destressor
//
//  Created by Gavin King on 4/15/15.
//  Copyright (c) 2015 Group 2. All rights reserved.
//

import ObjectMapper

public class DayTransform: TransformType
{
    public typealias Object = NSDate
    public typealias JSON = String
    
    public init() {}
    
    public func transformFromJSON(value: AnyObject?) -> NSDate?
    {
        if let date = value as? String
        {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            return dateFormatter.dateFromString(date)
        }
        
        return nil
    }
    
    public func transformToJSON(value: NSDate?) -> String?
    {
        if let date = value
        {
            let formatter: NSDateFormatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter.stringFromDate(date)
        }
        
        return nil
    }
}