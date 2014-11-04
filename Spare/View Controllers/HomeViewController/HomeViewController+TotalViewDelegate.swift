//
//  HomeViewController+TotalViewDelegate.swift
//  Spare
//
//  Created by Matt Quiros on 11/4/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

import Foundation

// MARK: TotalViewDelegate
extension HomeViewController: TotalViewDelegate {
    
    func totalViewDidTap(totalView: TotalView) {
        self.performSegueWithIdentifier(Segues.PresentPeriod, sender: self)
    }
    
}