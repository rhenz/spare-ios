//
//  DayPickerCell.swift
//  Spare
//
//  Created by Matt Quiros on 10/23/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

import UIKit

class DayPickerCell: UITableViewCell {

    @IBOutlet weak var tappableArea: UIView!
    @IBOutlet weak var checkLabel: UILabel!
    @IBOutlet weak var periodLabel: UILabel!
    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var delegate: DayPickerCellDelegate?
    
    var period: Period? {
        didSet {
            self.periodLabel.text = {
                if let thePeriod = self.period {
                    let formatter = NSDateFormatter()
                    formatter.dateStyle = NSDateFormatterStyle.MediumStyle
                    let dateString = formatter.stringFromDate(thePeriod.startDate)
                    return dateString
                }
                return nil
            }()
            
            self.setNeedsLayout()
        }
    }
    
    var isExpanded: Bool = false {
        didSet {
            if self.isExpanded {
                self.changeButton.setTitle("Done", forState: .Normal)
            } else {
                self.changeButton.setTitle("Change", forState: .Normal)
            }
            self.setNeedsLayout()
        }
    }
    
    var isChecked: Bool = false {
        didSet {
            if self.isChecked {
                self.delegate?.dayPickerCellGotSelected(self)
            }
            
            self.checkLabel.hidden = self.isChecked == false
            self.setNeedsLayout()
        }
    }
    
    var height: CGFloat {
        get {
            if self.isExpanded {
                return 206
            }
            return UITableViewAutomaticDimension
        }
    }
    
    override class func className() -> String {
        return "DayPickerCell"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.checkLabel.hidden = self.isChecked == false
        
        // Add a gesture recognizer to the tappable area.
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("tappableAreaTapped"))
        self.tappableArea.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @IBAction func changeButtonTapped(sender: AnyObject) {
        // Expanding the cell always selects the cell.
        self.isChecked = true
        self.tappableArea.backgroundColor = Colors.tableViewCellGraySelectedColor
        
        self.isExpanded = !self.isExpanded
        self.delegate?.dayPickerCellDidToggle(self)
    }
    
    func tappableAreaTapped() {
        // Do nothing if the cell is expanded.
        if self.isExpanded {
            return
        }
        
        self.isChecked = true
        self.tappableArea.backgroundColor = Colors.tableViewCellGraySelectedColor
        
        // Selecting the cell does not always expand the cell. Expand only when there
        // are no selected periods yet.
        if self.period == nil {
            self.isExpanded = true
            self.period = Period(day: self.datePicker.date)
            self.delegate?.dayPickerCellDidToggle(self)
        }
    }
    
}
