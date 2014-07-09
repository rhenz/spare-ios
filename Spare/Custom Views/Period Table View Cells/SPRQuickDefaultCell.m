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

@property (strong, nonatomic) UILabel *checkLabel;
@property (strong, nonatomic) UILabel *periodLabel;

@end

@implementation SPRQuickDefaultCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _checkLabel = [[UILabel alloc] init];
        _checkLabel.text = @"✔︎";
        _checkLabel.font = [UIFont systemFontOfSize:18];
        [self.contentView addSubview:_checkLabel];
        
        _periodLabel = [[UILabel alloc] init];
        _periodLabel.numberOfLines = 1;
        _periodLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _periodLabel.font = [UIFont systemFontOfSize:18];
        [self.contentView addSubview:_periodLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [self.checkLabel sizeToFit];
    CGFloat checkLabelX = 5;
    CGFloat checkLabelY = self.frame.size.height / 2 - self.checkLabel.frame.size.height / 2;
    self.checkLabel.frame = CGRectMake(checkLabelX, checkLabelY, self.checkLabel.frame.size.width, self.checkLabel.frame.size.height);
    
    [self.periodLabel sizeToFit];
    CGFloat periodLabelX = 25;
    CGFloat periodLabelY = self.frame.size.height / 2 - self.periodLabel.frame.size.height / 2;
    self.periodLabel.frame = CGRectMake(periodLabelX, periodLabelY, self.periodLabel.frame.size.width, self.periodLabel.frame.size.height);
}

- (void)setPeriod:(SPRPeriod *)period
{
    [super setPeriod:period];
    
    self.checkLabel.hidden = !period.isSelected;
    self.periodLabel.text = period.descriptiveForm;
    
    [self setNeedsLayout];
}

@end
