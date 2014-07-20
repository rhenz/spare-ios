//
//  SPRDate.m
//  Spare
//
//  Created by Matt Quiros on 7/19/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import "SPRDate.h"

static NSString * const kDateKeyPath = @"date";
static const NSInteger kInvalid = -1;

@implementation SPRDate

- (instancetype)initWithDate:(NSDate *)date
{
    if (self = [super init]) {
        _date = date;
        _month = kInvalid;
        _day = kInvalid;
        _year = kInvalid;
        _weekday = kInvalid;
    }
    return self;
}

- (instancetype)initWithMonth:(NSInteger)month day:(NSInteger)day year:(NSInteger)year
{
    // Create the NSDate object from the month, day, and year.
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.month = month;
    components.day = day;
    components.year = year;
    components.hour = 0;
    components.minute = 0;
    components.second = 0;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *date = [calendar dateFromComponents:components];
    
    if (self = [self initWithDate:date]) {
        _month = month;
        _day = day;
        _year = year;
    }
    return self;
}

- (NSUInteger)numberOfDaysInMonth
{
    switch (self.month) {
        case 1:
        case 3:
        case 5:
        case 7:
        case 8:
        case 10:
        case 12: {
            return 31;
        }
        case 2: {
            if (self.year % 4 == 0) {
                return 29;
            } else {
                return 28;
            }
        }
        default: {
            return 30;
        }
    }
}

- (SPRDate *)monthAwayByNumberOfMonths:(NSInteger)numberOfMonths
{
    // Get this date's month and year.
    NSInteger month = self.month;
    NSInteger year = self.year;
    
    // Compute for the offset.
    NSInteger monthOffset = numberOfMonths % 12;
    NSInteger yearOffset = numberOfMonths / 12;
    
    month += monthOffset;
    year += yearOffset;
    
    // If the month goes less than 1 or more than 12, correct it.
    if (month < 1) {
        month += 12;
    } else if (month > 12) {
        month -= 12;
    }
    
    SPRDate *date = [[SPRDate alloc] initWithMonth:month day:1 year:year];
    return date;
}

#pragma mark - Lazy initializers

- (NSInteger)month
{
    if (_month == kInvalid) {
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *components = [calendar components:NSMonthCalendarUnit fromDate:self.date];
        _month = components.month;
    }
    return _month;
}

- (NSInteger)day
{
    if (_day == kInvalid) {
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *components = [calendar components:NSDayCalendarUnit fromDate:self.date];
        _day = components.day;
    }
    return _day;
}

- (NSInteger)year
{
    if (_year == kInvalid) {
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *components = [calendar components:NSYearCalendarUnit fromDate:self.date];
        _year = components.year;
    }
    return _year;
}

- (NSInteger)weekday
{
    if (_weekday == kInvalid) {
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *components = [calendar components:NSWeekdayCalendarUnit fromDate:self.date];
        _weekday = components.weekday;
    }
    return _weekday;
}

#pragma mark - Key value observing

+ (NSSet *)keyPathsForValuesAffectingDay
{
    return [NSSet setWithObject:kDateKeyPath];
}

+ (NSSet *)keyPathsForValuesAffectingMonth
{
    return [NSSet setWithObject:kDateKeyPath];
}

+ (NSSet *)keyPathsForValuesAffectingYear
{
    return [NSSet setWithObject:kDateKeyPath];
}

+ (NSSet *)keyPathsForValuesAffectingWeekday
{
    return [NSSet setWithObject:kDateKeyPath];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:kDateKeyPath]) {
        self.month = kInvalid;
        self.day = kInvalid;
        self.year = kInvalid;
        self.weekday = kInvalid;
    }
}

@end
