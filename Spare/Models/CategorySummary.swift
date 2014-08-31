//
//  CategorySummary.swift
//  Spare
//
//  Created by Matt Quiros on 8/31/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

import Foundation

class CategorySummary {
    
    var category: SPRCategory
    
    init(category: SPRCategory) {
        self.category = category
    }
    
    func totalForPeriod(period: Period) -> NSDecimalNumber {
        let fetcher = CategorySummary.totalFetcher(self.category, period: period)
        fetcher.performFetch(nil)
        let dictionary = fetcher.fetchedObjects[0] as NSDictionary
        let total: NSDecimalNumber = dictionary["total"] as NSDecimalNumber
        return total
    }
    
    class func totalFetcher(category: SPRCategory,
        period: Period) -> NSFetchedResultsController {
            let fetchRequest = NSFetchRequest()
            
            let entityDescription = NSEntityDescription.entityForName("SPRExpense", inManagedObjectContext: SPRManagedDocument.sharedDocument().managedObjectContext)
            fetchRequest.entity = entityDescription
            
            let predicate = NSPredicate(format: "category == %@ AND dateSpent >= %@ AND dateSpent <= %@", category, period.startDate, period.endDate)
            fetchRequest.predicate = predicate
            
            let totalColumn = NSExpressionDescription()
            totalColumn.name = "total"
            totalColumn.expression = NSExpression(format: "@sum.amount")
            totalColumn.expressionResultType = .DecimalAttributeType
            
            fetchRequest.propertiesToFetch = [totalColumn]
            fetchRequest.resultType = .DictionaryResultType
            
            let sortDescriptor = NSSortDescriptor(key: "dateSpent", ascending: false)
            fetchRequest.sortDescriptors = [sortDescriptor]
            
            let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: SPRManagedDocument.sharedDocument().managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
            return fetchedResultsController
    }
    
}