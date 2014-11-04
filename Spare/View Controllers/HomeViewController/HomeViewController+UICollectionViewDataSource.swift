//
//  HomeViewController+UICollectionViewDataSource.swift
//  Spare
//
//  Created by Matt Quiros on 11/4/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

import Foundation

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