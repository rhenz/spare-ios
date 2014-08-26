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

class HomeViewController: UIViewController, UICollectionViewDataSource {
    
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

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, sizeForItemAtIndexPath indexPath: NSIndexPath!) -> CGSize {
        var padding: CGFloat?
        var tilesPerRow: Int?
        
        switch UIDevice.currentDevice().userInterfaceIdiom {
            
        case .Pad:
            padding = 20.0
            switch UIApplication.sharedApplication().statusBarOrientation {
            case .Portrait:
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
    
}