//
//  NSDate.swift
//  Spare
//
//  Created by Matt Quiros on 8/31/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

import Foundation

enum DateUnit {
    case Day, Week, Month, Year
}

extension NSDate {
    
    func firstMomentIn(unit: DateUnit) -> NSDate {
        return self.momentIn(unit, first: true)
    }
    
    func lastMomentIn(unit: DateUnit) -> NSDate {
        return self.momentIn(unit, first: false)
    }
    
    func momentIn(unit: DateUnit, first: Bool) -> NSDate {
        let calendar = NSCalendar.currentCalendar()
        var components: NSDateComponents?
        
        let commonUnits: NSCalendarUnit = .YearCalendarUnit | .MonthCalendarUnit | .HourCalendarUnit | .MinuteCalendarUnit | .SecondCalendarUnit
        
        switch unit {
        case .Day:
            components = calendar.components(commonUnits | .DayCalendarUnit, fromDate: self)
            
        case .Week:
            components = calendar.components(commonUnits | .YearForWeekOfYearCalendarUnit | .WeekCalendarUnit | .WeekdayCalendarUnit, fromDate: self)
            if first {
                components!.weekday = 1
            } else {
                components!.weekday = 7
            }
            
        case .Month:
            components = calendar.components(commonUnits | .DayCalendarUnit, fromDate: self)
            if first {
                components!.day = 1
            } else {
                // Get the number of days in the date's month.
                let days = calendar.rangeOfUnit(.DayCalendarUnit, inUnit: .MonthCalendarUnit, forDate: self)
                components!.day = days.length
            }
            
        default: // .Year
            components = calendar.components(commonUnits | .DayCalendarUnit, fromDate: self)
            if first {
                components!.month = 1
                components!.day = 1
            } else {
                components!.month = 12
                components!.day = 31
            }
        }
        
        if first {
            components!.hour = 0
            components!.minute = 0
            components!.second = 0
        } else {
            components!.hour = 23
            components!.minute = 59
            components!.second = 59
        }
        
        let moment = calendar.dateFromComponents(components)
        return moment
    }
    
}