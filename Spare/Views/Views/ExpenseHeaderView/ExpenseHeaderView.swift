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
    
    var expenseHeader: ExpenseHeader? {
        didSet {
            if let headerInfo = self.expenseHeader {
                self.dateLabel.text = headerInfo.date.expenseHeaderString()
                self.totalLabel.text = headerInfo.total.currencyString()
                self.setNeedsLayout()
            }
        }
    }
    
    class func instantiateFromNib(#owner: AnyObject) -> ExpenseHeaderView {
        let instance = NSBundle.mainBundle().loadNibNamed(Classes.ExpenseHeaderView, owner: owner, options: nil).first as ExpenseHeaderView
        return instance
    }
    
    override func layoutSubviews() {
        // Size the view to occupy the full width of its screen.
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, UIScreen.currentWidth(), self.frame.size.height)
        super.layoutSubviews()
    }

}
