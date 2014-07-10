//
//  SPRPeriodViewController.m
//  Spare
//
//  Created by Matt Quiros on 7/7/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import "SPRPeriodViewController.h"

// Objects
#import "SPRPeriod.h"
#import "SPRPeriodManager.h"

// Custom views
#import "SPRPeriodTableViewCell.h"
#import "SPRQuickDefaultCell.h"
#import "SPRDatePicker.h"

@interface SPRPeriodViewController () <UITableViewDataSource, UITableViewDelegate, SPRDatePickerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) SPRPeriodManager *periodManager;

@end

static NSString * const kQuickDefaultCell = @"kQuickDefaultCell";
static NSString * const kCustomDefaultCell = @"kCustomDefaultCell";

static const NSInteger kDatePickerTagDay = 1000;

static NSArray *identifiers;

@implementation SPRPeriodViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set up the static arrays.
    identifiers = @[kQuickDefaultCell, kCustomDefaultCell];
    
    self.periodManager = [SPRPeriodManager sharedManager];
}

#pragma mark - Target actions

- (IBAction)cancelButtonTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [identifiers count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        case 1: {
            return 4;
        }
        case 2: {
            return 1;
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SPRPeriod *period = self.periodManager.periods[indexPath.section][indexPath.row];
    NSString *identifier = identifiers[indexPath.section];
    
    SPRPeriodTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.period = period;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0: {
            self.periodManager.selectedIndexPath = indexPath;
            [self.tableView reloadData];
            
            // Select and deselect the cell.
            [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
            
            // Save the period manager and dismiss the screen.
            [self.periodManager save];
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        }
        case 1: {
            // If the period does not have a start and end date,
            // display a date picker. Otherwise, consider the period selected.
            SPRPeriod *period = self.periodManager.periods[indexPath.section][indexPath.row];
            if (period.startDate == nil && period.endDate == nil) {
                switch (period.dateUnit) {
                    case SPRDateUnitDay: {
                        SPRDatePicker *datePicker = [[SPRDatePicker alloc] initWithFrame:[UIScreen mainScreen].bounds];
                        datePicker.delegate = self;
                        datePicker.preselectedDate = [NSDate date];
                        datePicker.tag = kDatePickerTagDay;
                        [self.navigationController.view addSubview:datePicker];
                        [datePicker show];
                        break;
                    }
                    case SPRDateUnitWeek: {
                        break;
                    }
                    case SPRDateUnitMonth: {
                        break;
                    }
                    case SPRDateUnitYear: {
                        break;
                    }
                    default: {
                        break;
                    }
                }
            } else {
                self.periodManager.selectedIndexPath = indexPath;
                // Save the period manager and dismiss the screen.
                [self.periodManager save];
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            break;
        }
    }
}

#pragma mark - Date picker delegate

- (void)datePicker:(SPRDatePicker *)datePicker didSelectDate:(NSDate *)date
{
    switch (datePicker.tag) {
        case kDatePickerTagDay: {
            SPRPeriod *dayPeriod = self.periodManager.periods[1][0];
            dayPeriod.startDate = [date firstMomentInDateUnit:SPRDateUnitDay];
            dayPeriod.endDate = [date lastMomentInDateUnit:SPRDateUnitDay];
            
            NSIndexPath *dayPeriodIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
            [self.tableView reloadRowsAtIndexPaths:@[dayPeriodIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView selectRowAtIndexPath:dayPeriodIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            break;
        }
    }
}

- (void)datePickerWillDisappear:(SPRDatePicker *)datePicker
{
    NSIndexPath *indexPath;
    switch (datePicker.tag) {
        case kDatePickerTagDay: {
            indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
            break;
        }
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
