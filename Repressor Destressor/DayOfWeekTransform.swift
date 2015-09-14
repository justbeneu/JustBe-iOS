//
//  DayOfWeekTransform.swift
//  Repressor Destressor
//
//  Created by Gavin King on 4/15/15.
//  Copyright (c) 2015 Group 2. All rights reserved.
//

import ObjectMapper

public class DayOfWeekTransform: TransformType
{
    public typealias Object = DayOfWeek
    public typealias JSON = Int
    
    public init() {}
    
    public func transformFromJSON(value: AnyObject?) -> DayOfWeek?
    {
        if let int = value as? Int
        {
            return DayOfWeek(rawValue: int);
        }
        
        return nil
    }
    
    public func transformToJSON(value: DayOfWeek?) -> Int?
    {
        if let dayOfWeek = value
        {
            return dayOfWeek.rawValue
        }
        
        return nil
    }
}
