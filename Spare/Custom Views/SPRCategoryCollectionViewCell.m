//
//  SPRCategoryCollectionViewCell.m
//  Spare
//
//  Created by Matt Quiros on 4/7/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import "SPRCategoryCollectionViewCell.h"

// Categories
#import "UIColor+HexColor.h"

// Objects
#import "SPRCategory+Extension.h"

static const CGFloat kCellWidth = 145;
static const CGFloat kInnerMargin = 5;
static const CGFloat kLabelWidth = kCellWidth - kInnerMargin * 2;

@interface SPRCategoryCollectionViewCell ()

@property (strong, nonatomic) UILabel *categoryLabel;
@property (strong, nonatomic) UILabel *totalLabel;

@end

@implementation SPRCategoryCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _categoryLabel = [[UILabel alloc] init];
        _categoryLabel.textColor = [UIColor colorFromHex:0x3b3b3b];
        _categoryLabel.font = [UIFont systemFontOfSize:17];
        _categoryLabel.numberOfLines = 4;
        _categoryLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        
        _totalLabel = [[UILabel alloc] init];
        _totalLabel.textColor = [UIColor colorFromHex:0x3b3b3b];
        _totalLabel.font = [UIFont systemFontOfSize:22];
        _totalLabel.numberOfLines = 1;
        _totalLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _totalLabel.textAlignment = NSTextAlignmentRight;
        _totalLabel.text = @"P1,289.50";
        
        [self.contentView addSubview:_categoryLabel];
        [self.contentView addSubview:_totalLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [self.categoryLabel sizeToFitWidth:kLabelWidth];
    self.categoryLabel.frame = CGRectMake(kInnerMargin, kInnerMargin, kLabelWidth, self.categoryLabel.frame.size.height);
    
    [self.totalLabel sizeToFitWidth:kLabelWidth];
    CGFloat totalLabelY = self.frame.size.height - kInnerMargin - self.totalLabel.frame.size.height;
    self.totalLabel.frame = CGRectMake(kInnerMargin, totalLabelY, kLabelWidth, self.totalLabel.frame.size.height);
}

- (void)setCategory:(SPRCategory *)category
{
    _category = category;
    
    self.categoryLabel.text = category.name;
    self.backgroundColor = [SPRCategory colors][[category.colorNumber integerValue]];
    
    [self setNeedsLayout];
}

- (void)setDisplayedTotal:(NSDecimalNumber *)displayedTotal
{
    _displayedTotal = displayedTotal;
    self.totalLabel.text = [displayedTotal currencyString];
}

@end
