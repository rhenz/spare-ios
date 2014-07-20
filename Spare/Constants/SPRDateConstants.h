//
//  SPRDateConstants.h
//  Spare
//
//  Created by Matt Quiros on 7/15/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SPRDateUnit) {
    SPRDateUnitNone = -1,
    SPRDateUnitDay = 0,
    SPRDateUnitWeek = 1,
    SPRDateUnitMonth,
    SPRDateUnitYear,
};

extern const NSInteger kSPRMinimumYear;
extern const NSInteger kSPRMaximumYear;