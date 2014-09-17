//
//  DatePickerCellDelegate.swift
//  Spare
//
//  Created by Matt Quiros on 9/17/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

import Foundation

protocol DatePickerCellDelegate {
    
    func datePickerCellDidToggle(datePickerCell: DatePickerCell)
    
    /**
    Called when a selection is made. A selection is only made when the date picker is collapsed.
    */
    func datePickerCell(datePickerCell: DatePickerCell, didSelectDate date: NSDate)
    
}