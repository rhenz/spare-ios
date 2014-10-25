//
//  PeriodList.swift
//  Spare
//
//  Created by Matt Quiros on 10/25/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

import Foundation

class PeriodList {
    
    class var sharedList: PeriodList {
    struct Singleton {
        static let instance = PeriodList()
        }
        return Singleton.instance
    }
    
    var quickDefaults = [Period.today(),
        Period.thisWeek(),
        Period.thisMonth(),
        Period.thisYear()]
    
    var activeIndexPath = NSIndexPath(forRow: 0, inSection: 0)
    
    var activePeriod: Period? {
        get {
            switch self.activeIndexPath.section {
            case 0:
                return self.quickDefaults[self.activeIndexPath.row]
            default:
                return nil
            }
        }
    }
    
    func periodAtIndexPath(indexPath: NSIndexPath) -> Period? {
        switch indexPath.section {
        case 0:
            return self.quickDefaults[indexPath.row]
        default:
            return nil
        }
    }
    
}