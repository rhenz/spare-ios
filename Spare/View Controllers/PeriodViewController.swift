//
//  PeriodViewController.swift
//  Spare
//
//  Created by Matt Quiros on 10/5/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

import Foundation

class PeriodViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    var selectedIndexPath: NSIndexPath?
    
    var dayPickerCell: DayPickerCell!
    
}

// MARK: Main functions
extension PeriodViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initializeCustomCells()
    }
    
    @IBAction func cancelButtonTapped(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func doneButtonTapped(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func initializeCustomCells() {
        self.dayPickerCell = DayPickerCell.instantiateFromNib(owner: self) as DayPickerCell
        self.dayPickerCell.delegate = self
    }
}

// MARK: UITableViewDataSource
extension PeriodViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cell = UITableViewCell()
            
            switch indexPath.section {
            case 0:
                switch indexPath.row {
                case 0:
                    return self.dayPickerCell
                default:
                    return cell
                }
            default:
                return cell
            }
    }
    
}

// MARK: UITableViewDelegate
extension PeriodViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView,
        heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
            let cell = self.tableView(tableView, cellForRowAtIndexPath: indexPath)
            if let theCell = cell as? DayPickerCell {
                return theCell.height
            }
            return UITableViewAutomaticDimension
    }
    
}

// MARK: DayPickerCellDelegate
extension PeriodViewController: DayPickerCellDelegate {
    
    func dayPickerCellDidToggle(dayPickerCell: DayPickerCell) {
        if dayPickerCell.isExpanded {
            self.selectedIndexPath = NSIndexPath(forRow: 0, inSection: 0)
        }
        
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    
}