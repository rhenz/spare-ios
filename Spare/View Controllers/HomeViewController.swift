//
//  HomeViewController.swift
//  Spare
//
//  Created by Matt Quiros on 26/08/2014.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

import UIKit
import CoreData

let kWidthRatio: CGFloat = 29.0
let kHeightRatio: CGFloat = 26.0

let kSummaryCell = "kSummaryCell"
let kNewCategoryCell = "kNewCategoryCell"

class HomeViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var summaries: Array<CategorySummary> = []
    var hasBeenSetup = false
    
    lazy var categoryFetcher: NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest()
        
        let entityDescription = NSEntityDescription.entityForName("SPRCategory", inManagedObjectContext: SPRManagedDocument.sharedDocument().managedObjectContext)
        fetchRequest.entity = entityDescription
        
        let sortDescriptors = [NSSortDescriptor(key: "displayOrder", ascending: true)]
        fetchRequest.sortDescriptors = sortDescriptors
        
        let fetcher = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: SPRManagedDocument.sharedDocument().managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetcher
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the collection view.
        self.collectionView.draggable = true
        self.collectionView.registerClass(SPRCategorySummaryCell.self, forCellWithReuseIdentifier: kSummaryCell)
        self.collectionView.registerNib(UINib(nibName: "NewCategoryCell", bundle: nil), forCellWithReuseIdentifier: kNewCategoryCell)
    }
    
    override func viewWillAppear(animated: Bool)  {
        super.viewWillAppear(animated)
        
        if self.hasBeenSetup {
            self.initializeSummaries()
            self.collectionView.reloadData()
        } else {
            let setupScreen = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SetupViewController") as UIViewController
            let navigationController = UINavigationController(rootViewController: setupScreen)
            self.presentViewController(navigationController, animated: false, completion: nil)
            self.hasBeenSetup = true
        }
    }
    
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation,
        duration: NSTimeInterval) {
            super.willRotateToInterfaceOrientation(toInterfaceOrientation, duration: duration)
            self.collectionView.reloadData()
    }
    
    func initializeSummaries() {
        var errorPointer: NSError?
        self.categoryFetcher.performFetch(&errorPointer)
        if let error = errorPointer {
            NSLog("Error fetching categories: %@", error)
        }
        
        self.summaries.removeAll(keepCapacity: false)
        for category in self.categoryFetcher.fetchedObjects {
            self.summaries.append(CategorySummary(category: category as SPRCategory))
        }
    }
    
}

// MARK: UICollectionViewDataSource

extension HomeViewController: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView!, numberOfItemsInSection section: Int) -> Int  {
        // Return the number of categories plus 1 for the New Category cell.
        return self.summaries.count + 1
    }
    
    func collectionView(collectionView: UICollectionView!, cellForItemAtIndexPath indexPath: NSIndexPath!) -> UICollectionViewCell! {
        var cell: UICollectionViewCell?
        
        switch indexPath.row {
            
            // The last cell is always the New Category cell.
        case self.summaries.count:
            cell = collectionView.dequeueReusableCellWithReuseIdentifier(kNewCategoryCell, forIndexPath: indexPath) as NewCategoryCell
            
            // Otherwise, this is a normal category summary cell.
        default:
            let actualCell = collectionView.dequeueReusableCellWithReuseIdentifier(kSummaryCell, forIndexPath: indexPath) as SPRCategorySummaryCell
            
            // Set the category.
            let summary = self.summaries[indexPath.row]
            actualCell.category = summary.category
            
            // Set the active period.
            let period = AppState.sharedState.activePeriod
            actualCell.displayedTotal = summary.totalForPeriod(period)
            
            cell = actualCell
        }
        
        return cell
    }
    
}

// MARK: UICollectionViewDelegateFlowLayout

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView!,
        layout collectionViewLayout: UICollectionViewLayout!,
        sizeForItemAtIndexPath indexPath: NSIndexPath!) -> CGSize {
            var padding: CGFloat?
            var tilesPerRow: Int?
            
            switch UIDevice.currentDevice().userInterfaceIdiom {
            case .Pad:
                padding = 20.0
                let orientation = UIApplication.sharedApplication().statusBarOrientation
                switch orientation {
                case .Portrait, .PortraitUpsideDown:
                    tilesPerRow = 2
                case .LandscapeLeft, .LandscapeRight:
                    tilesPerRow = 3
                default: ()
                }
                
            case .Phone:
                padding = 10.0
                tilesPerRow = 2
                
            default: ()
            }
            
            let numberOfPaddings = tilesPerRow! + 1
            let availableWidth = UIScreen.currentWidth() - (padding! * CGFloat(numberOfPaddings))
            let width = availableWidth / CGFloat(tilesPerRow!)
            let height = width * kHeightRatio / kWidthRatio
            
            return CGSizeMake(width, height)
    }
    
    func collectionView(collectionView: UICollectionView!,
        layout collectionViewLayout: UICollectionViewLayout!,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            var inset: CGFloat?
            switch UIDevice.currentDevice().userInterfaceIdiom {
            case .Phone:
                inset = 10.0
            case .Pad:
                inset = 20.0
            default: ()
            }
            return UIEdgeInsetsMake(inset!, inset!, inset!, inset!)
    }
    
    func collectionView(collectionView: UICollectionView!,
        layout collectionViewLayout: UICollectionViewLayout!,
        minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
            switch UIDevice.currentDevice().userInterfaceIdiom {
            case .Pad:
                return 20.0
            default: // .Phone
                return 10.0
            }
    }
    
    func collectionView(collectionView: UICollectionView!,
        layout collectionViewLayout: UICollectionViewLayout!,
        minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
            switch UIDevice.currentDevice().userInterfaceIdiom {
            case .Pad:
                return 20.0
            default: // .Phone
                return 10.0
            }
    }
    
    func collectionView(collectionView: UICollectionView!,
        didSelectItemAtIndexPath indexPath: NSIndexPath!) {
            if indexPath.row < self.summaries.count {
                self.performSegueWithIdentifier(kSegueShowExpenses, sender: self)
            }
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
