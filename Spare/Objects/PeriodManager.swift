//
//  PeriodManager.swift
//  Spare
//
//  Created by Matt Quiros on 10/25/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

import Foundation

class PeriodManager {
    
    lazy var quickDefaults: [Period] = {
        let periods = [Period.today()]
        return periods
    }()
    
    var activePeriod: Period? {
        get {
            switch self.activePeriodIndexPath.section {
            case 0:
                return self.quickDefaults[self.activePeriodIndexPath.row]
            default:
                return nil
            }
        }
    }
    
    var activePeriodIndexPath: NSIndexPath = NSIndexPath(forRow: 0, inSection: 0)
    
}