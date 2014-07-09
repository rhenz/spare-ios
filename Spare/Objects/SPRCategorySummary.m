//
//  SPRCategorySummary.m
//  Spare
//
//  Created by Matt Quiros on 5/31/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import "SPRCategorySummary.h"

// Objects
#import "SPRExpense+Extension.h"
#import "SPRManagedDocument.h"
#import "SPRPeriod.h"

@interface SPRCategorySummary ()

@end

@implementation SPRCategorySummary

- (id)init
{
    self = [self initWithCategory:nil];
    return self;
}

- (instancetype)initWithCategory:(SPRCategory *)category
{
    if (self = [super init]) {
        _category = category;
    }
    return self;
}

- (NSDecimalNumber *)totalForPeriod:(SPRPeriod *)period
{
    NSFetchedResultsController *fetcher = [SPRCategorySummary totalFetcherForCategory:self.category period:period];
    [fetcher performFetch:nil];
    NSDictionary *dictionary = fetcher.fetchedObjects[0];
    NSDecimalNumber *total = dictionary[@"total"];
    return total;
}

#pragma mark -

+ (NSFetchedResultsController *)totalFetcherForCategory:(SPRCategory *)category period:(SPRPeriod *)period
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:NSStringFromClass([SPRExpense class]) inManagedObjectContext:[SPRManagedDocument sharedDocument].managedObjectContext];
    fetchRequest.entity = entityDescription;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"category == %@ AND dateSpent >= %@ AND dateSpent <= %@", category, period.startDate, period.endDate];
    fetchRequest.predicate = predicate;
    
    NSExpressionDescription *totalColumn = [[NSExpressionDescription alloc] init];
    totalColumn.name = @"total";
    totalColumn.expression = [NSExpression expressionWithFormat:@"@sum.amount"];
    totalColumn.expressionResultType = NSDecimalAttributeType;
    
    fetchRequest.propertiesToFetch = @[totalColumn];
    fetchRequest.resultType = NSDictionaryResultType;
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"dateSpent" ascending:NO];
    fetchRequest.sortDescriptors = @[sortDescriptor];
    
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[SPRManagedDocument sharedDocument].managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    return fetchedResultsController;
}

@end
