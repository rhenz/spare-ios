//
//  SPRMonthPicker.h
//  Spare
//
//  Created by Matt Quiros on 7/11/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPRMonthPicker : UIView <UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) NSDate *preselectedDate;
- (void)show;

@end