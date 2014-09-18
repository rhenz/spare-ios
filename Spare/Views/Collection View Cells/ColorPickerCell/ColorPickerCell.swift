//
//  ColorPickerCell.swift
//  Spare
//
//  Created by Matt Quiros on 9/18/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

import Foundation

class ColorPickerCell: UICollectionViewCell {
    
    @IBOutlet weak var colorBox: UIView!
    
    var colorNumber: Int = 0
    var active: Bool = false
    
    var contents: (colorNumber: Int, active: Bool)? {
        get {
            return (self.colorNumber, self.active)
        }
        set {
            // First, set the backing properties.
            if let value = newValue {
                self.colorNumber = value.colorNumber
                self.active = value.active
            }
            
            // Then, set the background colors.
            self.backgroundColor = self.active ? UIColor.darkGrayColor() : UIColor.clearColor()
            self.colorBox.backgroundColor = Colors.allColors[self.colorNumber]
        }
    }
    
}