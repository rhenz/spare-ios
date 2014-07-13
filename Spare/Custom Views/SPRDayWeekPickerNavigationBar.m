//
//  SPRDayWeekPickerNavigationBar.m
//  Spare
//
//  Created by Matt Quiros on 7/13/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import "SPRDayWeekPickerNavigationBar.h"

@interface SPRDayWeekPickerNavigationBar () <UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *weekHeader;

@property (strong, nonatomic) NSArray *headers;

@end

@interface SPRWeekHeaderCell : UICollectionViewCell

@property (strong, nonatomic) UILabel *dayLabel;

@end

static NSString * const kWeekHeaderCellIdentifier = @"Cell";

@implementation SPRDayWeekPickerNavigationBar

- (instancetype)init
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"SPRDayWeekPickerNavigationBar" owner:nil options:nil] firstObject];
    if (self) {
        self.frame = CGRectMake(0, 0, 320, 80);
        _headers = @[@"S", @"M", @"T", @"W", @"T", @"F", @"S"];
    }
    return self;
}

- (void)awakeFromNib
{
    [self.weekHeader registerClass:[SPRWeekHeaderCell class] forCellWithReuseIdentifier:kWeekHeaderCellIdentifier];
    
    // Add a fake separator at the bottom of the navigation bar.
    UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 0.5, self.frame.size.width, 0.5)];
    separatorView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:separatorView];
}

#pragma mark - Target actions

- (IBAction)cancelButtonTapped:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(dayWeekPickerNavigationBarDidTapCancel)]) {
        [self.delegate dayWeekPickerNavigationBarDidTapCancel];
    }
}

- (IBAction)doneButtonTapped:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(dayWeekPickerNavigationBarDidTapDone)]) {
        [self.delegate dayWeekPickerNavigationBarDidTapDone];
    }
}

#pragma mark - Date header data source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 7;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SPRWeekHeaderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kWeekHeaderCellIdentifier forIndexPath:indexPath];
    cell.dayLabel.text = self.headers[indexPath.row];
    return cell;
}

@end

#pragma mark - Collection view cell class

@implementation SPRWeekHeaderCell

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // Make the label the same size as the cell.
        _dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _dayLabel.font = [UIFont systemFontOfSize:11];
        _dayLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_dayLabel];
    }
    return self;
}

@end
