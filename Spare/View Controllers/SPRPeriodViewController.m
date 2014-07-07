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

@interface SPRPeriodViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

static NSString * const kQuickDefaultCell = @"kQuickDefaultCell";
static NSString * const kCustomDefaultCell = @"kCustomDefaultCell";
static NSString * const kCustomPeriodCell = @"kCustomPeriodCell";

static NSArray *identifiers;
static NSArray *quickDefaults;

@implementation SPRPeriodViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set up the static arrays.
    identifiers = @[kQuickDefaultCell, kCustomDefaultCell];
    quickDefaults = [SPRPeriod quickDefaults];
}

#pragma mark - Target actions

- (IBAction)cancelButtonTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doneButtonTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [identifiers count] + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SPRPeriod *period = quickDefaults[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kQuickDefaultCell];
    cell.textLabel.text = period.descriptiveForm;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
