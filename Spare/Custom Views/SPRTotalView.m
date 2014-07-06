//
//  SPRTotalView.m
//  Spare
//
//  Created by Matt Quiros on 7/7/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import "SPRTotalView.h"

@interface SPRTotalView ()

@property (strong, nonatomic) UILabel *totalLabel;
@property (strong, nonatomic) UILabel *periodLabel;

@end

static const CGFloat kWidth = 212;

@implementation SPRTotalView

- (id)init
{
    self = [super init];
    if (self) {
        _totalLabel = [[UILabel alloc] init];
        _totalLabel.numberOfLines = 1;
        _totalLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _totalLabel.textColor = [UIColor blackColor];
        _totalLabel.font = [UIFont boldSystemFontOfSize:18];
        _totalLabel.textAlignment = NSTextAlignmentCenter;
        
        _periodLabel = [[UILabel alloc] init];
        _periodLabel.numberOfLines = 1;
        _periodLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _periodLabel.textColor = [UIColor grayColor];
        _periodLabel.font = [UIFont systemFontOfSize:11];
        _periodLabel.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:_totalLabel];
        [self addSubview:_periodLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [self.totalLabel sizeToFitWidth:kWidth];
    [self.periodLabel sizeToFitWidth:kWidth];
    
    self.totalLabel.frame = CGRectMake(0, 0, kWidth, self.totalLabel.frame.size.height);
    self.periodLabel.frame = CGRectMake(0, self.totalLabel.frame.size.height, kWidth, self.periodLabel.frame.size.height);
    
    self.frame = CGRectMake(58, 6, kWidth, self.totalLabel.frame.size.height + self.periodLabel.frame.size.height);
}

- (void)setTotal:(NSDecimalNumber *)total
{
    _total = total;
    self.totalLabel.text = [total currencyString];
    [self setNeedsLayout];
}

- (void)setPeriod:(NSString *)period
{
    _period = period;
    self.periodLabel.text = period;
    [self setNeedsLayout];
}

#pragma mark - Button highlight

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [UIView animateWithDuration:0.1 animations:^{
        self.alpha = 0.3;
    }];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [UIView animateWithDuration:0.1 animations:^{
        self.alpha = 1;
    }];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [UIView animateWithDuration:0.1 animations:^{
        self.alpha = 1;
    }];
}

@end
