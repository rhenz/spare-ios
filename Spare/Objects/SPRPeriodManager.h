//
//  SPRPeriodManager.h
//  Spare
//
//  Created by Matt Quiros on 7/9/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SPRPeriod;

@interface SPRPeriodManager : NSObject

@property (strong, nonatomic) NSArray *periods;
@property (strong, nonatomic, readonly) SPRPeriod *activePeriod;
@property (strong, nonatomic) NSIndexPath *activeIndexPath;
@property (strong, nonatomic) NSIndexPath *selectedIndexPath;

+ (instancetype)sharedManager;

- (void)save;

@end
