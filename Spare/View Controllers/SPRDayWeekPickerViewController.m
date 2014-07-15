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

@interface SPRDayWeekPickerViewController () <UICollectionViewDataSource, UICollectionViewDelegate, SPRDayWeekPickerNavigationBarDelegate>

@property (strong, nonatomic) SPRDayWeekPickerNavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic) SPRDateUnit dateUnit;
@property (strong, nonatomic) NSDate *preselectedDate;

@property (strong, nonatomic) NSMutableArray *dates;

@end

@implementation SPRDayWeekPickerViewController

- (instancetype)init
{
    @throw [NSException exceptionWithName:[NSString stringWithFormat:@"%@ illegal init", NSStringFromClass([self class])]
                                   reason:@"You must call one of the other init methods." userInfo:nil];
}

- (instancetype)initPrivate
{
    self = [[UIStoryboard storyboardWithName:@"iPhone" bundle:nil] instantiateViewControllerWithIdentifier:@"dayWeekPicker"];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithDateUnit:(SPRDateUnit)dateUnit preselectedDate:(NSDate *)date
{
    if (self = [self initPrivate]) {
        _dateUnit = dateUnit;
        _preselectedDate = date;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationBar = [[SPRDayWeekPickerNavigationBar alloc] init];
    self.navigationBar.delegate = self;
    [self.view addSubview:self.navigationBar];
}

#pragma mark - Collection view data source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return -1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark - Day/week picker navigatin bar delegate

- (void)dayWeekPickerNavigationBarDidTapCancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dayWeekPickerNavigationBarDidTapDone
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
