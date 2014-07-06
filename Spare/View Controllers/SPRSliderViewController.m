//
//  SPRSliderViewController.m
//  Spare
//
//  Created by Matt Quiros on 7/6/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import "SPRSliderViewController.h"

@interface SPRSliderViewController ()

@property (strong, nonatomic) UITabBarController *content;

@end

static const CGFloat kContentOffsetLimit = 250;
static const NSInteger kMinimumTranslation = 100;

static CGPoint contentOrigin;
static BOOL rightPanBeganInContent;

@implementation SPRSliderViewController

- (id)init
{
    self = [super init];
    if (self) {
        _content = [[UIStoryboard storyboardWithName:@"iPhone" bundle:nil] instantiateViewControllerWithIdentifier:@"Content"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor darkGrayColor];
    
    [self addChildViewController:self.content];
    [self.view addSubview:self.content.view];
    [self.content didMoveToParentViewController:self];
    
    // Add gesture recognizers.
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    panGesture.maximumNumberOfTouches = 1;
    [self.view addGestureRecognizer:panGesture];
}

#pragma mark - Pan gesture actions

- (void)handlePanGesture:(UIPanGestureRecognizer *)panGesture
{
    CGPoint touchPoint = [panGesture locationInView:self.view];
    
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        // If the gesture began outside the content's frame, do nothing.
        if (!CGRectContainsPoint(self.content.view.frame, touchPoint)) {
            rightPanBeganInContent = NO;
            return;
        }
        
        contentOrigin = self.content.view.frame.origin;
        rightPanBeganInContent = YES;
    }
    
    // Translate the content based on the pan gesture.
    // Only translate the content if the pan gesture began within it.
    else if (panGesture.state == UIGestureRecognizerStateChanged && rightPanBeganInContent == YES) {
        CGPoint translation = [panGesture translationInView:self.view];
        CGFloat offset = contentOrigin.x + translation.x;
        
        // Disallow translation beyond the left edge and the content offset limit.
        if (offset > kContentOffsetLimit) {
            return;
        } else if (offset < 0) {
            offset = 0;
        }
        
        self.content.view.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, offset, 0);
    }
    
    else if (panGesture.state == UIGestureRecognizerStateEnded && rightPanBeganInContent == YES) {
        CGPoint velocity = [panGesture velocityInView:self.view];
        if (velocity.x > 0) {
            [self panRight:panGesture];
        } else {
            [self panLeft:panGesture];
        }
        
        rightPanBeganInContent = NO;
    }
}

- (void)panRight:(UIPanGestureRecognizer *)panGesture
{
    CGPoint translation = [panGesture translationInView:self.view];
    CGFloat offset = contentOrigin.x + translation.x;
    
    // If the pan distance is big enough, lock the content to the right.
    if (offset >= kMinimumTranslation) {
        [self showMenu];
    } else {
        [self hideMenu];
    }
}

- (void)panLeft:(UIPanGestureRecognizer *)panGesture
{
    CGPoint translation = [panGesture translationInView:self.view];
    
    // If the pan distance is big enough, lock the content to the left.
    if (translation.x <= -kMinimumTranslation) {
        [self hideMenu];
    } else {
        [self showMenu];
    }
}

- (void)showMenu
{
    [UIView animateWithDuration:0.25 animations:^{
        self.content.view.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, kContentOffsetLimit, 0);
    }];
}

- (void)hideMenu
{
    [UIView animateWithDuration:0.25 animations:^{
        self.content.view.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0);
    }];
}

@end
