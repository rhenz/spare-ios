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

class HomeViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var summaries: [SPRCategorySummary] = []
    lazy var categoryFetcher: NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest()
        let entityDescription = NSEntityDescription.entityForName("SPRCategory", inManagedObjectContext: SPRManagedDocument.sharedDocument().managedObjectContext)
        let sortDescriptors = [NSSortDescriptor(key: "displayOrder", ascending: true)]
        
        let fetcher = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: SPRManagedDocument.sharedDocument().managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetcher
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the collection view.
        self.collectionView.draggable = true
        self.collectionView.registerClass(SPRCategorySummaryCell.self, forCellWithReuseIdentifier: kSummaryCell)
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
        
        for category in self.categoryFetcher.fetchedObjects {
            self.summaries += SPRCategorySummary(category: category as SPRCategory)
        }
    }
    
}

// MARK: UICollectionViewDataSource

extension HomeViewController: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView!, numberOfItemsInSection section: Int) -> Int  {
        return self.summaries.count
    }
    
    func collectionView(collectionView: UICollectionView!, cellForItemAtIndexPath indexPath: NSIndexPath!) -> UICollectionViewCell! {
        let identifier = kSummaryCell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as SPRCategorySummaryCell
        
        // Set the category.
        let summary = self.summaries[indexPath.row]
        cell.category = summary.category
        
        // Set the active period.
        let period = SPRPeriodManager.sharedManager().activePeriod
        cell.displayedTotal = summary.totalForPeriod(period)
        
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
    
}

// MARK: UICollectionViewDataSource_Draggable

extension HomeViewController: UICollectionViewDataSource_Draggable {
    
    func collectionView(collectionView: UICollectionView!, moveItemAtIndexPath fromIndexPath: NSIndexPath!, toIndexPath: NSIndexPath!) {
        
    }
    
    func collectionView(collectionView: UICollectionView!, canMoveItemAtIndexPath indexPath: NSIndexPath!) -> Bool {
        return true
    }
    
    func collectionView(collectionView: UICollectionView!, transformForDraggingItemAtIndexPath indexPath: NSIndexPath!, duration: UnsafePointer<NSTimeInterval>) -> CGAffineTransform {
        return CGAffineTransformMakeScale(1.15, 1.15)
    }
    
}
