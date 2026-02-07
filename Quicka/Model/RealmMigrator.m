//
//  RealmMigrator.m
//  Quicka
//

#import "RealmMigrator.h"
#import <Realm/Realm.h>
#import "RLMAction.h"
#import "RLMHistory.h"

@implementation RealmMigrator

+ (BOOL)realmDatabaseExists
{
    RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
    return [[NSFileManager defaultManager] fileExistsAtPath:config.fileURL.path];
}

+ (NSArray<NSDictionary *> *)readActionsFromRealm
{
    @try {
        RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
        config.deleteRealmIfMigrationNeeded = YES;
        RLMRealm *realm = [RLMRealm realmWithConfiguration:config error:nil];

        RLMResults<RLMAction *> *results = [[RLMAction allObjectsInRealm:realm] sortedResultsUsingKeyPath:@"sort" ascending:YES];
        NSMutableArray *actions = [NSMutableArray array];
        for (RLMAction *action in results) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"uuid"] = [[NSUUID UUID] UUIDString];
            if (action.imageName) dict[@"imageName"] = action.imageName;
            if (action.sort)      dict[@"sort"] = action.sort;
            if (action.title)     dict[@"title"] = action.title;
            if (action.url)       dict[@"url"] = action.url;
            [actions addObject:[dict copy]];
        }
        return actions;
    } @catch (NSException *exception) {
        NSLog(@"RealmMigrator: Failed to read actions: %@", exception);
        return @[];
    }
}

+ (NSArray<NSDictionary *> *)readHistoriesFromRealm
{
    @try {
        RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
        config.deleteRealmIfMigrationNeeded = YES;
        RLMRealm *realm = [RLMRealm realmWithConfiguration:config error:nil];

        RLMResults<RLMHistory *> *results = [[RLMHistory allObjectsInRealm:realm] sortedResultsUsingKeyPath:@"updated" ascending:NO];
        NSMutableArray *histories = [NSMutableArray array];
        for (RLMHistory *history in results) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            if (history.query)   dict[@"query"] = history.query;
            if (history.updated) dict[@"updated"] = @([history.updated timeIntervalSince1970]);
            [histories addObject:[dict copy]];
        }
        return histories;
    } @catch (NSException *exception) {
        NSLog(@"RealmMigrator: Failed to read histories: %@", exception);
        return @[];
    }
}

+ (void)deleteRealmFiles
{
    RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
    NSString *realmPath = config.fileURL.path;
    NSArray *suffixes = @[@"", @".lock", @".note", @".management"];
    NSFileManager *manager = [NSFileManager defaultManager];
    for (NSString *suffix in suffixes) {
        NSString *path = [realmPath stringByAppendingString:suffix];
        [manager removeItemAtPath:path error:nil];
    }
}

@end
