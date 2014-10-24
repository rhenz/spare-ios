//
//  DayPickerCellDelegate.swift
//  Spare
//
//  Created by Matt Quiros on 10/24/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

import Foundation

protocol DayPickerCellDelegate {
    
    func dayPickerCellGotSelected(dayPickerCell: DayPickerCell)
    func dayPickerCellDidToggle(dayPickerCell: DayPickerCell)
    
}