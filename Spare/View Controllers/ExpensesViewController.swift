//
//  ExpensesViewController.swift
//  Spare
//
//  Created by Matt Quiros on 29/08/2014.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

import Foundation

class ExpensesViewController: UIViewController {
    
    lazy var newExpenseBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: Selector("newExpenseButtonTapped"))
        return barButtonItem
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItems = [self.newExpenseBarButtonItem]
    }
    
}