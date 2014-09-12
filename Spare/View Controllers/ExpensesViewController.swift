//
//  ExpensesViewController.swift
//  Spare
//
//  Created by Matt Quiros on 29/08/2014.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

import Foundation

// Table view sections
private let kSectionCategoryHeader = 0

// Cell identifiers
private let kCategoryHeaderCell = "kCategoryHeaderCell"

class ExpensesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var categorySummary: CategorySummary!
    var expenses = [SPRExpense]()
    
    lazy var newExpenseBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: Selector("newExpenseButtonTapped"))
        return barButtonItem
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItems = [self.newExpenseBarButtonItem]
        
        // Register table view cells.
        tableView.registerNib(UINib(nibName: Classes.CategoryHeaderCell, bundle: NSBundle.mainBundle()), forCellReuseIdentifier: kCategoryHeaderCell)
    }
    
    func newExpenseButtonTapped() {
        self.performSegueWithIdentifier("presentNewExpense", sender: self)
    }
    
}

// MARK: Table view data source
extension ExpensesViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
            switch section {
            case kSectionCategoryHeader:
                return 1
            default:
                return expenses.count
            }
    }
    
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            switch indexPath.section {
            case kSectionCategoryHeader:
                let cell = tableView.dequeueReusableCellWithIdentifier(kCategoryHeaderCell) as CategoryHeaderCell
                cell.categorySummary = self.categorySummary
                return cell
            default:
                return UITableViewCell()
            }
    }
    
}

extension ExpensesViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView,
        heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
            switch indexPath.section {
            case kSectionCategoryHeader:
                return CategoryHeaderCell.heightForCategorySummary(self.categorySummary)
            default:
                return UITableViewAutomaticDimension
            }
    }
    
}