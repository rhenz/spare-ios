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

// Macros
#define pathToFile(A) [[SPRPeriodManager pathToPeriodManagerDirectory] stringByAppendingPathComponent:A]

@interface SPRPeriodManager ()

@property (strong, nonatomic) NSArray *quickDefaults;
@property (strong, nonatomic) NSArray *customDefaults;
@property (strong, nonatomic) NSArray *customPeriod;
@property (strong, nonatomic, readonly) SPRPeriod *selectedPeriod;

@end

static NSString * const kActiveIndexPathFile = @"kActiveIndexPathFile";
static NSString * const kCustomDefaultsFile = @"kCustomDefaultsFile";

@implementation SPRPeriodManager

+ (NSString *)pathToPeriodManagerDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString *path = [paths[0] stringByAppendingPathComponent:@"SPRPeriodManager"];
    
    // Make sure that the path exists before returning it.
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path]) {
        NSError *error;
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            NSLog(@"%@", error);
        }
    }
    
    return path;
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

- (instancetype)initPrivate
{
    if (self = [super init]) {
        
    }
    return self;
}

- (id)init
{
    @throw [NSException exceptionWithName:[NSString stringWithFormat:@"%@ singleton exception", [self class]]
                                   reason:[NSString stringWithFormat:@"You must call [%@ sharedManager].", [self class]]
                                 userInfo:nil];
}

- (void)initializePeriods
{
    [self initializeQuickDefaults];
    [self initializeCustomDefaults];
    self.periods = @[self.quickDefaults, self.customDefaults];
    
    // Select the period at the last active index path.
    // If there is no last active index path, default to Today.
    self.activeIndexPath = [NSKeyedUnarchiver unarchiveObjectWithFile:pathToFile(kActiveIndexPathFile)];
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
    int dateUnits[] = {SPRDateUnitDay, SPRDateUnitWeek, SPRDateUnitMonth, SPRDateUnitYear};
    NSArray *descriptiveForms = @[@"Today", @"This week", @"This month", @"This year"];
    
    NSMutableArray *periods = [NSMutableArray array];
    SPRPeriod *period;
    
    for (int i = 0; i < 4; i++) {
        period = [[SPRPeriod alloc] init];
        period.startDate = [currentDate firstMomentInDateUnit:dateUnits[i]];
        period.endDate = [currentDate lastMomentInDateUnit:dateUnits[i]];
        period.dateUnit = dateUnits[i];
        period.descriptiveForm = descriptiveForms[i];
        [periods addObject:period];
    }
    
    self.quickDefaults = [NSArray arrayWithArray:periods];
}

- (void)initializeCustomDefaults
{
    NSDictionary *dates = [NSKeyedUnarchiver unarchiveObjectWithFile:pathToFile(kCustomDefaultsFile)];
    
    int dateUnits[] = {SPRDateUnitDay, SPRDateUnitWeek, SPRDateUnitMonth, SPRDateUnitYear};
    NSMutableArray *periods = [NSMutableArray array];
    SPRPeriod *period;
    
    for (int i = 0; i < 4; i++) {
        period = [[SPRPeriod alloc] init];
        period.dateUnit = dateUnits[i];
        
        // Set the start and the end dates if they have been set by the user before.
        if (dates[@(period.dateUnit)]) {
            NSDictionary *values = dates[@(period.dateUnit)];
            period.startDate = values[@"startDate"];
            period.endDate = values[@"endDate"];
        }
        
        [periods addObject:period];
    }
    
    self.customDefaults = [NSArray arrayWithArray:periods];
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
    self.activeIndexPath = self.selectedIndexPath;
    
    // Save the active index path.
    [NSKeyedArchiver archiveRootObject:self.activeIndexPath toFile:pathToFile(kActiveIndexPathFile)];
    
    // Save the dates selected in the custom defaults.
    [self saveCustomDefaultDates];
}

- (void)saveCustomDefaultDates
{
    NSMutableDictionary *dates = [NSMutableDictionary dictionary];
    for (SPRPeriod *period in self.customDefaults) {
        if (period.startDate && period.endDate) {
            dates[@(period.dateUnit)] = @{@"startDate" : period.startDate,
                                          @"endDate" : period.endDate};
        }
    }
    
    // Write an immutable version of the dictionary to the disk.
    [NSKeyedArchiver archiveRootObject:[NSDictionary dictionaryWithDictionary:dates] toFile:pathToFile(kCustomDefaultsFile)];
}

@end
