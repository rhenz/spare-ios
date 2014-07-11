//
//  SPRCustomDefaultCell.h
//  Spare
//
//  Created by Matt Quiros on 7/10/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import "SPRPeriodTableViewCell.h"

@protocol SPRCustomDefaultCellDelegate <NSObject>

- (void)changeButtonTappedForPeriod:(SPRPeriod *)period;

@end

@interface SPRCustomDefaultCell : SPRPeriodTableViewCell

@property (weak, nonatomic) id<SPRCustomDefaultCellDelegate> delegate;

@end
