//
//  HomeViewController+UICollectionViewDelegate.swift
//  Spare
//
//  Created by Matt Quiros on 11/4/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

import Foundation

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