//
//  DictionaryExtension.swift
//  Repressor Destressor
//
//  Created by Daniel Moreh on 4/14/15.
//  Copyright (c) 2015 Group 2. All rights reserved.
//

import UIKit

extension Dictionary {
    mutating func update(other:Dictionary) {
        for (key,value) in other {
            self.updateValue(value, forKey:key)
        }
    }
}
