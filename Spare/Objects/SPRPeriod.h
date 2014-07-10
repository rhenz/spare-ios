//
//  SPRPeriod.h
//  Spare
//
//  Created by Matt Quiros on 7/7/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPRPeriod : NSObject <NSCoding>

@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSDate *endDate;
@property (nonatomic) SPRDateUnit dateUnit;
@property (strong, nonatomic) NSString *descriptiveForm;
@property (nonatomic, getter = isSelected) BOOL selected;

@end
