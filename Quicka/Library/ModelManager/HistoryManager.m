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
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    // 検索ワードが同一の場合は日付を更新
    RLMResults<RLMHistory *> *histories = [[RLMHistory allObjects] sortedResultsUsingKeyPath:@"updated" ascending:NO];
    for (RLMHistory *history in histories) {
        if ([history.query isEqualToString:query]) {
            [realm beginWriteTransaction];
            history.updated = [NSDate date];
            [realm commitWriteTransaction];
            return;
        }
    }

    [self addQuery:query updated:[NSDate date]];
}

+ (void)addQuery:(NSString *)query updated:(NSDate *)updated
{
    RLMHistory *history = [[RLMHistory alloc] init];
    history.query = query;
    history.updated = updated;

    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm addObject:history];
    [realm commitWriteTransaction];
}

+ (NSArray *)getAllData
{
    NSMutableArray *histories = [NSMutableArray array];
    for (RLMHistory *history in [[RLMHistory allObjects] sortedResultsUsingKeyPath:@"updated" ascending:NO]) {
        [histories addObject:history];
    }
    return histories;
}

+ (void)deleteHistory:(RLMHistory *)history
{
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm deleteObject:history];
    [realm commitWriteTransaction];
}

+ (void)deleteAllData
{
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm deleteObjects:[RLMHistory allObjects]];
    [realm commitWriteTransaction];
}

+ (void)migrateFromCoreDataToRealm
{
    for (Hisotry *history in [Hisotry MR_findAllSortedBy:@"updated" ascending:NO]) {
        [self addQuery:history.query updated:history.updated];
        NSLog(@"RLMHistory: %@", history.query);
    }

    [Hisotry MR_truncateAll];
}

@end
