//
//  HomeViewController.swift
//  Spare
//
//  Created by Matt Quiros on 26/08/2014.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

import UIKit

let kWidthRatio: CGFloat = 29.0
let kHeightRatio: CGFloat = 26.0

class HomeViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.draggable = true
    }
    
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation,
        duration: NSTimeInterval) {
            super.willRotateToInterfaceOrientation(toInterfaceOrientation, duration: duration)
            self.collectionView.reloadData()
    }
    
}

// MARK: UICollectionViewDataSource

extension HomeViewController: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView!, numberOfItemsInSection section: Int) -> Int  {
        return 10
    }
    
    func collectionView(collectionView: UICollectionView!, cellForItemAtIndexPath indexPath: NSIndexPath!) -> UICollectionViewCell! {
        let identifier = "Cell"
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as UICollectionViewCell
        cell.backgroundColor = UIColor.redColor()
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
