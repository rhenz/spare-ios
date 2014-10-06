//
//  UIView.swift
//  Spare
//
//  Created by Matt Quiros on 10/6/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

import Foundation

extension UIView {
    
    /**
    Views that can be instantiated from a nib file must override this class function
    to provide the class name, which is also the name of the nib file.
    */
    class func className() -> String? {
        return nil
    }
    
    /**
    Creates an instance of this class based on a nib file of the same name as the class.
    */
    class func instantiateFromNib(#owner: AnyObject) -> UIView? {
        let bundle = NSBundle.mainBundle()
        if let className = self.className() {
            let instance = bundle.loadNibNamed(className, owner: owner, options: nil).last as UIView?
            return instance
        }
        return nil
    }
    
}