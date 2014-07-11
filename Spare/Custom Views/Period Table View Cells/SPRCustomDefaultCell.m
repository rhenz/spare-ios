//
//  SPRCustomDefaultCell.m
//  Spare
//
//  Created by Matt Quiros on 7/10/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import "SPRCustomDefaultCell.h"

// Objects
#import "SPRPeriod.h"

@interface SPRCustomDefaultCell ()

@property (weak, nonatomic) IBOutlet UILabel *checkLabel;
@property (weak, nonatomic) IBOutlet UILabel *periodLabel;
@property (weak, nonatomic) IBOutlet UIButton *changeButton;

@end

@implementation SPRCustomDefaultCell

- (void)setPeriod:(SPRPeriod *)period
{
    [super setPeriod:period];
    
    UIFont *labelFont = [UIFont systemFontOfSize:18];
    
    NSArray *dateUnits = @[@"Day: ", @"Week: ", @"Month: ", @"Year: "];
    NSMutableAttributedString *periodText = [[NSMutableAttributedString alloc] initWithString:dateUnits[period.dateUnit] attributes:@{NSFontAttributeName : labelFont}];
    
    // If the period has no start and end dates, display the "Tap to select" label and
    // hide the Change button. Otherwise, show the selected period and the Change button.
    if (period.startDate == nil && period.endDate == nil) {
        [periodText appendAttributedString:[[NSAttributedString alloc] initWithString:@"Tap to select" attributes:@{NSFontAttributeName : labelFont, NSForegroundColorAttributeName : [UIColor grayColor]}]];
        self.changeButton.hidden = YES;
    } else {
        [periodText appendAttributedString:[[NSAttributedString alloc] initWithString:period.descriptiveForm attributes:@{NSFontAttributeName : labelFont, NSForegroundColorAttributeName : [UIColor blackColor]}]];
        self.changeButton.hidden = NO;
    }
    
    self.periodLabel.attributedText = periodText;
    
    // Hide the check label depending on whether the period is selected.
    self.checkLabel.hidden = !period.isSelected;
    
    [self setNeedsLayout];
}

- (IBAction)changeButtonTapped:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(changeButtonTappedForPeriod:)]) {
        [self.delegate changeButtonTappedForPeriod:self.period];
    }
}

@end
