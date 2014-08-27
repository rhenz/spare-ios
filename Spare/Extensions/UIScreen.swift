//
//  UIScreen.swift
//  Spare
//
//  Created by Matt Quiros on 26/08/2014.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

import Foundation

extension UIScreen {
    
    class func currentWidth() -> CGFloat {
        let orientation = UIApplication.sharedApplication().statusBarOrientation
        switch orientation {
        case .Portrait, .PortraitUpsideDown:
            return UIScreen.mainScreen().bounds.size.width
        default:
            return UIScreen.mainScreen().bounds.size.height
        }
    }
    
    class func currentHeight() -> CGFloat {
        let orientation = UIApplication.sharedApplication().statusBarOrientation
        switch orientation {
        case .Portrait, .PortraitUpsideDown:
            return UIScreen.mainScreen().bounds.size.height
        default:
            return UIScreen.mainScreen().bounds.size.width
        }
    }
    
}