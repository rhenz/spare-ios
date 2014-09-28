//
//  SetupViewController.swift
//  Spare
//
//  Created by Matt Quiros on 28/08/2014.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

import Foundation

class SetupViewController: UIViewController {
    
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    
    override func viewDidAppear(animated: Bool)  {
        super.viewDidAppear(animated)
        let document = SPRManagedDocument.sharedDocument()
        document.prepareWithCompletionHandler {[unowned self] success in
            if success {
                self.dismissViewControllerAnimated(false, completion: nil)
            } else {
                self.loadingView.stopAnimating()
                UIAlertView(title: "Error", message: "Categories can't be loaded.", delegate: nil, cancelButtonTitle: "OK").show()
            }
        }
    }
    
}
