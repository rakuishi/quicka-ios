//
//  BrowserBookmarkManager.m
//  Quicka
//
//  Created by OCHIISHI Koichiro on 10/5/13.
//  Copyright (c) 2013 OCHIISHI Koichiro. All rights reserved.
//

#import "BrowserBookmarkManager.h"

@implementation BrowserBookmarkManager

+ (void)addTitle:(NSString *)title url:(NSString *)url
{
    if (title.length == 0 || url.length == 0) {
        return;
    }
    
    NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
    NSArray *bookmarks = [BrowserBookmark MR_findAllSortedBy:@"sort" ascending:YES];
    NSInteger max = 0;
    for (BrowserBookmark *bookmark in bookmarks) {
        if ([bookmark.sort integerValue] > max) {
            max = [bookmark.sort integerValue];
        }
    }
    
    BrowserBookmark *bookmark = [BrowserBookmark MR_createEntity];
    bookmark.title = title;
    bookmark.url = url;
    bookmark.sort = [NSNumber numberWithInteger:max + 1];
    
    [context MR_saveOnlySelfAndWait];
}

+ (void)updateBookmark:(BrowserBookmark *)bookmark title:(NSString *)title url:(NSString *)url
{
    NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
    bookmark.title = title;
    bookmark.url = url;
    [context MR_saveOnlySelfAndWait];
}

+ (BOOL)isAlreadyExistUrl:(NSString *)url
{
    NSArray *bookmarks = [BrowserBookmark MR_findAllSortedBy:@"sort" ascending:YES];
    for (BrowserBookmark *bookmark in bookmarks) {
        if ([bookmark.url isEqualToString:url]) {
            return YES;
        }
    }
    return NO;
}

+ (void)updateBookmarks:(NSMutableArray *)bookmarks
{
    NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
    NSInteger sort = 1;
    for (BrowserBookmark *bookmark in bookmarks) {
        bookmark.sort = [NSNumber numberWithInteger:sort];
        [context MR_saveOnlySelfAndWait]; // 保存
        sort++;
    }
}

+ (void)deleteBookmark:(BrowserBookmark *)bookmark
{
    [bookmark MR_deleteEntity];
    
    NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
    [context MR_saveOnlySelfAndWait];
}

+ (NSMutableArray *)getAllData
{
    return [[BrowserBookmark MR_findAllSortedBy:@"sort" ascending:YES] mutableCopy];
}

+ (void)deleteBrowserBookmark:(BrowserBookmark *)bookmark
{
    [bookmark MR_deleteEntity];

    NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
    [context MR_saveOnlySelfAndWait];
}

@end
