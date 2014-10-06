//
//  QuickDefaultCell.swift
//  Spare
//
//  Created by Matt Quiros on 10/6/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

import Foundation

class QuickDefaultCell: UITableViewCell {
    
    @IBOutlet private weak var checkLabel: UILabel!
    @IBOutlet private weak var periodLabel: UILabel!
    
    weak var period: Period? {
        didSet {
            if let period = self.period {
//                self.periodLabel.text = period.
            }
        }
    }
    
}