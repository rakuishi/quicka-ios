//
//  BrowserBookmarkManager.h
//  Quicka
//
//  Created by OCHIISHI Koichiro on 10/5/13.
//  Copyright (c) 2013 OCHIISHI Koichiro. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CoreData+MagicalRecord.h"
#import "BrowserBookmark+CoreDataClass.h"

@interface BrowserBookmarkManager : NSObject

+ (void)addTitle:(NSString *)title url:(NSString *)url;
+ (void)updateBookmark:(BrowserBookmark *)bookmark title:(NSString *)title url:(NSString *)url;
+ (BOOL)isAlreadyExistUrl:(NSString *)url;
+ (void)updateBookmarks:(NSMutableArray *)bookmarks;
+ (void)deleteBookmark:(BrowserBookmark *)bookmark;
+ (NSMutableArray *)getAllData;
+ (void)deleteBrowserBookmark:(BrowserBookmark *)bookmark;

@end
