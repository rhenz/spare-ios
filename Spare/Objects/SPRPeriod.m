//
//  SPRPeriod.m
//  Spare
//
//  Created by Matt Quiros on 7/7/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import "SPRPeriod.h"

@implementation SPRPeriod

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dateUnit = SPRDateUnitNone;
    }
    return self;
}

//- (id)initWithCoder:(NSCoder *)aDecoder
//{
//    if (self = [super init]) {
//        _startDate = [aDecoder decodeObjectForKey:@"startDate"];
//        _endDate = [aDecoder decodeObjectForKey:@"endDate"];
//        _dateUnit = [aDecoder decodeIntegerForKey:@"dateUnit"];
//    }
//    return self;
//}
//
//- (void)encodeWithCoder:(NSCoder *)aCoder
//{
//    [aCoder encodeObject:self.startDate forKey:@"startDate"];
//    [aCoder encodeObject:self.endDate forKey:@"endDate"];
//    [aCoder encodeInteger:self.dateUnit forKey:@"dateUnit"];
//}

- (NSString *)descriptiveForm
{
    if (_descriptiveForm) {
        return _descriptiveForm;
    };
    
    NSString *descriptiveForm;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    switch (self.dateUnit) {
        case SPRDateUnitDay: {
            formatter.dateFormat = @"EEE MMM d, yyyy";
            descriptiveForm = [formatter stringFromDate:self.startDate];
            break;
        }
        case SPRDateUnitWeek: {
            if (![self.endDate isSameYearAsDate:self.startDate]) {
                formatter.dateFormat = @"MMM d, yyyy";
                descriptiveForm = [NSString stringWithFormat:@"Week of %@ - %@",
                                   [formatter stringFromDate:self.startDate],
                                   [formatter stringFromDate:self.endDate]];
            } else if (![self.endDate isSameMonthAsDate:self.startDate]) {
                formatter.dateFormat = @"MMM";
                NSString *startMonth = [formatter stringFromDate:self.startDate];
                NSString *endMonth = [formatter stringFromDate:self.endDate];
                
                formatter.dateFormat = @"d";
                NSString *startDay = [formatter stringFromDate:self.startDate];
                NSString *endDay = [formatter stringFromDate:self.endDate];
                
                formatter.dateFormat = @"yyyy";
                NSString *year = [formatter stringFromDate:self.startDate];
                
                descriptiveForm = [NSString stringWithFormat:@"Week of %@ %@ - %@ %@, %@",
                                   startMonth, startDay, endMonth, endDay, year];
            } else {
                formatter.dateFormat = @"MMM";
                NSString *month = [formatter stringFromDate:self.startDate];
                
                formatter.dateFormat = @"yyyy";
                NSString *year = [formatter stringFromDate:self.startDate];
                
                formatter.dateFormat = @"d";
                NSString *startDay = [formatter stringFromDate:self.startDate];
                NSString *endDay = [formatter stringFromDate:self.startDate];
                
                descriptiveForm = [NSString stringWithFormat:@"Week of %@ %@ - %@, %@", month, startDay, endDay, year];
            }
            break;
        }
        case SPRDateUnitMonth: {
            formatter.dateFormat = @"MMMM yyyy";
            descriptiveForm = [NSString stringWithFormat:@"Month of %@", [formatter stringFromDate:self.startDate]];
            break;
        }
        case SPRDateUnitYear: {
            formatter.dateFormat = @"'Year' yyyy";
            descriptiveForm = [formatter stringFromDate:self.startDate];
            break;
        }
        case SPRDateUnitNone: {
            formatter.dateStyle = NSDateFormatterMediumStyle;
            descriptiveForm = [NSString stringWithFormat:@"%@ - %@",
                               [formatter stringFromDate:self.startDate],
                               [formatter stringFromDate:self.endDate]];
            break;
        }
    }
    
    _descriptiveForm = descriptiveForm;
    return _descriptiveForm;
}

- (void)setStartDate:(NSDate *)startDate
{
    _startDate = startDate;
    self.descriptiveForm = nil;
}

- (void)setEndDate:(NSDate *)endDate
{
    _endDate = endDate;
    self.descriptiveForm = nil;
}

@end
