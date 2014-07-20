//
//  SPRCalendarPickerNavigationBar.h
//  Spare
//
//  Created by Matt Quiros on 7/13/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SPRCalendarPickerNavigationBarDelegate <NSObject>

- (void)dayWeekPickerNavigationBarDidTapCancel;
- (void)dayWeekPickerNavigationBarDidTapDone;

@end

@interface SPRCalendarPickerNavigationBar : UIView

@property (weak, nonatomic) id<SPRCalendarPickerNavigationBarDelegate> delegate;

@end
