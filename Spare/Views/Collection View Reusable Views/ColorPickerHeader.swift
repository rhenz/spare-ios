//
//  ColorPickerHeader.swift
//  Spare
//
//  Created by Matt Quiros on 9/19/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

import Foundation

class ColorPickerHeader: UICollectionReusableView {
    
    @IBOutlet weak var sectionLabel: UILabel!
    
    var section: String? {
        get {
            return self.sectionLabel.text
        }
        set {
            self.sectionLabel.text = newValue
        }
    }
}