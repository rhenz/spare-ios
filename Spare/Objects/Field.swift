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
    var value: Any?
    
    init(_ name: String) {
        self.name = name
        self.value = nil
    }
    
    convenience init(_ name: String, value: Any?) {
        self.init(name)
        self.value = value
    }
    
}