//
//  SPRCategorySummary.h
//  Spare
//
//  Created by Matt Quiros on 5/31/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SPRCategory;
@class SPRPeriod;

@interface SPRCategorySummary : NSObject

@property (strong, nonatomic) SPRCategory *category;

- (instancetype)initWithCategory:(SPRCategory *)category;
- (NSDecimalNumber *)totalForPeriod:(SPRPeriod *)period;

@end
