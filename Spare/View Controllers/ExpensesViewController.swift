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
    var newExpensePopoverController: UIPopoverController!
    
    lazy var newExpenseBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: Selector("newExpenseButtonTapped:"))
        return barButtonItem
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItems = [self.newExpenseBarButtonItem]
        
        // Register table view cells.
        tableView.registerNib(UINib(nibName: Classes.CategoryHeaderCell, bundle: NSBundle.mainBundle()), forCellReuseIdentifier: kCategoryHeaderCell)
        
        // Register for new expense notifications.
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: Selector("notifyWithNotification:"), name: Notifications.NewExpense, object: nil)
    }
    
    func newExpenseButtonTapped(sender: UIBarButtonItem) {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            self.performSegueWithIdentifier(Segues.PresentNewExpense, sender: self)
        } else {
            let navigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(StoryboardIDs.NewExpenseNavigationController) as UINavigationController
            self.newExpensePopoverController = UIPopoverController(contentViewController: navigationController)
            let originatingView = sender.valueForKey("view") as UIView
            self.newExpensePopoverController.presentPopoverFromRect(originatingView.frame, inView: self.view, permittedArrowDirections: .Any, animated: true)
        }
    }
    
    func notifyWithNotification(notification: NSNotification) {
        if notification.name == Notifications.NewExpense {
            let expense = notification.object as SPRExpense
            if self.categorySummary.category.displayOrder == expense.category.displayOrder {
                NSLog("New expense!")
            }
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
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

// MARK: Table view delegate
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