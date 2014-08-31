//
//  CategoryHeaderCell.swift
//  Spare
//
//  Created by Matt Quiros on 8/31/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

import Foundation

class CategoryHeaderCell: UITableViewCell {
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var periodLabel: UILabel!
    
    var categorySummary: CategorySummary? {
        didSet {
            self.categoryLabel.text = categorySummary!.category.name
            self.totalLabel.text = categorySummary!.totalForPeriod(AppState.sharedState.activePeriod).stringValue
            self.periodLabel.text = "Today (dummy)"
            
            self.setNeedsLayout()
        }
    }
}