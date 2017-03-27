//
//  HistoryManager.m
//  Quicka
//
//  Created by OCHIISHI Koichiro on 9/16/13.
//  Copyright (c) 2013 OCHIISHI Koichiro. All rights reserved.
//

#import "HistoryManager.h"

@implementation HistoryManager

+ (void)addQuery:(NSString *)query
{
    if (query.length == 0) {
        // 何も入力されていない場合は、保存しません
        return;
    }

    NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
    NSArray *hisotrys = [Hisotry MR_findAll];
    for (Hisotry *history in hisotrys) {
        if ([history.query isEqualToString:query]) {
            // 検索ワードが同一の場合は日付を更新
            history.updated = [NSDate date];
            [context MR_saveOnlySelfAndWait];
            return;
        }
    }
    
    Hisotry *history = [Hisotry MR_createEntity];
    history.query = query;
    history.updated = [NSDate date];

    [context MR_saveOnlySelfAndWait];
}

+ (NSArray *)getAllData
{
    return [Hisotry MR_findAllSortedBy:@"updated" ascending:NO];
}

+ (void)deleteHistory:(Hisotry *)history
{
    [history MR_deleteEntity];
    
    NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
    [context MR_saveOnlySelfAndWait];
}

+ (void)deleteAllData
{
    NSArray *hisotrys = [Hisotry MR_findAll];
    for (Hisotry *history in hisotrys) {
        [history MR_deleteEntity];
    }
    
    NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
    [context MR_saveOnlySelfAndWait];
}

+ (void)logAllData
{
    NSArray *hisotrys = [Hisotry MR_findAllSortedBy:@"updated" ascending:NO];
    int i = 0;
    if (hisotrys.count) {
        for (Hisotry *history in hisotrys) {
            DLog(@"%d, %@, %@", i, history.query, history.updated);
            i++;
        }
    }
}

@end
