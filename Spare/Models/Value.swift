//
//  Value.swift
//  Spare
//
//  Created by Matt Quiros on 9/17/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

import Foundation

enum Value {
    
    case Text(String!)
    case Category(SPRCategory!)
    case Date(NSDate!)
    
    func isMissing() -> Bool {
        switch self {
        case let .Text(text): return text == nil
        case let .Category(category): return category == nil
        case let .Date(date): return date == nil
        }
    }
    
}