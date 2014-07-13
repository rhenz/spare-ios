//
//  SPRDayWeekPickerViewController.m
//  Spare
//
//  Created by Matt Quiros on 7/12/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import "SPRDayWeekPickerViewController.h"

// Custom views
#import "SPRDayWeekPickerNavigationBar.h"

@interface SPRDayWeekPickerViewController () <SPRDayWeekPickerNavigationBarDelegate>

@property (strong, nonatomic) SPRDayWeekPickerNavigationBar *navigationBar;

@end

@implementation SPRDayWeekPickerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.navigationController.navigationBar.barTintColor = [UIColor redColor];
//    
//    NSArray *subviews = self.navigationController.navigationBar.subviews;
//    for (UIView *subview in subviews) {
//        NSLog(@"%@ : %@", NSStringFromClass([subview class]), NSStringFromCGRect(subview.frame));
//    }
//    
//    NSLog(@"%@ : %@", NSStringFromClass([self.navigationItem.titleView class]), NSStringFromCGRect(self.navigationItem.titleView.frame));
    
    self.navigationBar = [[SPRDayWeekPickerNavigationBar alloc] init];
    self.navigationBar.delegate = self;
    [self.view addSubview:self.navigationBar];
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//}

- (void)dayWeekPickerNavigationBarDidTapCancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dayWeekPickerNavigationBarDidTapDone
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
