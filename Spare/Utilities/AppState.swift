//
//  AppState.swift
//  Spare
//
//  Created by Matt Quiros on 8/31/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

import Foundation

class AppState {
    
    lazy var activePeriod: Period = {
        // For now, always return today
        return Period.today()
    }()
    
    var hasBeenSetup = false
    
    // The preselected category when the New Expense screen is launched.
    var preselectedCategory: SPRCategory?
    
    class var sharedState: AppState {
        struct Singleton {
            static let instance = AppState()
        }
        return Singleton.instance
    }
    
}