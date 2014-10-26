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
    
    private let kWidthRatio = CGFloat(29)
    private let kHeightRatio = CGFloat(26)
    private let kPadding = CGFloat(10)
    
    private let kSummaryCell = "kSummaryCell"
    private let kNewCategoryCell = "kNewCategoryCell"
    
    @IBOutlet weak var collectionView: UICollectionView!
    
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
        let identifier = segue.identifier
        
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
                self.collectionView.reloadItemsAtIndexPaths([NSIndexPath(forItem: category.displayOrder, inSection: 0)])
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
                self.summaries.removeAtIndex(displayOrder)
                
                // Reassign the display orders from the deleted category onwards.
                for i in displayOrder..<self.summaries.count {
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

// MARK: UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int  {
            // If the summaries have not yet been retrieved, just return 0.
            if summaries == nil {
                return 0
            }
            
            // Return the number of categories plus 1 for the New Category cell.
            return self.summaries.count + 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell: UICollectionViewCell?
        
        switch indexPath.row {
            
            // The last cell is always the New Category cell.
        case self.summaries.count:
            cell = collectionView.dequeueReusableCellWithReuseIdentifier(kNewCategoryCell, forIndexPath: indexPath) as NewCategoryCell
            
            // Otherwise, this is a normal category summary cell.
        default:
            let actualCell = collectionView.dequeueReusableCellWithReuseIdentifier(kSummaryCell, forIndexPath: indexPath) as CategorySummaryCell
            
            // Set the category label.
            let summary = self.summaries[indexPath.row]
            actualCell.summary = summary
            
            cell = actualCell
        }
        
        return cell!
    }
    
}

// MARK: UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView!,
        didSelectItemAtIndexPath indexPath: NSIndexPath!) {
            // If one of the categories has been selected, open the Expenses screen.
            // Otherwise, launch the new category modal.
            if indexPath.row < self.summaries.count {
                self.selectedIndexPath = indexPath
                self.performSegueWithIdentifier(Segues.ShowExpenses, sender: self)
            } else {
                self.performSegueWithIdentifier(Segues.PresentNewCategory, sender: self)
            }
    }
    
}

// MARK: UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView!,
        layout collectionViewLayout: UICollectionViewLayout!,
        sizeForItemAtIndexPath indexPath: NSIndexPath!) -> CGSize {
            var tilesPerRow: Int = {
                let orientation = UIApplication.sharedApplication().statusBarOrientation
                switch orientation {
                case .Portrait, .PortraitUpsideDown:
                    return 2
                default:
                    return 3
                }
            }()
            
            let numberOfPaddings = tilesPerRow + 1
            let availableWidth = UIScreen.currentWidth() - (kPadding * CGFloat(numberOfPaddings))
            let width = availableWidth / CGFloat(tilesPerRow)
            let height = width * kHeightRatio / kWidthRatio
            
            return CGSizeMake(width, height)
    }
    
    func collectionView(collectionView: UICollectionView!,
        layout collectionViewLayout: UICollectionViewLayout!,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            return UIEdgeInsetsMake(kPadding, kPadding, kPadding, kPadding)
    }
    
    func collectionView(collectionView: UICollectionView!,
        layout collectionViewLayout: UICollectionViewLayout!,
        minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
            return kPadding
    }
    
    func collectionView(collectionView: UICollectionView!,
        layout collectionViewLayout: UICollectionViewLayout!,
        minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
            return kPadding
    }
    
}

// MARK: UICollectionViewDataSource_Draggable
extension HomeViewController: UICollectionViewDataSource_Draggable {
    
    func collectionView(collectionView: UICollectionView!, moveItemAtIndexPath fromIndexPath: NSIndexPath!, toIndexPath: NSIndexPath!) {
        // Move the summary's location in the array.
        var summary = self.summaries.removeAtIndex(fromIndexPath.row)
        self.summaries.insert(summary, atIndex: toIndexPath.row)
        
        // Reassign the display order of categories.
        for var i = 0; i < self.summaries.count; i++ {
            summary = self.summaries[i]
            summary.category.displayOrder = NSNumber(integer: i)
        }
        
        // Persist the reordering into the managed document.
        SPRManagedDocument.sharedDocument().saveWithCompletionHandler(nil)
    }
    
    func collectionView(collectionView: UICollectionView!,
        canMoveItemAtIndexPath indexPath: NSIndexPath!) -> Bool {
            // Can't move the New Category cell.
        return indexPath.row < self.summaries.count
    }
    
    func collectionView(collectionView: UICollectionView!,
        canMoveItemAtIndexPath indexPath: NSIndexPath!,
        toIndexPath: NSIndexPath!) -> Bool {
            // Can't move to the New Category cell.
        return toIndexPath.row < self.summaries.count
    }
    
    func collectionView(collectionView: UICollectionView!, transformForDraggingItemAtIndexPath indexPath: NSIndexPath!, duration: UnsafePointer<NSTimeInterval>) -> CGAffineTransform {
        return CGAffineTransformMakeScale(1.15, 1.15)
    }
    
}

// MARK: TotalViewDelegate
extension HomeViewController: TotalViewDelegate {
    
    func totalViewDidTap(totalView: TotalView) {
        self.performSegueWithIdentifier(Segues.PresentPeriod, sender: self)
    }
    
}

// MARK: PeriodViewControllerDelegate
extension HomeViewController: PeriodViewControllerDelegate {
    
    func periodViewControllerDidUpdate(periodViewController: PeriodViewController) {
        // Set the new active period in each summary.
        if let activePeriod = PeriodList.sharedList.activePeriod {
            for summary in self.summaries {
                summary.period = activePeriod
            }
        }
        
        self.updateTotalView()
        self.collectionView.reloadData()
    }
    
}