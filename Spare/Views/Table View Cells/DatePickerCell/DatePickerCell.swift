//
//  DatePickerCell.swift
//  Spare
//
//  Created by Matt Quiros on 9/17/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

import Foundation

class DatePickerCell: UITableViewCell {
    
    // MARK: Constants
    let defaultHeight = CGFloat(44)
    let expandedHeight = CGFloat(206)
    
    // MARK: IBOutlets
    @IBOutlet weak var tappableArea: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    // MARK: Stored properties
    var isExpanded = false
    var delegate: DatePickerCellDelegate?
    var selectedDate = NSDate.simplifiedDate()
    
    // MARK: Computed properties
    var height: CGFloat {
        return isExpanded ? expandedHeight : defaultHeight
    }
    
    // MARK: Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Add a tap gesture recognizer to the tappable area to toggle expansion.
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("tappableAreaTapped"))
        self.tappableArea.addGestureRecognizer(tapGestureRecognizer)
        
        // Add an action for when the date selection changes.
        self.datePicker.addTarget(self, action: Selector("dateSelectionChanged"), forControlEvents: .ValueChanged)
        
        // Set the initial text for the text field.
        self.textField.text = self.selectedDate.textInForm()
        
        self.clipsToBounds = true
    }
    
    func tappableAreaTapped() {
        if self.isExpanded {
            self.collapse()
        } else {
            self.expand()
        }
    }
    
    func expand() {
        if self.isExpanded == true {
            return
        }
        
        self.isExpanded = true
        self.tappableArea.backgroundColor = Colors.tableViewCellGraySelectedColor
        self.delegate?.datePickerCellDidToggle(self)
    }
    
    func collapse() {
        if self.isExpanded == false {
            return
        }
        
        self.isExpanded = false
        self.tappableArea.backgroundColor = UIColor.clearColor()
        self.delegate?.datePickerCellDidToggle(self)
        
        // Consider that a selection has been made.
        self.delegate?.datePickerCell(self, didSelectDate: self.selectedDate)
    }
    
    func dateSelectionChanged() {
        self.selectedDate = self.datePicker.date
        self.textField.text = self.selectedDate.textInForm()
    }
}