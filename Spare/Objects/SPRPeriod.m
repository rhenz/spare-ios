//
//  SPRPeriod.m
//  Spare
//
//  Created by Matt Quiros on 7/7/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import "SPRPeriod.h"

static NSArray *quickDefaults;

@implementation SPRPeriod

+ (NSArray *)quickDefaults
{
    if (!quickDefaults) {
        // Get the current date.
        NSDate *currentDate = [NSDate date];
        
        // Set up the arrays for iteration.
        int dateDimensions[] = {SPRDateDimensionDay, SPRDateDimensionWeek, SPRDateDimensionMonth, SPRDateDimensionYear};
        NSArray *descriptiveForms = @[@"Today", @"This week", @"This month", @"This year"];
        
        NSMutableArray *periods = [NSMutableArray array];
        SPRPeriod *period;
        
        for (int i = 0; i < 4; i++) {
            period = [[SPRPeriod alloc] init];
            period.startDate = [currentDate firstMomentInDimension:dateDimensions[i]];
            period.endDate = [currentDate lastMomentInDimension:dateDimensions[i]];
            period.descriptiveForm = descriptiveForms[i];
            [periods addObject:period];
        }
        
        quickDefaults = [NSArray arrayWithArray:periods];
    }
    return quickDefaults;
}

@end
