//
//  SPRPeriodManager.m
//  Spare
//
//  Created by Matt Quiros on 7/9/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import "SPRPeriodManager.h"

// Objects
#import "SPRPeriod.h"

@interface SPRPeriodManager ()

@property (strong, nonatomic) NSArray *quickDefaults;
@property (strong, nonatomic) NSArray *customDefaults;
@property (strong, nonatomic) NSArray *customPeriod;
@property (strong, nonatomic, readonly) SPRPeriod *selectedPeriod;

@end

@implementation SPRPeriodManager

- (id)init
{
    @throw [NSException exceptionWithName:[NSString stringWithFormat:@"%@ singleton exception", [self class]]
                                   reason:[NSString stringWithFormat:@"You must call [%@ sharedManager].", [self class]]
                                 userInfo:nil];
}

- (instancetype)initPrivate
{
    if (self = [super init]) {
        
    }
    return self;
}

+ (instancetype)sharedManager
{
    static SPRPeriodManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[SPRPeriodManager alloc] initPrivate];
    });
    [sharedManager initializePeriods];
    return sharedManager;
}

- (void)initializePeriods
{
    [self initializeQuickDefaults];
    self.periods = @[self.quickDefaults];
    
    // Select the period at the last active index path.
    // If there is no last active index path, default to Today.
    if (self.activeIndexPath == nil) {
        self.selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        self.activeIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    } else {
        self.selectedIndexPath = self.activeIndexPath;
    }
    self.selectedPeriod.selected = YES;
}

- (void)initializeQuickDefaults
{
    // Get the current date.
    NSDate *currentDate = [NSDate date];
    
    // Set up the arrays for iteration.
    int dateDimensions[] = {SPRDateDimensionDay, SPRDateDimensionWeek, SPRDateDimensionMonth, SPRDateDimensionYear};
    NSArray *descriptiveForms = @[@"Today", @"This week", @"This month", @"This year"];
    
    NSMutableArray *periods = [NSMutableArray array];
    SPRPeriod *period;
    
    for (int i = 0; i < 4; i++) {
        period = [[SPRPeriod alloc] init];
        period.startDate = [currentDate firstMomentInDimension:dateDimensions[i]];
        period.endDate = [currentDate lastMomentInDimension:dateDimensions[i]];
        period.descriptiveForm = descriptiveForms[i];
        [periods addObject:period];
    }
    
    self.quickDefaults = [NSArray arrayWithArray:periods];
}

- (SPRPeriod *)activePeriod
{
    SPRPeriod *activePeriod = self.periods[self.activeIndexPath.section][self.activeIndexPath.row];
    return activePeriod;
}

- (SPRPeriod *)selectedPeriod
{
    SPRPeriod *selectedPeriod = self.periods[self.selectedIndexPath.section][self.selectedIndexPath.row];
    return selectedPeriod;
}

- (void)setSelectedIndexPath:(NSIndexPath *)selectedIndexPath
{
    // Before updating the selected index path, deselect the currently selected period.
    SPRPeriod *oldSelection = self.periods[self.selectedIndexPath.section][self.selectedIndexPath.row];
    oldSelection.selected = NO;
    
    _selectedIndexPath = selectedIndexPath;
    
    SPRPeriod *newSelection = self.periods[selectedIndexPath.section][selectedIndexPath.row];
    newSelection.selected = YES;
}

- (void)save
{
    // Set the selected index path as the active period.
}

@end
