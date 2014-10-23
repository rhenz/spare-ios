//
//  DayPickerCell.swift
//  Spare
//
//  Created by Matt Quiros on 10/23/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

import UIKit

class DayPickerCell: UITableViewCell {

    @IBOutlet weak var tappableArea: UIView!
    @IBOutlet weak var periodLabel: UILabel!
    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    weak var period: Period?
    
    

}
