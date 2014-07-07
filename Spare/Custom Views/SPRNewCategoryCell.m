//
//  SPRNewCategoryCell.m
//  Spare
//
//  Created by Matt Quiros on 7/7/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import "SPRNewCategoryCell.h"

// Utilities
#import "SPRIcons.h"

@interface SPRNewCategoryCell ()

@property (strong, nonatomic) UILabel *label;

@end

@implementation SPRNewCategoryCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _label = [[UILabel alloc] init];
        _label.numberOfLines = 2;
        _label.textAlignment = NSTextAlignmentCenter;
        
        // Build the attributed string.
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"+" attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:30]}];
        [text appendAttributedString:[[NSAttributedString alloc] initWithString:@"\nNew category" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]}]];
        
        _label.attributedText = text;
        [self.contentView addSubview:_label];
        
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.borderWidth = 1.0;
    }
    return self;
}

- (void)layoutSubviews
{
    [self.label sizeToFit];
    
    // Center the label.
    CGFloat x = self.frame.size.width / 2 - self.label.frame.size.width / 2;
    CGFloat y = self.frame.size.height / 2 - self.label.frame.size.height / 2;
    self.label.frame = CGRectMake(x, y, self.label.frame.size.width, self.label.frame.size.height);
}

@end
