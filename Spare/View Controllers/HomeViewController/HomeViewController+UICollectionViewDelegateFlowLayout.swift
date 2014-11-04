//
//  HomeViewController+UICollectionViewDelegateFlowLayout.swift
//  Spare
//
//  Created by Matt Quiros on 11/4/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

import Foundation

private let kWidthRatio = CGFloat(29)
private let kHeightRatio = CGFloat(26)
private let kPadding = CGFloat(10)

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