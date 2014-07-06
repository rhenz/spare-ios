//
//  SPRSliderViewController.m
//  Spare
//
//  Created by Matt Quiros on 7/6/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import "SPRSliderViewController.h"

@interface SPRSliderViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITabBarController *content;
@property (strong, nonatomic) UITableView *menu;

@property (strong, nonatomic) NSArray *menuOptions;

@end

static const CGFloat kContentOffsetLimit = 250;
static const CGFloat kMenuCellHeight = 50;
static const NSInteger kMinimumTranslation = 100;

static NSString * const kMenuCell = @"Cell";

static CGPoint contentOrigin;
static BOOL rightPanBeganInContent;

@implementation SPRSliderViewController

- (id)init
{
    self = [super init];
    if (self) {
        _content = [[UIStoryboard storyboardWithName:@"iPhone" bundle:nil] instantiateViewControllerWithIdentifier:@"Content"];
        _content.tabBar.hidden = YES;
        
        _menuOptions = @[@"Home", @"Drafts", @"Settings"];
        
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
        CGFloat menuHeight = kMenuCellHeight * [_menuOptions count];
        CGFloat menuY = screenHeight / 2 - menuHeight / 2;
        
        _menu = [[UITableView alloc] initWithFrame:CGRectMake(0, menuY, kContentOffsetLimit, menuHeight) style:UITableViewStylePlain];
        _menu.backgroundColor = [UIColor clearColor];
        _menu.separatorColor = [UIColor clearColor];
        _menu.scrollEnabled = NO;
        _menu.dataSource = self;
        _menu.delegate = self;
        [_menu registerClass:[UITableViewCell class] forCellReuseIdentifier:kMenuCell];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor darkGrayColor];
    
    // Add the menu.
    [self.view addSubview:self.menu];
    
    // Add the content.
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
    if (translation.x <= -kMinimumTranslation / 2) {
        [self hideMenu];
    } else {
        [self showMenu];
    }
}

- (void)showMenu
{
    self.content.view.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.2 animations:^{
        self.content.view.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, kContentOffsetLimit, 0);
    } completion:^(BOOL finished) {
        self.menu.userInteractionEnabled = YES;
    }];
}

- (void)hideMenu
{
    self.menu.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.2 animations:^{
        self.content.view.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0);
    } completion:^(BOOL finished) {
        self.content.view.userInteractionEnabled = YES;
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.menuOptions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kMenuCell];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = self.menuOptions[indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont systemFontOfSize:20];
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kMenuCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.content.selectedIndex = indexPath.row;
    
    [self hideMenu];
}

@end
