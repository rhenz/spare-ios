//
//  SPRCalendarPickerViewController.m
//  Spare
//
//  Created by Matt Quiros on 7/12/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import "SPRCalendarPickerViewController.h"

// Custom views
#import "SPRCalendarPickerNavigationBar.h"
#import "SPRCalendarPickerCollectionViewCell.h"

// Objects
#import "SPRDate.h"

@interface SPRCalendarPickerViewController () <UICollectionViewDataSource, UICollectionViewDelegate, SPRCalendarPickerNavigationBarDelegate>

@property (strong, nonatomic) SPRCalendarPickerNavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic) SPRDateUnit dateUnit;
@property (strong, nonatomic) SPRDate *preselectedDate;

@property (strong, nonatomic) NSMutableArray *dates;

@end

static NSString * const kCellIdentifier = @"Cell";

@implementation SPRCalendarPickerViewController

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

- (instancetype)initWithDateUnit:(SPRDateUnit)dateUnit preselectedDate:(SPRDate *)date
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
    
    self.navigationBar = [[SPRCalendarPickerNavigationBar alloc] init];
    self.navigationBar.delegate = self;
    [self.view addSubview:self.navigationBar];
    
    // Initialize the arrays of date components.
    [self initializeDates];
    
    // Register a collection view cell class.
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([SPRCalendarPickerCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:kCellIdentifier];
}

- (void)initializeDates
{
    self.dates = [NSMutableArray array];
    
    // Create the dates from three months before the preselected date to
    // three months after the preselected date.
    SPRDate *month;
    NSInteger numberOfDays;
    NSMutableArray *daysInMonth;
    for (int i = -3; i <= 3; i++) {
        month = [self.preselectedDate monthAwayByNumberOfMonths:i];
        daysInMonth = [NSMutableArray array];
        
        // Populate the array with NSNull to move the first day to the correct column.
        for (int j = 1; j < month.weekday; j++) {
            [daysInMonth addObject:[NSNull null]];
        }
        
        // Add the days.
        numberOfDays = [month numberOfDaysInMonth];
        for (int j = 1; j <= numberOfDays; j++) {
            [daysInMonth addObject:[[SPRDate alloc] initWithMonth:month.month day:j year:month.year]];
        }
        
        // Add the array of days in the month to the main dates array.
        [self.dates addObject:[NSArray arrayWithArray:daysInMonth]];
    }
}

#pragma mark - Collection view data source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [self.dates count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *daysInMonth = self.dates[section];
    return [daysInMonth count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *days = self.dates[indexPath.section];
    id element = days[indexPath.row];
    
    if ([element isKindOfClass:[SPRDate class]]) {
        SPRCalendarPickerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
        cell.date = [self.dates[indexPath.section] objectAtIndex:indexPath.row];
        return cell;
    }
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"kEmptyCell" forIndexPath:indexPath];
    return cell;
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
