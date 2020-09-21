//
//  QuickaUtil.h
//  Quicka
//
//  Created by OCHIISHI Koichiro on 9/29/13.
//  Copyright (c) 2013 OCHIISHI Koichiro. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kQuickaClearTextAfterSearch @"kQuickaClearTextAfterSearch"
#define kQuickaSearchEngineIndex    @"kQuickaSearchEngineIndex"
#define kQuickaBrowserIndex         @"kQuickaBrowserIndex"

#define kQuickaBookmarkSegmentedControlIndex    @"kQuickaBookmarkSegmentedControlIndex"

#define kQuickaVersion              @"kQuickaVersion"
#define kQuickaCustomEngineURL      @"kQuickaCustomEngineURL"
#define kQuickaUseSuggestView       @"kQuickaUseSuggestView"
#define kQuickaIsMigrated           @"kQuickaIsMigrated"

typedef NS_ENUM(NSInteger, kSearchEngineType) {
    kSearchEngineTypeGoogle,
    kSearchEngineTypeYahoo,
    kSearchEngineTypeBing,
    kSearchEngineTypeCount
};

typedef NS_ENUM(NSInteger, kBrowserType) {
    kBrowserTypeSFSafariViewController,
    kBrowserTypeSafari,
    kBrowserTypeQuickaBrowser,
    kBrowserTypeCount
};

@interface QuickaUtil : NSObject

+ (UIImage *)resizeImage:(UIImage *)image toSize:(CGSize)size;
+ (UIImage *)maskImage:(UIImage *)image;

+ (CGFloat)getCacheSizeInMegaBytes;
+ (void)removeCache;

+ (void)setup;

+ (BOOL)isOnForKey:(NSString *)key;
+ (void)setOn:(BOOL)on forKey:(NSString *)key;
+ (NSInteger)integerForKey:(NSString *)key;
+ (void)setInteger:(NSInteger)value forKey:(NSString *)key;

+ (NSArray *)getSearchEngineNames;
+ (NSString *)getSearchEngineName;
+ (NSString *)getSearchEngineURLWithIndex:(NSInteger)index;
+ (NSString *)getSearchEngineURL;
+ (NSInteger)getSearchEngineIndex;
+ (void)setSearchEngineIndex:(NSInteger)index;

+ (NSString *)getCustomEngineURL;
+ (void)setCustomEngineURL:(NSString *)URL;

+ (NSArray *)getBrowserNames;
+ (NSString *)getBrowserName;
+ (NSInteger)getBrowserIndex;
+ (void)setBrowserIndex:(NSInteger)index;

@end
