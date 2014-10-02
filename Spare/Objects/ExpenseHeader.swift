//
//  ExpenseHeader.swift
//  Spare
//
//  Created by Matt Quiros on 10/2/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

import Foundation

class ExpenseHeader {
    
    var date: NSDate
    var total: NSNumber
    
    init(date: NSDate, total: NSNumber) {
        self.date = date
        self.total = total
    }
    
}