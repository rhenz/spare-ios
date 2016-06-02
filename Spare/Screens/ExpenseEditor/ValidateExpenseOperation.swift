//
//  ValidateExpenseOperation.swift
//  Spare
//
//  Created by Matt Quiros on 12/05/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit
import Mold
import BNRCoreDataStack

class ValidateExpenseOperation: MDOperation {
    
    var expenseID: NSManagedObjectID
    var parentContext: NSManagedObjectContext?
    
    init(expense: Expense) {
        self.expenseID = expense.objectID
        self.parentContext = expense.managedObjectContext
    }
    
    override func buildResult(object: Any?) throws -> Any? {
        let context = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        context.parentContext = self.parentContext
        guard let expense = context.objectWithID(self.expenseID) as? Expense
            else {
                throw Error.AppUnknownError
        }
        
        // Put all the labels and values in an array for simplicity, then loop
        // through it looking for empty values.
        let fields: [(String, Any?)] = [("Description", nonEmptyString(expense.itemDescription)),
                      ("Amount", expense.amount),
                      ("Category", expense.category),
                      ("Date spent", expense.dateSpent),
                      ("Payment method", expense.paymentMethod)]
        for (label, value) in fields {
            if value == nil {
                throw Error.UserEnteredInvalidValue("\(label) is required.")
            }
        }
        
        return nil
    }
    
}