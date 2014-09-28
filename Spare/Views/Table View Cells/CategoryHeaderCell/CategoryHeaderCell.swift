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
            if let summary = self.categorySummary {
                self.categoryLabel.text = summary.category.name
                self.totalLabel.text = summary.total.stringValue
                self.periodLabel.text = "Today (dummy"
                self.backgroundColor = Colors.allColors[summary.category.colorNumber.integerValue]
            }
            self.setNeedsLayout()
        }
    }
    
    class func heightForCategorySummary(categorySummary: CategorySummary) -> CGFloat {
        let cell = NSBundle.mainBundle().loadNibNamed(Classes.CategoryHeaderCell, owner: nil, options: nil).last as CategoryHeaderCell
        cell.categorySummary = categorySummary
        return cell.frame.size.height
    }
}