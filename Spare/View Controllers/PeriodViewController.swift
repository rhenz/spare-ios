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

// MARK: Main functions
extension PeriodViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerNib(<#nib: UINib#>, forCellReuseIdentifier: <#String#>)
    }
    
    @IBAction func cancelButtonTapped(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func doneButtonTapped(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
            
    }
    
}