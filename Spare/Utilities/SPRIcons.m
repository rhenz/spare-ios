//
//  SPRIcons.m
//  Spare
//
//  Created by Matt Quiros on 7/7/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import "SPRIcons.h"

NSString * const SPRIconFontName = @"spare-icons";

NSString * const SPRIconHome = @"SPRIconHome";
NSString * const SPRIconDrafts = @"SPRIconDrafts";
NSString * const SPRIconSettings = @"SPRIconSettings";
NSString * const SPRIconMenu = @"SPRIconMenu";
NSString * const SPRIconAdd = @"SPRIconAdd";
NSString * const SPRIconMove = @"SPRIconMove";
NSString * const SPRIconEdit = @"SPRIconEdit";

@implementation SPRIcons

+ (NSString *)characterForIcon:(NSString *)icon
{
    return [@{SPRIconHome : @"a",
              SPRIconDrafts : @"b",
              SPRIconSettings : @"c",
              SPRIconMenu : @"d",
              SPRIconAdd : @"e",
              SPRIconMove : @"f",
              SPRIconEdit : @"g"} objectForKey:icon];
}

@end
