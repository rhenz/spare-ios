//
//  NSDate+SPR.h
//  Spare
//
//  Created by Matt Quiros on 3/30/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import <Foundation/Foundation.h>

// Constants
#import "SPRDateDimension.h"

@interface NSDate (SPR)

- (BOOL)isSameDayAsDate:(NSDate *)date;
- (NSString *)textInForm;

- (NSDate *)firstMomentInDimension:(SPRDateDimension)timeFrame;
- (NSDate *)lastMomentInDimension:(SPRDateDimension)timeFrame;

+ (NSDate *)simplifiedDate;
+ (NSDate *)simplifiedDateFromDate:(NSDate *)date;

@end
