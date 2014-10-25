//
//  Period.swift
//  Spare
//
//  Created by Matt Quiros on 8/31/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

import Foundation

class Period {
    
    var startDate: NSDate
    var endDate: NSDate
    var mainUnit: DateUnit
    
    var quickDefaultDescription: String {
        get {
            switch self.mainUnit {
            case .Day:
                return "Today"
            case .Week:
                return "This week"
            case .Month:
                return "This month"
            case .Year:
                return "This year"
            default:
                return ""
            }
        }
    }
    
    init(startDate: NSDate, endDate: NSDate, mainUnit: DateUnit) {
        self.startDate = startDate
        self.endDate = endDate
        self.mainUnit = mainUnit
    }
    
    convenience init(day date: NSDate) {
        let startDate = date.firstMomentIn(.Day)
        let endDate = date.lastMomentIn(.Day)
        self.init(startDate: startDate, endDate: endDate, mainUnit: .Day)
    }
    
    class func today() -> Period {
        let currentDate = NSDate()
        let period = Period(day: currentDate)
        return period
    }
    
}