//
//  HomeViewController+PeriodViewControllerDelegate.swift
//  Spare
//
//  Created by Matt Quiros on 11/4/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

import Foundation

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