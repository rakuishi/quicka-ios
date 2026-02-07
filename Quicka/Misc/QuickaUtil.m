//
//  QuickaUtil.m
//  Quicka
//
//  Created by OCHIISHI Koichiro on 9/29/13.
//  Copyright (c) 2013 OCHIISHI Koichiro. All rights reserved.
//

#import "QuickaUtil.h"
#import "ActionManager.h"
#import "HistoryManager.h"
#import "RealmMigrator.h"

@implementation QuickaUtil

#pragma mark - resizeImage / maskImage

+ (UIImage *)resizeImage:(UIImage *)image toSize:(CGSize)size
{
    if (&UIGraphicsBeginImageContextWithOptions != NULL) {
		UIGraphicsBeginImageContextWithOptions(CGSizeMake(size.width, size.height), NO, [[UIScreen mainScreen] scale]);
	}
    
    CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

+ (UIImage *)maskImage:(UIImage *)image
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    UIImage *maskImage = [UIImage imageNamed:@"icon_mask_58"];
    CGImageRef maskImageRef = [maskImage CGImage];
    
    // create a bitmap graphics context the size of the image
    CGContextRef mainViewContentContext = CGBitmapContextCreate (NULL, maskImage.size.width, maskImage.size.height, 8, 0, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
    
    if (mainViewContentContext == NULL) {
        CGColorSpaceRelease(colorSpace);
        return NULL;
    }
    
    CGFloat ratio = 0;
    
    ratio = maskImage.size.width / image.size.width;
    
    if(ratio * image.size.height < maskImage.size.height) {
        ratio = maskImage.size.height / image.size.height;
    }
    
    CGRect rect1  = {{0, 0}, {maskImage.size.width, maskImage.size.height}};
    CGRect rect2  = {{-((image.size.width*ratio)-maskImage.size.width)/2 , -((image.size.height*ratio)-maskImage.size.height)/2}, {image.size.width*ratio, image.size.height*ratio}};
    
    CGContextClipToMask(mainViewContentContext, rect1, maskImageRef);
    CGContextDrawImage(mainViewContentContext, rect2, image.CGImage);
    
    // Create CGImageRef of the main view bitmap content, and then
    // release that bitmap context
    CGImageRef newImage = CGBitmapContextCreateImage(mainViewContentContext);
    CGContextRelease(mainViewContentContext);
    
    UIImage *theImage = [UIImage imageWithCGImage:newImage];
    
    CGImageRelease(newImage);
    CGColorSpaceRelease(colorSpace);
    
    // return the image
    return [self resizeImage:theImage toSize:(CGSize){29,29}];
}

#pragma mark - getCacheSize / removeCache

+ (CGFloat)getCacheSizeInMegaBytes
{
    unsigned long long int size = 0;
    NSFileManager *manager = [NSFileManager defaultManager];
    NSError *error;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *directory = [paths objectAtIndex:0];
    NSArray *fileList = [manager subpathsAtPath:directory];
    
    for (NSString *fileName in fileList) {
        NSString *path = [directory stringByAppendingPathComponent:fileName];
        NSDictionary *cacheFileAttributes = [manager attributesOfItemAtPath:path error:&error];
        size += [cacheFileAttributes fileSize];
    }
    
    return size / (1024.f * 1024.f);
}

+ (void)removeCache
{
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *directory = [paths objectAtIndex:0];
    NSArray *fileList = [manager subpathsAtPath:directory];
    
    for (NSString *fileName in fileList) {
        [manager removeItemAtPath:[directory stringByAppendingPathComponent:fileName] error:nil];
    }
}

#pragma mark -

+ (void)setup
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *version = [defaults stringForKey:kQuickaVersion];

    if (version.length) {
        // 2回目以降の起動: Realm からの移行が必要かチェック
        if (![defaults boolForKey:kQuickaRealmMigrated]) {
            [self migrateRealmToUserDefaults];
            [defaults setBool:YES forKey:kQuickaRealmMigrated];
            [defaults synchronize];
        }
    } else {
        // 初回起動
        [ActionManager setupInitAction];

        // 初期値を入力
        [QuickaUtil setOn:NO forKey:kQuickaUseSuggestView];
        [QuickaUtil setOn:YES forKey:kQuickaClearTextAfterSearch];

        // 新規インストールなので Realm 移行は不要
        [defaults setBool:YES forKey:kQuickaRealmMigrated];

        version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        [defaults setObject:version forKey:kQuickaVersion];
        [defaults synchronize];
    }
}

+ (void)migrateRealmToUserDefaults
{
    if (![RealmMigrator realmDatabaseExists]) {
        NSLog(@"[Migration] Realm database not found. Skipping migration.");
        return;
    }

    NSLog(@"[Migration] Starting Realm → NSUserDefaults migration...");

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    NSArray *actions = [RealmMigrator readActionsFromRealm];
    if (actions.count > 0) {
        [defaults setObject:actions forKey:kQuickaActions];
    }
    NSLog(@"[Migration] Migrated %lu actions.", (unsigned long)actions.count);

    NSArray *histories = [RealmMigrator readHistoriesFromRealm];
    if (histories.count > 0) {
        [defaults setObject:histories forKey:kQuickaHistories];
    }
    NSLog(@"[Migration] Migrated %lu histories.", (unsigned long)histories.count);

    [defaults synchronize];

    NSLog(@"[Migration] Realm → NSUserDefaults migration completed successfully.");
}

#pragma mark - NSUserDefaults for BOOL Value key

+ (BOOL)isOnForKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:key];
}

+ (void)setOn:(BOOL)on forKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:on forKey:key];
    [defaults synchronize];
}

+ (NSInteger)integerForKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults integerForKey:key];
}

+ (void)setInteger:(NSInteger)value forKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:value forKey:key];
    [defaults synchronize];
}

#pragma mark - SearchEngine

+ (NSArray *)getSearchEngineNames
{
    return @[@"Google", @"Yahoo!", @"Bing", @"Custom"];
}

+ (NSString *)getSearchEngineName
{
    NSArray *searchEngineNames = [self getSearchEngineNames];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [searchEngineNames objectAtIndex:[defaults integerForKey:kQuickaSearchEngineIndex]];
}

+ (NSString *)getSearchEngineURLWithIndex:(NSInteger)index
{
    switch (index) {
        case 0: // Google
            return @"http://www.google.com/search?q=[U]";
        case 1: // Yahoo!
            return @"http://search.yahoo.co.jp/search?p=[U]";
        case 2: // Bing
            return @"http://www.bing.com/search/?q=[U]";
        case 3: // Custom
            return [self getCustomEngineURL];
        default:
            return @"http://www.google.com/search?q=[U]";
    }
}

+ (NSString *)getSearchEngineURL
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger index = [defaults integerForKey:kQuickaSearchEngineIndex];
    return [self getSearchEngineURLWithIndex:index];
}

+ (NSInteger)getSearchEngineIndex
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults integerForKey:kQuickaSearchEngineIndex];
}

+ (void)setSearchEngineIndex:(NSInteger)index
{
    NSArray *searchEngineNames = [self getSearchEngineNames];
    if (index < searchEngineNames.count) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setInteger:index forKey:kQuickaSearchEngineIndex];
    }
}

+ (NSString *)getCustomEngineURL
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults stringForKey:kQuickaCustomEngineURL];
}

+ (void)setCustomEngineURL:(NSString *)URL
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:URL forKey:kQuickaCustomEngineURL];
    [defaults synchronize];
}

#pragma mark - Browser

+ (NSArray *)getBrowserNames
{
    return @[@"SFSafariViewController", @"Default Browser App", @"Quicka Browser"];
}

+ (NSString *)getBrowserName
{
    NSArray *browserNames = [self getBrowserNames];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [browserNames objectAtIndex:[defaults integerForKey:kQuickaBrowserIndex]];
}

+ (NSInteger)getBrowserIndex
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults integerForKey:kQuickaBrowserIndex];
}

+ (void)setBrowserIndex:(NSInteger)index
{
    NSArray *readLaterNames = [self getBrowserNames];
    if (index < readLaterNames.count) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setInteger:index forKey:kQuickaBrowserIndex];
    }
}

@end
