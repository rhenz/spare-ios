//
//  SPRIcons.h
//  Spare
//
//  Created by Matt Quiros on 7/7/14.
//  Copyright (c) 2014 Matt Quiros. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const SPRIconFontName;

extern NSString * const SPRIconHome;
extern NSString * const SPRIconDrafts;
extern NSString * const SPRIconSettings;
extern NSString * const SPRIconMenu;
extern NSString * const SPRIconAdd;
extern NSString * const SPRIconMove;
extern NSString * const SPRIconEdit;

@interface SPRIcons : NSObject

+ (NSString *)characterForIcon:(NSString *)icon;

@end
