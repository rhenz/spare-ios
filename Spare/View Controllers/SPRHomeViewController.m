//
//  SPRHomeViewController.m
//  Spare
//
//  Created by Matt Quiros on 7/6/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import "SPRHomeViewController.h"

// Custom views
#import "SPRTotalView.h"
#import "SPRCategorySummaryCell.h"
#import "SPRNewCategoryCell.h"

// Objects
#import "SPRCategorySummary.h"
#import "SPRManagedDocument.h"
#import "SPRCategory+Extension.h"
#import "SPRPeriodManager.h"

// View controllers
#import "SPRSetupViewController.h"
#import "SPRSliderViewController.h"
#import "SPRCategoryViewController.h"

// Libraries
#import "UICollectionView+Draggable.h"

// Utilities
#import "SPRIcons.h"

static NSString * const kCellIdentifier = @"Cell";
static NSString * const kNewCategoryCellIdentifier = @"NewCategoryCell";

@interface SPRHomeViewController () <UICollectionViewDataSource_Draggable, UICollectionViewDelegate>

@property (strong, nonatomic) SPRTotalView *totalView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) NSMutableArray *summaries;
@property (strong, nonatomic) NSFetchedResultsController *categoryFetcher;
@property (nonatomic) BOOL hasBeenSetup;
@property (nonatomic) NSInteger selectedCategoryIndex;

@end

@implementation SPRHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupBarButtonItems];
    
    self.totalView = [[SPRTotalView alloc] init];
    self.navigationItem.titleView = self.totalView;
    [self.totalView addTarget:self action:@selector(totalViewTapped) forControlEvents:UIControlEventTouchUpInside];
    
    // Set up the collection view.
    self.collectionView.draggable = YES;
    [self.collectionView registerClass:[SPRCategorySummaryCell class] forCellWithReuseIdentifier:kCellIdentifier];
    [self.collectionView registerClass:[SPRNewCategoryCell class] forCellWithReuseIdentifier:kNewCategoryCellIdentifier];
    
    // Prevent the collection view from adjusting the scroll as if the tab bar is still shown.
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.hasBeenSetup) {
        [self initializeSummaries];
        [self.collectionView reloadData];
        [self updateTotalView];
    }
    
    // If the screen has not been set up yet, display a loading modal.
    else {
        SPRSetupViewController *setupScreen = [[UIStoryboard storyboardWithName:@"iPhone" bundle:nil] instantiateViewControllerWithIdentifier:@"Setup"];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:setupScreen];
        navigationController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:navigationController animated:NO completion:nil];
        self.hasBeenSetup = YES;
    }
}

- (void)initializeSummaries
{
    self.summaries = [NSMutableArray array];
    
    NSError *error;
    [self.categoryFetcher performFetch:&error];
    if (error) {
        NSLog(@"Error fetching categories: %@", error);
    }
    
    for (SPRCategory *category in self.categoryFetcher.fetchedObjects) {
        [self.summaries addObject:[[SPRCategorySummary alloc] initWithCategory:category]];
    }
}

- (void)totalViewTapped
{
    [self performSegueWithIdentifier:@"presentPeriod" sender:self];
}

- (void)updateTotalView
{
    NSDecimalNumber *total = [NSDecimalNumber decimalNumberWithString:@"0"];
    NSDecimalNumber *singleTotal;
    SPRPeriod *activePeriod = [SPRPeriodManager sharedManager].activePeriod;
    
    for (SPRCategorySummary *summary in self.summaries) {
        singleTotal = [summary totalForPeriod:activePeriod];
        total = [total decimalNumberByAdding:singleTotal];
    }
    
    self.totalView.total = total;
    self.totalView.period = [SPRPeriodManager sharedManager].activePeriod;

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"pushCategory"]) {
        SPRCategoryViewController *categoryScreen = segue.destinationViewController;
        SPRCategorySummary *summary = self.summaries[self.selectedCategoryIndex];
        categoryScreen.category = summary.category;
        return;
    }
}

#pragma mark - Bar button items

- (void)setupBarButtonItems
{
    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeSystem];
    NSAttributedString *menuIcon = [[NSAttributedString alloc] initWithString:[SPRIcons characterForIcon:SPRIconMenu] attributes:@{NSFontAttributeName : [UIFont fontWithName:SPRIconFontName size:28]}];
    [menuButton setAttributedTitle:menuIcon forState:UIControlStateNormal];
    [menuButton sizeToFit];
    [menuButton addTarget:self action:@selector(menuButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    
    UIBarButtonItem *newExpenseButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(newExpenseButtonTapped)];
    self.navigationItem.rightBarButtonItem = newExpenseButton;
}

- (void)menuButtonTapped
{
    [self.sliderViewController showMenu];
}

- (void)newExpenseButtonTapped
{
    UINavigationController *newExpenseModal = [[UIStoryboard storyboardWithName:@"iPhone" bundle:nil] instantiateViewControllerWithIdentifier:@"NewExpenseModal"];
    [self presentViewController:newExpenseModal animated:YES completion:nil];
}

#pragma mark - Collection view data source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.summaries count] + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // If the cell is the last one, make it the New Category cell.
    if (indexPath.row == [self.summaries count]) {
        SPRNewCategoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kNewCategoryCellIdentifier forIndexPath:indexPath];
        return cell;
    }
    
    // Otherwise, make it a category summary cell.
    SPRCategorySummaryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    SPRCategorySummary *summary = self.summaries[indexPath.row];
    cell.category = summary.category;
    
    SPRPeriod *activePeriod = [SPRPeriodManager sharedManager].activePeriod;
    cell.displayedTotal = [summary totalForPeriod:activePeriod];
    
    return cell;
}

#pragma mark - Collection view delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.summaries.count) {
        [self performSegueWithIdentifier:@"presentNewCategory" sender:self];
        return;
    }
    
    self.selectedCategoryIndex = indexPath.row;
    [self performSegueWithIdentifier:@"pushCategory" sender:self];
}

#pragma mark - Draggable collection view data source

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    // Move the summary's location in the array.
    SPRCategorySummary *summary = self.summaries[fromIndexPath.row];
    [self.summaries removeObject:summary];
    [self.summaries insertObject:summary atIndex:toIndexPath.row];
    
    // Reassign the display order of categories.
    for (int i = 0; i < self.summaries.count; i++) {
        summary = self.summaries[i];
        summary.category.displayOrder = @(i);
    }
    
    // Persist the reordering into the managed document.
    SPRManagedDocument *document = [SPRManagedDocument sharedDocument];
    [document saveToURL:document.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:nil];
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.summaries.count) {
        return NO;
    }
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    if (toIndexPath.row == self.summaries.count) {
        return NO;
    }
    return YES;
}

- (CGAffineTransform)collectionView:(UICollectionView *)collectionView transformForDraggingItemAtIndexPath:(NSIndexPath *)indexPath duration:(NSTimeInterval *)duration
{
    return CGAffineTransformMakeScale(1.15, 1.15);
}

#pragma mark - Lazy initializers

- (NSFetchedResultsController *)categoryFetcher
{
    if (_categoryFetcher) {
        return _categoryFetcher;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:NSStringFromClass([SPRCategory class]) inManagedObjectContext:[SPRManagedDocument sharedDocument].managedObjectContext];
    fetchRequest.entity = entityDescription;
    
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"displayOrder" ascending:YES]];
    
    _categoryFetcher = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[SPRManagedDocument sharedDocument].managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    return _categoryFetcher;
}

@end
