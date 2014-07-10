//
//  SPRQuickDefaultCell.m
//  Spare
//
//  Created by Matt Quiros on 7/8/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import "SPRQuickDefaultCell.h"

// Objects
#import "SPRPeriod.h"

@interface SPRQuickDefaultCell ()

@property (strong, nonatomic) IBOutlet UILabel *checkLabel;
@property (strong, nonatomic) IBOutlet UILabel *periodLabel;

@end

@implementation SPRQuickDefaultCell

- (void)setPeriod:(SPRPeriod *)period
{
    [super setPeriod:period];
    
    self.checkLabel.hidden = !period.isSelected;
    self.periodLabel.text = period.descriptiveForm;
    
    [self setNeedsLayout];
}

@end
