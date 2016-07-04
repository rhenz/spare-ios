//
//  Periodization.swift
//  Spare
//
//  Created by Matt Quiros on 14/06/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import Foundation

enum Periodization: Int {
    
    case Day = 0, Week, Month, Year
    
    var descriptiveText: String {
        switch self {
        case .Day:
            return "By Day"
        case .Week:
            return "By Week"
        case .Month:
            return "By Month"
        case .Year:
            return "By Year"
        }
    }
    
}