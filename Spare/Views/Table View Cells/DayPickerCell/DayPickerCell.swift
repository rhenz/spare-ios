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
    
    var isExpanded: Bool = false
    var delegate: DayPickerCellDelegate?
    
    weak var period: Period? {
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
    
    var checked: Bool = false {
        didSet {
            self.checkLabel.hidden = self.checked == false
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
        self.checkLabel.hidden = self.checked == false
    }
    
    @IBAction func changeButtonTapped(sender: AnyObject) {
        // When the Change button is tapped, the cell is automatically selected.
        self.checked = true
        self.tappableArea.backgroundColor = Colors.tableViewCellGraySelectedColor
        
        // Expand or collapse depending on the current state.
        if self.isExpanded {
            self.collapse()
        } else {
            self.expand()
        }
    }
    func collapse() {
        // Do nothing if it's already collapsed.
        if self.isExpanded == false {
            return
        }
        
        self.isExpanded = false
        
        self.changeButton.setTitle("Change", forState: .Normal)
        
        self.delegate?.dayPickerCellDidToggle(self)
    }
    
    func expand() {
        // Do nothing if it's already expanded.
        if self.isExpanded {
            return
        }
        
        self.isExpanded = true
        
        self.changeButton.setTitle("Done", forState: .Normal)
        
        if self.period == nil {
            self.period = Period.today()
        }
        
        self.delegate?.dayPickerCellDidToggle(self)
    }

}
