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
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    
    var isExpanded = false
    var delegate: CategoryPickerCellDelegate?
    var selectedCategory = AppState.sharedState.preselectedCategory
    
    lazy var categories: [SPRCategory] = {
        return SPRCategory.allCategories() as [SPRCategory]
    }()
    
    var height: CGFloat {
        return isExpanded ? expandedHeight : defaultHeight
    }
    
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
        // Reverse the expanded mode and inform the delegate.
        self.isExpanded = !self.isExpanded
        self.delegate?.categoryPickerCellDidToggle(self)
        
        // If the cell has been collapsed, consider that a selection has been made.
        if self.isExpanded == false {
            self.delegate?.categoryPickerCell(self, didSelectCategory: self.selectedCategory!)
        }
        
        // Highlight or unhighlight the tappable area depending on the expansion mode.
        self.tappableArea.backgroundColor = isExpanded ? Colors.tableViewCellGraySelectedColor : UIColor.clearColor()
        
        // If there isn't an initial selected category, get all categories and select the one in the middle.
        if self.selectedCategory == nil {
            self.selectedCategory = self.categories[self.categories.count / 2]
            
            // Show it in the picker view and text field.
            self.pickerView.selectRow(self.selectedCategory!.displayOrder, inComponent: 0, animated: false)
            self.textField.text = self.selectedCategory!.name
        }
    }
    
    func collapse() {
        if self.isExpanded == false {
            return
        }
        
        self.isExpanded = false
        self.tappableArea.backgroundColor = UIColor.clearColor()
        self.delegate?.categoryPickerCellDidToggle(self)
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
            self.selectedCategory = self.categories[row]
            self.textField.text = self.selectedCategory!.name
    }
    
}