//
//  UINib.swift
//  Spare
//
//  Created by Matt Quiros on 10/23/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

import Foundation

extension UINib {
    
    class func nibWithName(name: String) -> UINib {
        let nib = UINib(nibName: name, bundle: nil)
        return nib
    }
    
}