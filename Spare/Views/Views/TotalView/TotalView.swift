//
//  TotalView.swift
//  Spare
//
//  Created by Matt Quiros on 10/6/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

import Foundation

class TotalView: UIView {
    
    @IBOutlet private weak var totalLabel: UILabel!
    @IBOutlet private weak var periodLabel: UILabel!
    
    var delegate: TotalViewDelegate?
    
    var total: NSDecimalNumber? {
        didSet {
            if let total = self.total {
                self.totalLabel.text = total.currencyString()
                self.setNeedsLayout()
            }
        }
    }
    
    var period: Period? {
        didSet {
            if let period = self.period {
                self.periodLabel.text = period.quickDefaultDescription
                self.setNeedsLayout()
            }
        }
    }
    
}

// MARK: Functions
extension TotalView {
    
    override class func className() -> String? {
        return "TotalView"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Add a tap gesture recognizer.
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("totalViewTapped"))
        self.addGestureRecognizer(gestureRecognizer)
    }
    
    func totalViewTapped() {
        if let theDelegate = delegate {
            theDelegate.totalViewDidTap(self)
        }
    }
    
}