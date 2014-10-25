//
//  PeriodViewController.swift
//  Spare
//
//  Created by Matt Quiros on 10/5/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

import Foundation

class PeriodViewController: UIViewController {
    
    private let kCellQuickDefault = "kCellQuickDefault"
    
    @IBOutlet private weak var tableView: UITableView!
    
    lazy var selectedIndexPath: NSIndexPath = {
        return self.periodManager.activePeriodIndexPath
        }()
    
    var dayPickerCell: DayPickerCell!
    
    var periodManager: PeriodManager {
        get {
            return AppState.sharedState.periodManager
        }
    }
    
}

// MARK: Main functions
extension PeriodViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerNib(QuickDefaultCell.nib(), forCellReuseIdentifier: kCellQuickDefault)
        
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
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            var defaultCell = UITableViewCell()
            
            switch indexPath.section {
            case 0: // Quick defaults section
                let cell = tableView.dequeueReusableCellWithIdentifier(kCellQuickDefault) as QuickDefaultCell
                cell.period = self.periodManager.quickDefaults[indexPath.row]
                
                if self.selectedIndexPath.row == indexPath.row {
                    cell.isChecked = true
                } else {
                    cell.isChecked = false
                }
                
                return cell
            case 1:
                switch indexPath.row {
                case 0:
                    return self.dayPickerCell
                default:
                    return defaultCell
                }
            default:
                return defaultCell
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
    
    func tableView(tableView: UITableView,
        didSelectRowAtIndexPath indexPath: NSIndexPath) {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            
            if self.selectedIndexPath == indexPath {
                // Do nothing if the current selection and the new selection are the same.
                return
            }
            
            if indexPath.section == 0 {
                let oldSelectedIndexPath = self.selectedIndexPath
                self.selectedIndexPath = indexPath
                
                self.tableView.reloadRowsAtIndexPaths([oldSelectedIndexPath, indexPath], withRowAnimation: .Automatic)
            }
    }
    
}

// MARK: DayPickerCellDelegate
extension PeriodViewController: DayPickerCellDelegate {
    
    func dayPickerCellDidToggle(dayPickerCell: DayPickerCell) {
        if dayPickerCell.isExpanded {
            self.selectedIndexPath = NSIndexPath(forRow: 0, inSection: 1)
        }
        
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    
    func dayPickerCellGotSelected(dayPickerCell: DayPickerCell) {
        // TO FIX: reload only the index paths of the old and new selection
        self.tableView.reloadData()
    }
    
}