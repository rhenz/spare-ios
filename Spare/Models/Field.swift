//
//  Field.swift
//  Spare
//
//  Created by Matt Quiros on 4/09/2014.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

import Foundation

class Field {
    
    var name: String
    var value: Any!
    
    init(name: String) {
        self.name = name
    }
    
    convenience init(name: String, value: Any!) {
        self.init(name: name)
        self.value = value
    }
    
}