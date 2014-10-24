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
    
    init(startDate: NSDate, endDate: NSDate) {
        self.startDate = startDate
        self.endDate = endDate
    }
    
    convenience init(day date: NSDate) {
        let startDate = date.firstMomentIn(.Day)
        let endDate = date.lastMomentIn(.Day)
        self.init(startDate: startDate, endDate: endDate)
    }
    
    class func today() -> Period {
        let currentDate = NSDate()
        let period = Period(startDate: currentDate.firstMomentIn(.Day), endDate: currentDate.lastMomentIn(.Day))
        return period
    }
    
}