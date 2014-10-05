//
//  ExpenseCell.swift
//  Spare
//
//  Created by Matt Quiros on 10/2/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

import Foundation

class ExpenseCell: UITableViewCell {
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var amountLabel: UILabel!
    
    weak var expense: SPRExpense? {
        didSet {
            if let expense = self.expense {
                self.nameLabel.text = expense.name
                self.amountLabel.text = expense.amount.currencyString()
                self.setNeedsLayout()
            }
        }
    }
}