//
//  NSDate+SPR.h
//  Spare
//
//  Created by Matt Quiros on 3/30/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import <Foundation/Foundation.h>

// Constants
#import "SPRDateConstants.h"

@interface NSDate (SPR)

- (BOOL)isSameDayAsDate:(NSDate *)date;
- (BOOL)isSameMonthAsDate:(NSDate *)date;
- (BOOL)isSameYearAsDate:(NSDate *)date;

- (NSString *)textInForm;

- (NSDate *)firstMomentInDateUnit:(SPRDateUnit)dateUnit;
- (NSDate *)lastMomentInDateUnit:(SPRDateUnit)dateUnit;

- (NSUInteger)month;
- (NSUInteger)day;
- (NSUInteger)year;

+ (NSDate *)simplifiedDate;
+ (NSDate *)simplifiedDateFromDate:(NSDate *)date;

@end
