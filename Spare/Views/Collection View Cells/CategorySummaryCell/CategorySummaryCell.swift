//
//  CategorySummaryCell.swift
//  Spare
//
//  Created by Matt Quiros on 10/26/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

import UIKit

class CategorySummaryCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    weak var summary: CategorySummary? {
        didSet {
            if let summary = self.summary {
                self.categoryLabel.text = summary.category.name
                self.totalLabel.text = summary.total.currencyString()
                self.backgroundColor = Colors.allColors[summary.category.colorNumber.integerValue]
                self.setNeedsLayout()
            }
        }
    }
    
    override class func className() -> String? {
        return "CategorySummaryCell"
    }
    
    override func layoutSubviews() {
        // Fixes a bug in iOS 7 where it doesn't respect size classes.
        self.contentView.frame = self.bounds
        super.layoutSubviews()
        
//        self.categoryLabel.numberOfLines = {
//            switch UIDevice.currentDevice().userInterfaceIdiom {
//            case .Pad:
//                return 3
//            case .Phone:
//                // For iPhone 5S and below.
//                if UIScreen.mainScreen().bounds.size.width == 320 {
//                    return 2
//                } else {
//                    return 3
//                }
//            default:
//                return 1
//            }
//            }()
        
        self.categoryLabel.font = UIFont(name: self.categoryLabel.font.fontName,
            size: {
                let fontSize = self.bounds.height / 8
                return fontSize
                }())
        
        self.totalLabel.font = UIFont(name: self.totalLabel.font.fontName,
            size: {
                let fontSize = self.bounds.height / 10
                return fontSize
        }())
    }
    
}
