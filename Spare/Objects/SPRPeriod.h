//
//  SPRPeriod.h
//  Spare
//
//  Created by Matt Quiros on 7/7/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPRPeriod : NSObject

@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSDate *endDate;
@property (nonatomic, getter = isActive) BOOL active;
@property (strong, nonatomic) NSString *descriptiveForm;

+ (NSArray *)quickDefaults;

@end
