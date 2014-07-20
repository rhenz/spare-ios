//
//  SPRCalendarPickerViewController.h
//  Spare
//
//  Created by Matt Quiros on 7/12/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SPRDate;

@interface SPRCalendarPickerViewController : UIViewController

- (instancetype)initWithDateUnit:(SPRDateUnit)dateUnit preselectedDate:(SPRDate *)date;

@end
