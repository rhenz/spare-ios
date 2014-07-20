//
//  SPRCalendarPickerCollectionViewCell.m
//  Spare
//
//  Created by Matt Quiros on 7/20/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import "SPRCalendarPickerCollectionViewCell.h"

// Custom objects
#import "SPRDate.h"

@interface SPRCalendarPickerCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation SPRCalendarPickerCollectionViewCell

- (void)setDate:(SPRDate *)date
{
    _date = date;
    self.dateLabel.text = [NSString stringWithFormat:@"%d", (int)self.date.day];
    [self setNeedsLayout];
}

@end
