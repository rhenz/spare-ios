//
//  SPRTotalView.h
//  Spare
//
//  Created by Matt Quiros on 7/7/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SPRPeriod;

@interface SPRTotalView : UIButton

@property (strong, nonatomic) NSDecimalNumber *total;
@property (strong, nonatomic) SPRPeriod *period;

@end
