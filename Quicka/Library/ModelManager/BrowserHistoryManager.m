//
//  BrowserHistoryManager.m
//  Quicka
//
//  Created by OCHIISHI Koichiro on 10/5/13.
//  Copyright (c) 2013 OCHIISHI Koichiro. All rights reserved.
//

#import "BrowserHistoryManager.h"

@implementation BrowserHistoryManager

+ (void)addTitle:(NSString *)title url:(NSString *)url
{
    NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
    NSArray *hisotrys = [BrowserHistory MR_findAll];
    for (BrowserHistory *history in hisotrys) {
        if ([history.title isEqualToString:title] &&
            [history.url isEqualToString:url]) {
            // 同一の場合は日付を更新
            history.updated = [NSDate date];
            [context MR_saveOnlySelfAndWait];
            return;
        }
    }

    BrowserHistory *history = [BrowserHistory MR_createEntity];
    history.title = title;
    history.url = url;
    history.updated = [NSDate date];
    
    [context MR_saveOnlySelfAndWait];
}

+ (NSMutableArray *)getAllData
{
    return [[BrowserHistory MR_findAllSortedBy:@"updated" ascending:NO] mutableCopy];
}

+ (void)deleteHistory:(BrowserHistory *)history
{
    [history MR_deleteEntity];
    
    NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
    [context MR_saveOnlySelfAndWait];
}

+ (void)deleteAllData
{
    NSArray *hisotrys = [BrowserHistory MR_findAll];
    for (BrowserHistory *history in hisotrys) {
        [history MR_deleteEntity];
    }
    
    NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
    [context MR_saveOnlySelfAndWait];
}

@end
