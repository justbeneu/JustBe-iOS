//
//  StringExtension.swift
//  Repressor Destressor
//
//  Created by Gavin King on 4/7/15.
//  Copyright (c) 2015 Group 2. All rights reserved.
//

import Foundation

extension String
{
    func trim() -> String
    {
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }
}