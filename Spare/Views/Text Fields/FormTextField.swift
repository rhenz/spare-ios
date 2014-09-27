//
//  FormTextField.swift
//  Spare
//
//  Created by Matt Quiros on 9/16/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

import Foundation

class FormTextField: UITextField {
    
    var field: Field? {
        get {
            return self.actualField
        }
        set {
            self.actualField = newValue
            self.text = newValue?.value as? String
        }
    }
    
    private var actualField: Field?
    
}