//
//  SPRDatePickerView.h
//  Spare
//
//  Created by Matt Quiros on 4/9/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SPRDayPicker;

@protocol SPRDayPickerDelegate <NSObject>

- (void)dayPickerWillDisappear:(SPRDayPicker *)dayPicker;
- (void)dayPicker:(SPRDayPicker *)dayPicker didSelectDate:(NSDate *)date;

@end

@interface SPRDayPicker : UIView

@property (weak, nonatomic) id<SPRDayPickerDelegate> delegate;
@property (strong, nonatomic) NSDate *preselectedDate;

- (void)show;

@end
