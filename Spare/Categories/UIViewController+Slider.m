//
//  UIViewController+Slider.m
//  Spare
//
//  Created by Matt Quiros on 7/6/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import "UIViewController+Slider.h"

@implementation UIViewController (Slider)

- (SPRSliderViewController *)sliderViewController
{
    SPRSliderViewController *sliderViewController = (SPRSliderViewController *)self.tabBarController.parentViewController;
    return sliderViewController;
}

@end
