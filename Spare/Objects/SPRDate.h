//
//  SPRDate.h
//  Spare
//
//  Created by Matt Quiros on 7/19/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPRDate : NSObject

@property (strong, nonatomic) NSDate *date;
@property (nonatomic) NSInteger month;
@property (nonatomic) NSInteger day;
@property (nonatomic) NSInteger year;
@property (nonatomic) NSInteger weekday;

- (instancetype)initWithDate:(NSDate *)date;
- (instancetype)initWithMonth:(NSInteger)month day:(NSInteger)day year:(NSInteger)year;

- (NSUInteger)numberOfDaysInMonth;
- (SPRDate *)monthAwayByNumberOfMonths:(NSInteger)numberOfMonths;

@end
