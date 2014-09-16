//
//  CategoryPickerCellDelegate.swift
//  Spare
//
//  Created by Matt Quiros on 9/12/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

import Foundation

protocol CategoryPickerCellDelegate {
    
    func categoryPickerCellDidToggle(categoryPickerCell: CategoryPickerCell)
    
    /** 
        Called when a selection is made. A selection is only made when the category picker is collapsed.
    */
    func categoryPickerCell(categoryPickerCell: CategoryPickerCell, didSelectCategory category: SPRCategory)
    
}