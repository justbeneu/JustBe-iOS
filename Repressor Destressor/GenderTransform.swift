
//
//  GenderTransform.swift
//  Repressor Destressor
//
//  Created by Gavin King on 4/15/15.
//  Copyright (c) 2015 Group 2. All rights reserved.
//

import ObjectMapper

public class GenderTransform: TransformType
{
    public typealias Object = Gender
    public typealias JSON = Int
    
    public init() {}
    
    public func transformFromJSON(value: AnyObject?) -> Gender?
    {
        if let int = value as? Int
        {
            return Gender(rawValue: int);
        }
        
        return nil
    }
    
    public func transformToJSON(value: Gender?) -> Int?
    {
        if let gender = value
        {
            return gender.rawValue
        }
        
        return nil
    }
}