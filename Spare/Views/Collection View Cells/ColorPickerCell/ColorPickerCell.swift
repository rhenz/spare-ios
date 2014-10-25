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
    
    /**
    Fixes bug where constraints aren't updated in iOS 7 but update in iOS 8.
    See: http://stackoverflow.com/a/25791713/855680
    */
    override func layoutSubviews() {
        self.contentView.frame = self.bounds
        super.layoutSubviews()
    }
    
    override class func className() -> String? {
        return "ColorPickerCell"
    }
}