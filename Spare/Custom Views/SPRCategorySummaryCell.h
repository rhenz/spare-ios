//
//  SPRCategoryCollectionViewCell.h
//  Spare
//
//  Created by Matt Quiros on 4/7/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SPRCategory;

@interface SPRCategorySummaryCell : UICollectionViewCell

@property (weak, nonatomic) SPRCategory *category;
@property (strong, nonatomic) NSDecimalNumber *displayedTotal;

@end
