//
//  AppState.swift
//  Spare
//
//  Created by Matt Quiros on 8/31/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

import Foundation

class AppState {
    
    var hasBeenSetup = false
    
    class var sharedState: AppState {
        struct Singleton {
            static let instance = AppState()
        }
        return Singleton.instance
    }
    
}