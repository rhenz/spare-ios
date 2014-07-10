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

@interface SPRPeriodViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) SPRPeriodManager *periodManager;

@end

static NSString * const kQuickDefaultCell = @"kQuickDefaultCell";
static NSString * const kCustomDefaultCell = @"kCustomDefaultCell";

static NSArray *identifiers;

@implementation SPRPeriodViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set up the static arrays.
    identifiers = @[kQuickDefaultCell, kCustomDefaultCell];
    
    self.periodManager = [SPRPeriodManager sharedManager];
    
    // Register table view cells.
    [self.tableView registerClass:[SPRQuickDefaultCell class] forCellReuseIdentifier:kQuickDefaultCell];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCustomDefaultCell];
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
    NSString *identifier = kQuickDefaultCell;
    
    SPRPeriodTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.period = period;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.periodManager.selectedIndexPath = indexPath;
    [self.tableView reloadData];
    
    // Select and deselect the cell.
    [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // Save the period manager and dismiss the screen.
    [self.periodManager save];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
