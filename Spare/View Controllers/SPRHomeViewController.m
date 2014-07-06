//
//  SPRHomeViewController.m
//  Spare
//
//  Created by Matt Quiros on 7/6/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import "SPRHomeViewController.h"

// Custom views
#import "SPRCategoryCollectionViewCell.h"
#import "SPRTotalView.h"

// Objects
#import "SPRCategorySummary.h"
#import "SPRManagedDocument.h"
#import "SPRCategory+Extension.h"

// View controllers
#import "SPRSetupViewController.h"
#import "SPRSliderViewController.h"

// Libraries
#import "UICollectionView+Draggable.h"

// Utilities
#import "SPRIcons.h"

static NSString * const kCellIdentifier = @"Cell";

@interface SPRHomeViewController () <UICollectionViewDataSource_Draggable, UICollectionViewDelegate, NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) SPRTotalView *totalView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) NSMutableArray *summaries;
@property (strong, nonatomic) NSFetchedResultsController *categoryFetcher;
@property (nonatomic) BOOL hasBeenSetup;

@end

@implementation SPRHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupBarButtonItems];
    
    self.totalView = [[SPRTotalView alloc] init];
    self.navigationItem.titleView = self.totalView;
    self.totalView.total = [NSDecimalNumber decimalNumberWithString:@"12345678.90"];
    self.totalView.period = @"Sep 30, 2004 - Sep 30, 2005";
    
    // Set up the collection view.
    self.collectionView.draggable = YES;
    [self.collectionView registerClass:[SPRCategoryCollectionViewCell class] forCellWithReuseIdentifier:kCellIdentifier];
    
    // Prevent the collection view from adjusting the scroll as if the tab bar is still shown.
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.hasBeenSetup) {
        [self initializeSummaries];
        [self.collectionView reloadData];
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

#pragma mark - Bar button items

- (void)setupBarButtonItems
{
    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeSystem];
    NSAttributedString *menuIcon = [[NSAttributedString alloc] initWithString:[SPRIcons characterForIcon:SPRIconMenu] attributes:@{NSFontAttributeName : [UIFont fontWithName:SPRIconFontName size:28]}];
    [menuButton setAttributedTitle:menuIcon forState:UIControlStateNormal];
    [menuButton sizeToFit];
    [menuButton addTarget:self action:@selector(menuButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeSystem];
    NSAttributedString *addIcon = [[NSAttributedString alloc] initWithString:[SPRIcons characterForIcon:SPRIconAdd] attributes:@{NSFontAttributeName : [UIFont fontWithName:SPRIconFontName size:23]}];
    [addButton setAttributedTitle:addIcon forState:UIControlStateNormal];
    [addButton sizeToFit];
    [addButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:addButton];
}

- (void)menuButtonTapped
{
    [self.sliderViewController showMenu];
}

#pragma mark - Collection view data source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.summaries count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SPRCategoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    SPRCategorySummary *summary = self.summaries[indexPath.row];
    cell.category = summary.category;
    cell.displayedTotal = [summary totalForTimeFrame:SPRTimeFrameDay];
    
    return cell;
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
    _categoryFetcher.delegate = self;
    
    return _categoryFetcher;
}

@end
