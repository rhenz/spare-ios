//
//  NewCategoryCell.swift
//  Spare
//
//  Created by Matt Quiros on 28/08/2014.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

import Foundation

class NewCategoryCell: UICollectionViewCell {
    
    @IBOutlet weak var plusLabel: UILabel!
    @IBOutlet weak var plusLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var plusLabelWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var newCategoryLabel: UILabel!
    @IBOutlet weak var newCategoryLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var newCategoryLabelWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var verticalSpacingConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        // Set up the plus label.
        plusLabel.text = Icons.NewCategory.toRaw()
        plusLabel.font = UIFont(name: kIconFontName, size: {
            let idiom = UIDevice.currentDevice().userInterfaceIdiom
            switch idiom {
            case .Phone:
                return 30
            default: // Pad
                return 50
            }
            }())
        
        // Set up the New Category label.
        newCategoryLabel.font = UIFont.systemFontOfSize({
            let idiom = UIDevice.currentDevice().userInterfaceIdiom
            switch idiom {
            case .Phone:
                return 12
            default: // Pad
                return 18
            }
            }())
    }
    
    override func updateConstraints() {
        let plusLabelSize = self.plusLabel.intrinsicContentSize()
        self.plusLabelHeightConstraint.constant = plusLabelSize.height
        self.plusLabelWidthConstraint.constant = plusLabelSize.width
        
        let newCategoryLabelSize = self.newCategoryLabel.intrinsicContentSize()
        self.newCategoryLabelHeightConstraint.constant = newCategoryLabelSize.height
        self.newCategoryLabelWidthConstraint.constant = newCategoryLabelSize.width
        
        self.verticalSpacingConstraint.constant = {
            let idiom = UIDevice.currentDevice().userInterfaceIdiom
            switch idiom {
            case .Phone:
                return 10
            default: // .Pad
                return 30
            }
            }()
        
        super.updateConstraints()
    }
}