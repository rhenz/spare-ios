//
//  SPREditCategoryViewController.h
//  Spare
//
//  Created by Matt Quiros on 5/16/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SPRCategory;

@interface SPREditCategoryViewController : UITableViewController

- (instancetype)initWithCategory:(SPRCategory *)category;

@end
