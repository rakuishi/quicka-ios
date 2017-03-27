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
#define kQuickaReadLaterIndex       @"kQuickaReadLaterIndex"

#define kQuickaBookmarkSegmentedControlIndex    @"kQuickaBookmarkSegmentedControlIndex"

#define kQuickaVersion              @"kQuickaVersion"
#define kQuickaCustomEngineURL      @"kQuickaCustomEngineURL"
#define kQuickaUseBuiltInBrowser    @"kQuickaUseBuiltInBrowser"
#define kQuickaUseSuggestView       @"kQuickaUseSuggestView"

typedef NS_ENUM(NSInteger, kSearchEngineType) {
    kSearchEngineTypeGoogle,
    kSearchEngineTypeYahoo,
    kSearchEngineTypeBing,
    kSearchEngineTypeCount
};

typedef NS_ENUM(NSInteger, kReadLaterType) {
    kReadLaterTypeNone,
    kReadLaterTypeReadingList,
    kReadLaterTypePocket,
    kReadLaterTypeCount
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

+ (NSArray *)getReadLaterNames;
+ (NSString *)getReadLaterName;
+ (NSInteger)getReadLaterIndex;
+ (void)setReadLaterIndex:(NSInteger)index;

@end
