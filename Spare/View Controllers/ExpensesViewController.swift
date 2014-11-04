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
private let kCellCategoryHeader = "kCellCategoryHeader"
private let kCellExpense = "kCellExpense"

// MARK: Main class
class ExpensesViewController: UIViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Stored properties
    
    var categorySummary: CategorySummary?
    var newExpensePopoverController: UIPopoverController!
    var expenseHeaders: [ExpenseHeader]!
    var expenses: Array<Array<SPRExpense>>!
    
    // MARK: Constants
    
    let recognizedNotifications = [Notifications.ExpenseAdded,
        Notifications.CategoryEdited,
        Notifications.CategoryDeleted]
    
    // MARK: Lazy properties
    
    lazy var newExpenseBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: Selector("newExpenseButtonTapped:"))
        return barButtonItem
        }()
    
    lazy var fetcher : NSFetchedResultsController? = {
        if let summary = self.categorySummary {
            let context = SPRManagedDocument.sharedDocument().managedObjectContext
            
            let fetchRequest = NSFetchRequest()
            let entityDescription = NSEntityDescription.entityForName(Classes.Expense, inManagedObjectContext: context)
            fetchRequest.entity = entityDescription
            
            if let period = PeriodList.sharedList.activePeriod {
                let predicate = NSPredicate(format: "category == %@ AND dateSpent >= %@ AND dateSpent <= %@", summary.category, period.startDate, period.endDate)
                fetchRequest.predicate = predicate
            }
            
            // First, sort the expenses by most recent dateSpent so that sections are also sorted by most recent.
            // Next, sort the expenses according to displayOrder.
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "dateSpent", ascending: false),
                NSSortDescriptor(key:"displayOrder", ascending: true)]
            
            let fetcher = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: "dateSpentAsSectionTitle", cacheName: nil)
            return fetcher
        }
        return nil
    }()
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}

// MARK: Main functions
extension ExpensesViewController {
    
    func performFetch() {
        var error: NSError?
        if let fetcher = self.fetcher {
            // Perform the fetch.
            let success = fetcher.performFetch(&error)
            if success == false {
                NSLog("\(error)")
            }
            
            // Restart the header and expense arrays.
            self.expenseHeaders = [ExpenseHeader]()
            self.expenses = Array<Array<SPRExpense>>()
            
            if let sections = fetcher.sections {
                // Get the sections.
                for i in 0..<sections.count {
                    // Extract the dateSpent from the section string.
                    let sectionInfo = sections[i] as NSFetchedResultsSectionInfo
                    let timeInterval = (sectionInfo.name! as NSString).doubleValue
                    let dateSpent = NSDate(timeIntervalSince1970: timeInterval)
                    
                    // Get the expenses.
                    var expenses = [SPRExpense]()
                    for j in 0..<sectionInfo.numberOfObjects {
                        let indexPath = NSIndexPath(forRow: j, inSection: i)
                        let expense = fetcher.objectAtIndexPath(indexPath) as SPRExpense
                        expenses.append(expense)
                    }
                    self.expenses.append(expenses)
                    
                    // Compute for the total in the section
                    let total = (expenses as AnyObject).valueForKeyPath("@sum.amount") as NSNumber
                    
                    // Create the header object and add it to the array.
                    let header = ExpenseHeader(date: dateSpent, total: total)
                    self.expenseHeaders.append(header)
                }
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case Segues.PresentNewExpense:
                let navigationController = segue.destinationViewController as UINavigationController
                let newExpenseScreen = navigationController.viewControllers.first as NewExpenseViewController
                newExpenseScreen.preselectedCategory = self.categorySummary?.category
                
            case Segues.PresentEditCategory:
                let navigationController = segue.destinationViewController as UINavigationController
                let editCategoryScreen = navigationController.viewControllers.first as EditCategoryViewController
                editCategoryScreen.categoryToEdit = self.categorySummary?.category
                
            default: ()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItems = [self.newExpenseBarButtonItem]
        
        // Register table view cells.
        tableView.registerNib(UINib(nibName: Classes.CategoryHeaderCell, bundle: nil), forCellReuseIdentifier: kCellCategoryHeader)
        tableView.registerNib(UINib(nibName: Classes.ExpenseCell, bundle: nil), forCellReuseIdentifier: kCellExpense)
        
        // Register for notifications.
        let notificationCenter = NSNotificationCenter.defaultCenter()
        for notification in self.recognizedNotifications {
            notificationCenter.addObserver(self, selector: Selector("notifyWithNotification:"), name: notification, object: nil)
        }
        
        // Fetch the sections and expenses for the first time.
        self.performFetch()
    }
    
}

// MARK: Target actions and observer callbacks
extension ExpensesViewController {
    
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
        let notificationName = notification.name
        
        switch notificationName {
        case Notifications.ExpenseAdded:
            let expense = notification.object as SPRExpense
            if self.categorySummary?.category.displayOrder == expense.category.displayOrder {
                self.performFetch()
                self.tableView.reloadData()
            }
            
        case Notifications.CategoryEdited:
            if let summary = self.categorySummary {
                // Refresh the category header cell.
                self.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: kSectionCategoryHeader)], withRowAnimation: .Automatic)
            }
            
        case Notifications.CategoryDeleted:
            // Just pop the view controller, to keep things simple.
            // It is assumed that the deleted category and this category are the same
            // since deleting categories are possible only through this view controller.
            self.navigationController?.popViewControllerAnimated(true)
            
        default: ()
        }
    }
    
}

// MARK: Table view data source
extension ExpensesViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        let count = 1 + self.expenseHeaders.count
        return count
    }
    
    func tableView(tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
            switch section {
            case kSectionCategoryHeader:
                return 1
            default:
                let expenses = self.expenses[section - 1]
                return expenses.count
            }
    }
    
    func tableView(tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            switch indexPath.section {
            case kSectionCategoryHeader:
                let cell = tableView.dequeueReusableCellWithIdentifier(kCellCategoryHeader) as CategoryHeaderCell
                cell.categorySummary = self.categorySummary
                return cell
                
                // By default, this is gonna be an expense cell.
            default:
                let expenses = self.expenses[indexPath.section - 1]
                let expense = expenses[indexPath.row]
                
                let cell = tableView.dequeueReusableCellWithIdentifier(kCellExpense) as ExpenseCell
                cell.expense = expense
                return cell
            }
    }
    
}

// MARK: Table view delegate
extension ExpensesViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView,
        heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
            switch indexPath.section {
            case kSectionCategoryHeader:
                return CategoryHeaderCell.heightForCategorySummary(self.categorySummary!)
            default:
                return UITableViewAutomaticDimension
            }
    }
    
    func tableView(tableView: UITableView,
        didSelectRowAtIndexPath indexPath: NSIndexPath) {
            switch indexPath.section {
            case kSectionCategoryHeader:
                self.performSegueWithIdentifier(Segues.PresentEditCategory, sender: self)
            default: ()
            }
            
            self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView,
        viewForHeaderInSection section: Int) -> UIView? {
            // The category header cell has no section header.
            if section == kSectionCategoryHeader {
                return nil
            }
            
            let expenseHeader = self.expenseHeaders[section - 1]
            let headerView = ExpenseHeaderView.instantiateFromNib(owner: self)
            if let expenseHeaderView = headerView as? ExpenseHeaderView {
                expenseHeaderView.expenseHeader = self.expenseHeaders[section - 1]
            }
            
            return headerView
    }
    
    func tableView(tableView: UITableView,
        heightForHeaderInSection section: Int) -> CGFloat {
            if section == kSectionCategoryHeader {
                return UITableViewAutomaticDimension
            }
            return 20
    }
    
}