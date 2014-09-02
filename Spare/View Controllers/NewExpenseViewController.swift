//
//  NewExpenseViewController.swift
//  Spare
//
//  Created by Matt Quiros on 2/09/2014.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

import Foundation

let kCellIdentifiers = ["kDescriptionCell", "kAmountCell", "kCategoryCell", "kDateSpentCell"]

class NewExpenseViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    // MARK: View controller life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("hideKeyboard"))
        gestureRecognizer.cancelsTouchesInView = false
        self.tableView.addGestureRecognizer(gestureRecognizer)
    }

    // MARK: Target actions

    @IBAction func cancelButtonTapped(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func doneButtonTapped(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    func hideKeyboard() {
        self.view.endEditing(true)
    }
    
}

extension NewExpenseViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    func tableView(tableView: UITableView!,
        cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
            let cell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifiers[indexPath.row]) as UITableViewCell
            return cell
    }
    
}

extension NewExpenseViewController: UITableViewDelegate {

}