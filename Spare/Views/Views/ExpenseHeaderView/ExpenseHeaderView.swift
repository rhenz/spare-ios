//
//  ExpenseHeaderView.swift
//  Spare
//
//  Created by Matt Quiros on 10/4/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

import UIKit

class ExpenseHeaderView: UIView {

    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var totalLabel: UILabel!
    
    weak var expenseHeader: ExpenseHeader? {
        didSet {
            if let headerInfo = self.expenseHeader {
                self.dateLabel.text = headerInfo.date.expenseHeaderString()
                self.totalLabel.text = headerInfo.total.currencyString()
                self.setNeedsLayout()
            }
        }
    }
    
    override class func className() -> String? {
        return Classes.ExpenseHeaderView
    }
    
}
