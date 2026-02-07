//
//  HistoryManager.m
//  Quicka
//
//  Created by OCHIISHI Koichiro on 9/16/13.
//  Copyright (c) 2013 OCHIISHI Koichiro. All rights reserved.
//

#import "HistoryManager.h"
#import "QuickaUtil.h"

@implementation HistoryManager

#pragma mark - Private helpers

+ (NSMutableArray<QKHistory *> *)loadHistories
{
    NSArray *dicts = [[NSUserDefaults standardUserDefaults] arrayForKey:kQuickaHistories];
    NSMutableArray *histories = [NSMutableArray array];
    for (NSDictionary *dict in dicts) {
        [histories addObject:[[QKHistory alloc] initWithDictionary:dict]];
    }
    return histories;
}

+ (void)saveHistories:(NSArray<QKHistory *> *)histories
{
    NSMutableArray *dicts = [NSMutableArray array];
    for (QKHistory *h in histories) {
        [dicts addObject:[h toDictionary]];
    }
    [[NSUserDefaults standardUserDefaults] setObject:dicts forKey:kQuickaHistories];
}

#pragma mark - Public methods

+ (void)addQuery:(NSString *)query
{
    if (query.length == 0) {
        // 何も入力されていない場合は、保存しません
        return;
    }

    NSMutableArray<QKHistory *> *histories = [self loadHistories];

    // 検索ワードが同一の場合は日付を更新
    for (QKHistory *history in histories) {
        if ([history.query isEqualToString:query]) {
            history.updated = [NSDate date];
            [self saveHistories:histories];
            return;
        }
    }

    QKHistory *history = [[QKHistory alloc] init];
    history.query = query;
    history.updated = [NSDate date];
    [histories addObject:history];
    [self saveHistories:histories];
}

+ (NSArray *)getAllData
{
    NSMutableArray *histories = [self loadHistories];
    [histories sortUsingComparator:^NSComparisonResult(QKHistory *a, QKHistory *b) {
        return [b.updated compare:a.updated];
    }];
    return histories;
}

+ (void)deleteHistory:(QKHistory *)history
{
    NSMutableArray *all = [self loadHistories];
    NSUInteger indexToRemove = NSNotFound;
    for (NSUInteger i = 0; i < all.count; i++) {
        QKHistory *h = all[i];
        if ([h.query isEqualToString:history.query]) {
            indexToRemove = i;
            break;
        }
    }
    if (indexToRemove != NSNotFound) {
        [all removeObjectAtIndex:indexToRemove];
        [self saveHistories:all];
    }
}

+ (void)deleteAllData
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kQuickaHistories];
}

@end
