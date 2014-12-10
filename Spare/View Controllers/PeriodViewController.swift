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
    
    var delegate: PeriodViewControllerDelegate?
    
    lazy var selectedIndexPath: NSIndexPath = {
        return PeriodList.sharedList.activeIndexPath
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerNib(QuickDefaultCell.nib(), forCellReuseIdentifier: kCellQuickDefault)
    }
    
    @IBAction func cancelButtonTapped(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func doneButtonTapped(sender: UIBarButtonItem) {
        // Only do something if the active period has been changed.
        if self.selectedIndexPath != PeriodList.sharedList.activeIndexPath {
            // Set the new active period.
            PeriodList.sharedList.activeIndexPath = self.selectedIndexPath
            
            // Inform the delegate that the active period has been changed.
            self.delegate?.periodViewControllerDidUpdate(self)
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}

// MARK: UITableViewDataSource
extension PeriodViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
            return PeriodList.sharedList.quickDefaults.count
    }
    
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier(kCellQuickDefault) as QuickDefaultCell
            cell.period = PeriodList.sharedList.quickDefaults[indexPath.row]
            cell.isChecked = indexPath == self.selectedIndexPath
            
            return cell
    }
    
}

// MARK: UITableViewDelegate
extension PeriodViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView,
        didSelectRowAtIndexPath indexPath: NSIndexPath) {
            let oldSelection = self.selectedIndexPath
            
            // Refresh the new and old selections only if they're not the same.
            if oldSelection != indexPath {
                self.selectedIndexPath = indexPath
                self.tableView.reloadRowsAtIndexPaths([oldSelection, indexPath], withRowAnimation: .None)
                
                // Select the row again to keep the deselect animation smooth.
                self.tableView.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: UITableViewScrollPosition.None)
            }
            
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}
