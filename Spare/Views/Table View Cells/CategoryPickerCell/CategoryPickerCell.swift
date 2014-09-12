//
//  CategoryPickerCell.swift
//  Spare
//
//  Created by Matt Quiros on 9/12/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

import Foundation

class CategoryPickerCell: UITableViewCell {
    
    // Public constants
    let defaultHeight = CGFloat(44)
    let expandedHeight = CGFloat(206)
    
    @IBOutlet weak var tappableArea: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    lazy var categories: [SPRCategory] = {
        return SPRCategory.allCategories() as [SPRCategory]
    }()
    
    var isExpanded = false
    
    var height: CGFloat {
        return isExpanded ? expandedHeight : defaultHeight
    }
    
    var delegate: CategoryPickerCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Add a tap gesture recognizer to the tappable area to toggle expansion.
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("tappableAreaTapped"))
        self.tappableArea.addGestureRecognizer(tapGestureRecognizer)
        
        // Set the picker view's data source and delegates.
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        
        self.clipsToBounds = true
    }
    
    func tappableAreaTapped() {
        // Just reverse the expanded mode.
        self.isExpanded = !self.isExpanded
        
        // Highlight or unhighlight the tappable area depending on the expansion mode.
        self.tappableArea.backgroundColor = isExpanded ? Colors.tableViewCellGraySelectedColor : UIColor.clearColor()
        
        self.delegate?.categoryPickerCellDidToggleExpandMode(self)
    }
    
}

// MARK: Picker view data source

extension CategoryPickerCell: UIPickerViewDataSource {
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView,
        numberOfRowsInComponent component: Int) -> Int {
            return self.categories.count
    }
    
}

// MARK: Picker view delegate

extension CategoryPickerCell: UIPickerViewDelegate {
    
    func pickerView(pickerView: UIPickerView,
        titleForRow row: Int,
        forComponent component: Int) -> String! {
            let category = self.categories[row]
            return category.name
    }
    
    func pickerView(pickerView: UIPickerView,
        didSelectRow row: Int,
        inComponent component: Int) {
            
    }
    
}