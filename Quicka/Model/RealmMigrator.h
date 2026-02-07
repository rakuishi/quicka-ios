//
//  RealmMigrator.h
//  Quicka
//

#import <Foundation/Foundation.h>

@interface RealmMigrator : NSObject

/// Realm データベースファイルが存在するかどうかを返す
+ (BOOL)realmDatabaseExists;

/// Realm から全アクションを読み取り、NSArray<NSDictionary *> として返す
+ (NSArray<NSDictionary *> *)readActionsFromRealm;

/// Realm から全履歴を読み取り、NSArray<NSDictionary *> として返す
+ (NSArray<NSDictionary *> *)readHistoriesFromRealm;

/// Realm 関連ファイルをディスクから削除する
+ (void)deleteRealmFiles;

@end
