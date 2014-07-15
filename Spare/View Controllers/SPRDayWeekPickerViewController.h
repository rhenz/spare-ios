//
//  SPRDayWeekPickerViewController.h
//  Spare
//
//  Created by Matt Quiros on 7/12/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPRDayWeekPickerViewController : UIViewController

- (instancetype)initWithDateUnit:(SPRDateUnit)dateUnit preselectedDate:(NSDate *)date;

@end
