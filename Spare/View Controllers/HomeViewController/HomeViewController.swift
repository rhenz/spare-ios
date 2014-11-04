//
//  HomeViewController.swift
//  Spare
//
//  Created by Matt Quiros on 26/08/2014.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

import UIKit
import CoreData

// MARK: Main class
class HomeViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let kSummaryCell = "kSummaryCell"
    let kNewCategoryCell = "kNewCategoryCell"
    
    var summaries: [CategorySummary]!
    var selectedIndexPath: NSIndexPath!
    
    let recognizedNotifications = [Notifications.ExpenseAdded,
        Notifications.CategoryAdded,
        Notifications.CategoryEdited,
        Notifications.CategoryDeleted]
    
    lazy var totalView: TotalView! = {
        let totalView = TotalView.instantiateFromNib(owner: self) as TotalView!
        totalView.delegate = self
        return totalView
    }()
    
    deinit {
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.removeObserver(self)
    }
    
}

// MARK: UIViewController methods
extension HomeViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the title view.
        self.navigationItem.titleView = self.totalView
        
        // Set up the collection view.
        self.collectionView.draggable = true
        self.collectionView.registerNib(CategorySummaryCell.nib(), forCellWithReuseIdentifier: kSummaryCell)
        self.collectionView.registerNib(NewCategoryCell.nib(), forCellWithReuseIdentifier: kNewCategoryCell)
        
        // Listen for notifications.
        let notificationCenter = NSNotificationCenter.defaultCenter()
        for notification in self.recognizedNotifications {
            notificationCenter.addObserver(self, selector: Selector("notifyWithNotification:"), name: notification, object: nil)
        }
    }
    
    override func viewWillAppear(animated: Bool)  {
        super.viewWillAppear(animated)
        
        // If the app has not yet been set up, launch the setup screen and initialize the category summaries.
        if AppState.sharedState.hasBeenSetup == false {
            self.performSegueWithIdentifier(Segues.PresentSetup, sender: self)
            AppState.sharedState.hasBeenSetup = true
        }
            
        else {
            // If the summaries have not yet been retrieved, retrieve them.
            if summaries == nil {
                summaries = []
                let categories = SPRCategory.allCategories()
                if let activePeriod = PeriodList.sharedList.activePeriod {
                    for category in categories {
                        summaries.append(CategorySummary(category: category as SPRCategory, period: activePeriod))
                    }
                }
                
                // Refresh the collection view to reflect changes in totals & the list of categories.
                self.collectionView.reloadData()
                
                // Update the total view.
                self.updateTotalView()
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        // Force the collection view to re-layout when device orientation changes.
        self.collectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case Segues.ShowExpenses:
                let expensesScreen = segue.destinationViewController as ExpensesViewController
                expensesScreen.categorySummary = summaries[selectedIndexPath.row]
            case Segues.PresentPeriod:
                let navigationController = segue.destinationViewController as UINavigationController
                let periodScreen = navigationController.viewControllers[0] as PeriodViewController
                periodScreen.delegate = self
            default: ()
            }
        }
    }
    
}

// MARK: Helper functions
extension HomeViewController {
    
    func updateTotalView() {
        // Add the totals of each category.
        var total = NSDecimalNumber(double: 0)
        for summary in self.summaries {
            let categoryTotal = summary.total
            total = total.decimalNumberByAdding(categoryTotal)
        }
        
        self.totalView.total = total
        self.totalView.period = PeriodList.sharedList.activePeriod
    }
    
}

// MARK: Target actions and notifications
extension HomeViewController {
    
    @IBAction func newExpenseButtonTapped(sender: AnyObject) {
        if self.summaries.count > 0 {
            if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
                self.performSegueWithIdentifier(Segues.PresentNewExpense, sender: self)
            } else {
                self.performSegueWithIdentifier(Segues.PopoverNewExpense, sender: self)
            }
        } else {
            UIAlertView(title: "Invalid action",
                message: "Before adding a new expense, you must first create a category.",
                delegate: nil,
                cancelButtonTitle: "Got it!").show()
        }
    }
    
    func notifyWithNotification(notification: NSNotification) {
        switch notification.name {
        case Notifications.ExpenseAdded:
            // Update the total view.
            self.updateTotalView()
            
            // Get the category and refresh it.
            let object = notification.object as? SPRExpense
            if let expense = object {
                let category = expense.category
                self.collectionView.reloadItemsAtIndexPaths([NSIndexPath(forItem: category.displayOrder.integerValue, inSection: 0)])
            }
            
        case Notifications.CategoryAdded:
            if let category = notification.object as? SPRCategory {
                if let activePeriod = PeriodList.sharedList.activePeriod {
                    let summary = CategorySummary(category: category, period: activePeriod)
                    self.summaries.append(summary)
                }
                self.collectionView.reloadData()
            }
            
        case Notifications.CategoryEdited:
            if let category = notification.object as? SPRCategory {
                let index = category.displayOrder.integerValue
                self.summaries[index].category = category
                self.collectionView.reloadItemsAtIndexPaths([NSIndexPath(forItem: index, inSection: 0)])
            }
            
        case Notifications.CategoryDeleted:
            if let displayOrder = notification.object as? NSNumber {
                self.summaries.removeAtIndex(displayOrder.integerValue)
                
                // Reassign the display orders from the deleted category onwards.
                for i in displayOrder.integerValue..<self.summaries.count {
                    var summary = self.summaries[i]
                    summary.category.displayOrder = NSNumber(integer: i)
                }
                
                self.collectionView.reloadData()
            }
            
            // Update the total view.
            self.updateTotalView()
            
        default: ()
        }
    }
    
}
