//
//  SPRMonthPicker.m
//  Spare
//
//  Created by Matt Quiros on 7/11/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import "SPRMonthPicker.h"

@interface SPRMonthPicker ()

@property (weak, nonatomic) IBOutlet UIView *translucentBackground;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@property (strong, nonatomic) NSArray *months;
@property (strong, nonatomic) NSArray *years;

@end

static const CGFloat kAnimationDuration = 0.1;

@implementation SPRMonthPicker

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.alpha = 0;
    }
    return self;
}

- (void)awakeFromNib
{
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    [self.translucentBackground addGestureRecognizer:tapGestureRecognizer];
}

- (void)show
{
    // Set a preselected date if none has been supplied.
    if (self.preselectedDate == nil) {
        self.preselectedDate = [NSDate date];
    }
    
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.alpha = 1;
    }];
}

- (void)hide
{
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)setPreselectedDate:(NSDate *)preselectedDate
{
    _preselectedDate = preselectedDate;
    
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSMonthCalendarUnit|NSYearCalendarUnit fromDate:preselectedDate];
    [self.pickerView selectRow:(dateComponents.month - 1) inComponent:0 animated:NO];
    
    NSInteger indexOfYear = [self.years indexOfObject:@(dateComponents.year)];
    [self.pickerView selectRow:indexOfYear inComponent:1 animated:NO];
}

#pragma mark - Picker view data source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return [self.months count];
    }
    return [self.years count];
}

#pragma mark - Picker view delegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        return self.months[row];
    }
    return [NSString stringWithFormat:@"%d", [((NSNumber *)self.years[row]) intValue]];
}

#pragma mark - Lazy initializers

- (NSArray *)months
{
    if (!_months) {
        _months = @[@"January",
                    @"February",
                    @"March",
                    @"April",
                    @"May",
                    @"June",
                    @"July",
                    @"August",
                    @"September",
                    @"October",
                    @"November",
                    @"December"];
    }
    return _months;
}

- (NSArray *)years
{
    if (!_years) {
        NSMutableArray *years = [NSMutableArray array];
        for (int i = 2000; i <= 3000; i++) {
            [years addObject:@(i)];
        }
        _years = [NSArray arrayWithArray:years];
    }
    return _years;
}


@end
