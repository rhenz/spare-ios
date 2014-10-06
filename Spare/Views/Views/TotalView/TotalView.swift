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
                self.periodLabel.text = "Today (dummy)"
                self.setNeedsLayout()
            }
        }
    }
    
    override class func className() -> String? {
        return "TotalView"
    }
    
//    func printFrames() {
//        NSLog("\nself: \(self.frame)\ntotalLabel: \(self.totalLabel.text), \(self.totalLabel.frame)\nperiodLabel: \(self.periodLabel.text), \(self.periodLabel.frame)")
//    }
    
//    override func updateConstraints() {
//        let totalLabelWidth = self.totalLabel.intrinsicContentSize().width
//        let periodLabelWidth = self.periodLabel.intrinsicContentSize().width
//        var greaterWidth: CGFloat = fmax(totalLabelWidth, periodLabelWidth)
//        self.frame.size.width = greaterWidth
//        
//        super.updateConstraints()
//    }
//    
//    override func layoutSubviews() {
//        super.layoutSubviews()
////        self.totalLabel.sizeToFit()
////        self.periodLabel.sizeToFit()
////        let totalLabelWidth = self.totalLabel.frame.width
////        let periodLabelWidth = self.periodLabel.frame.width
////        var greaterWidth: CGFloat = fmax(totalLabelWidth, periodLabelWidth)
////        self.frame.size.width = greaterWidth
////        super.layoutSubviews()
////        NSLog("IN LAYOUTSUBVIEWS")
//        self.printFrames()
//    }
    
}