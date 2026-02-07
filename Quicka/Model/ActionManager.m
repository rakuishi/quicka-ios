//
//  ActionManager.m
//  Quicka
//
//  Created by OCHIISHI Koichiro on 9/16/13.
//  Copyright (c) 2013 OCHIISHI Koichiro. All rights reserved.
//

#import "ActionManager.h"
#import "QuickaUtil.h"

@implementation ActionManager

#pragma mark - Private helpers

+ (NSMutableArray<QKAction *> *)loadActions
{
    NSArray *dicts = [[NSUserDefaults standardUserDefaults] arrayForKey:kQuickaActions];
    NSMutableArray *actions = [NSMutableArray array];
    for (NSDictionary *dict in dicts) {
        [actions addObject:[[QKAction alloc] initWithDictionary:dict]];
    }
    return actions;
}

+ (void)saveActions:(NSArray<QKAction *> *)actions
{
    NSMutableArray *dicts = [NSMutableArray array];
    for (QKAction *action in actions) {
        [dicts addObject:[action toDictionary]];
    }
    [[NSUserDefaults standardUserDefaults] setObject:dicts forKey:kQuickaActions];
}

#pragma mark - Public methods

+ (void)setupInitAction
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"setup" ofType:@"json"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];

    for (int i = 0; i < json.count; i++) {

        NSDictionary *dict = json[i];
        NSString *URLString = [dict objectForKey:@"url"];

        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:URLString]]) {
            NSString *title = (JP) ? [dict objectForKey:@"title_ja"] : [dict objectForKey:@"title"];
            NSString *url = [dict objectForKey:@"url"];
            UIImage *image = [UIImage imageNamed:[dict objectForKey:@"artworkUrl"]];

            title = [NSString stringWithFormat:@"%@ - %@", [dict objectForKey:@"trackName"], title];
            [self addTitle:title url:url image:image];
        }
    }
}

+ (void)addTitle:(NSString *)title url:(NSString *)url image:(UIImage *)image
{
    [self createImagesDirectory];

    NSString *imageName = nil;
    if (image) {
        imageName = [self MD5:image];
        [[[NSData alloc] initWithData:UIImagePNGRepresentation(image)] writeToFile:IMAGE_PATH(imageName) atomically:YES];
    }

    // ソート番号を確定（一番後ろにする）
    NSMutableArray<QKAction *> *actions = [self loadActions];
    NSInteger max = 0;
    for (QKAction *action in actions) {
        if ([action.sort integerValue] > max) {
            max = [action.sort integerValue];
        }
    }

    [self addTitle:title url:url image:imageName sort:[NSNumber numberWithInteger:max + 1]];
}

+ (void)addTitle:(NSString *)title url:(NSString *)url image:(NSString *)image sort:(NSNumber *)sort
{
    QKAction *action = [[QKAction alloc] init];
    action.title = title;
    action.url = url;
    action.imageName = image;
    action.sort = sort;

    NSMutableArray *actions = [self loadActions];
    [actions addObject:action];
    [self saveActions:actions];
}

+ (void)updateAction:(QKAction *)action title:(NSString *)title url:(NSString *)url image:(UIImage *)image
{
    NSError *error = nil;
    if (![[NSFileManager defaultManager] removeItemAtPath:IMAGE_PATH(action.imageName) error:&error]) {
        DLog(@"Error: %@", error);
    }

    NSString *imageName = nil;
    if (image) {
        imageName = [self MD5:image];
        [[[NSData alloc] initWithData:UIImagePNGRepresentation(image)] writeToFile:IMAGE_PATH(imageName) atomically:YES];
    }

    action.title = title;
    action.url = url;
    action.imageName = imageName;

    NSMutableArray *all = [self loadActions];
    for (NSUInteger i = 0; i < all.count; i++) {
        QKAction *a = all[i];
        if ([a.uuid isEqualToString:action.uuid]) {
            all[i] = action;
            break;
        }
    }
    [self saveActions:all];
}

+ (void)updateActions:(NSMutableArray *)actions
{
    NSInteger sort = 1;
    for (QKAction *action in actions) {
        action.sort = [NSNumber numberWithInteger:sort];
        sort++;
    }
    [self saveActions:actions];
}

+ (void)deleteAction:(QKAction *)action
{
    NSString *imageName = action.imageName;

    NSMutableArray *all = [self loadActions];
    NSUInteger indexToRemove = NSNotFound;
    for (NSUInteger i = 0; i < all.count; i++) {
        QKAction *a = all[i];
        if ([a.uuid isEqualToString:action.uuid]) {
            indexToRemove = i;
            break;
        }
    }
    if (indexToRemove != NSNotFound) {
        [all removeObjectAtIndex:indexToRemove];
    }
    [self saveActions:all];

    // 他のアクションで同一の画像を使用しているかどうかを調査
    NSInteger count = 0;
    for (QKAction *temp in all) {
        if ([imageName isEqualToString:temp.imageName]) {
            count++;
        }
    }

    // 画像名 == nil を削除した場合に、そのフォルダのすべての画像を削除してしまうので回避
    if (count == 0 && imageName.length) {
        NSError *error = nil;
        if (![[NSFileManager defaultManager] removeItemAtPath:IMAGE_PATH(imageName) error:&error]) {
            DLog(@"Error: %@", error);
        }
    }
}

+ (NSMutableArray *)getAllData
{
    NSMutableArray *actions = [self loadActions];
    [actions sortUsingComparator:^NSComparisonResult(QKAction *a, QKAction *b) {
        return [a.sort compare:b.sort];
    }];
    return actions;
}

+ (BOOL)createImagesDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Images"];
    NSError *error;
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        if (![[NSFileManager defaultManager] createDirectoryAtPath:path
                                       withIntermediateDirectories:NO
                                                        attributes:nil
                                                             error:&error])
        {
            DLog(@"%@", error);
            return NO;
        } else {
            return YES;
        }
    }

    return YES;
}

#pragma clang diagnostic ignored "-Wdeprecated-declarations"

+ (NSString *)MD5:(UIImage *)image
{
    // UIImageからハッシュ値を求める
    // hmdt.jp/blog/?p=727
    unsigned char hash[CC_MD5_DIGEST_LENGTH];
    CGDataProviderRef dataProvider;
    NSData *data;
    dataProvider = CGImageGetDataProvider(image.CGImage);
    data = (NSData *)CFBridgingRelease(CGDataProviderCopyData(dataProvider));
    CC_MD5([data bytes], (CC_LONG)[data length], hash);

    NSString *output = @"";
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        output = [output stringByAppendingFormat:@"%02x", hash[i]];
    }

    return output;
}

@end
