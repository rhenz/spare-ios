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
    
    
    
}

// MARK: Target actions
extension PeriodViewController {
    
    @IBAction func cancelButtonTapped(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func doneButtonTapped(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}