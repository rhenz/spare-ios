//
//  SPRDatePickerView.m
//  Spare
//
//  Created by Matt Quiros on 4/9/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import "SPRDayPicker.h"

static const CGFloat kAnimationDuration = 0.1;

@interface SPRDayPicker ()

@property (strong, nonatomic) IBOutlet UIView *translucentBackground;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation SPRDayPicker

- (id)init
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"SPRDayPicker" owner:nil options:nil] firstObject];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [self init];
    return self;
}

- (void)awakeFromNib
{
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    [self.translucentBackground addGestureRecognizer:tapRecognizer];
    
    self.datePicker.backgroundColor = [UIColor whiteColor];
    [self.datePicker addTarget:self action:@selector(datePickerChanged) forControlEvents:UIControlEventValueChanged];
    self.alpha = 0;
}

- (void)show
{
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.alpha = 1;
    }];
}

#pragma mark - Target action

- (void)datePickerChanged
{
    if ([self.delegate respondsToSelector:@selector(dayPicker:didSelectDate:)]) {
        [self.delegate dayPicker:self didSelectDate:self.datePicker.date];
    }
}

- (void)hide
{
    if ([self.delegate respondsToSelector:@selector(dayPickerWillDisappear:)]) {
        [self.delegate dayPickerWillDisappear:self];
    }
    
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - Setters

- (void)setPreselectedDate:(NSDate *)preselectedDate
{
    _preselectedDate = preselectedDate;
    self.datePicker.date = preselectedDate;
}

@end
