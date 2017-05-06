//
//  CustomActivity.m
//  Quicka
//
//  Created by OCHIISHI Koichiro on 9/15/13.
//  Copyright (c) 2013 OCHIISHI Koichiro. All rights reserved.
//

#import "CustomActivity.h"

NSString *const kActivityURLSchemesChrome = @"googlechrome:";
NSString *const kActivityURLSchemesSleipnir  = @"sleipnir:";
NSString *const kActivityURLSchemesiCabMobile = @"icabmobile:";

@implementation CustomActivity

+ (NSArray *)getApplicationActivities;
{
    NSMutableArray *applicationActivities = [NSMutableArray new];

    {
        BookmarkActivity *activity = [BookmarkActivity new];
        [applicationActivities addObject:activity];
    }

    {
        CopyActivity *activity = [CopyActivity new];
        [applicationActivities addObject:activity];
    }

    {
        ViewSourceActivity *activity = [ViewSourceActivity new];
        [applicationActivities addObject:activity];
    }

    if ([[PocketAPI sharedAPI] isLoggedIn] && [QuickaUtil getReadLaterIndex] == 2) {
        PocketActivity *activity = [PocketActivity new];
        [applicationActivities addObject:activity];
    }
    
    {
        SafariActivity *activity = [SafariActivity new];
        [applicationActivities addObject:activity];
    }
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:kActivityURLSchemesChrome]]) {
        ChromeActivity *activity = [ChromeActivity new];
        [applicationActivities addObject:activity];
    }
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:kActivityURLSchemesSleipnir]]) {
        SleipnirActivity *activity = [SleipnirActivity new];
        [applicationActivities addObject:activity];
    }
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:kActivityURLSchemesiCabMobile]]) {
        iCabMobileActivity *activity = [iCabMobileActivity new];
        [applicationActivities addObject:activity];
    }
    
    return [applicationActivities copy];
}

@end

#pragma mark - CopyActivity

@implementation CopyActivity

- (NSString *)activityType
{
    return @"Copy";
}

- (NSString *)activityTitle
{
    return LSTR(@"Copy");
}

- (UIImage *)activityImage
{
    return [UIImage imageNamed:@"activity_copy"];
}

+ (UIActivityCategory)activityCategory
{
    return UIActivityCategoryAction;
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems
{
    for (id activityItem in activityItems) {
        if ([activityItem isKindOfClass:[NSURL class]]) {
            return YES;
        }
    }
    return NO;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems
{
    for (id activityItem in activityItems) {
        if ([activityItem isKindOfClass:[NSURL class]]) {
            [self copyURL:(NSURL *)activityItem];
        }
    }
}

- (void)copyURL:(NSURL *)URL
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setValue:URL.absoluteString forPasteboardType: @"public.utf8-plain-text"];
}

@end

#pragma mark - BookmarkActivity

@implementation BookmarkActivity

- (NSString *)activityType
{
    return @"Bookmark";
}

- (NSString *)activityTitle
{
    return LSTR(@"Add Bookmark");
}

- (UIImage *)activityImage
{
    return [UIImage imageNamed:@"activity_bookmark"];
}

+ (UIActivityCategory)activityCategory
{
    return UIActivityCategoryAction;
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems
{
    NSString *title = nil;
    NSString *URLString = nil;
    
    for (id activityItem in activityItems) {
        if ([activityItem isKindOfClass:[NSURL class]]) {
            NSURL *URL = (NSURL *)activityItem;
            URLString = URL.absoluteString;
        } else if ([activityItem isKindOfClass:[NSString class]]) {
            title = (NSString *)activityItem;
        }
    }

    if (title && URLString && [BrowserBookmarkManager isAlreadyExistUrl:URLString] == NO) {
        return YES;
    }
    
    return NO;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems
{
    NSString *title = nil;
    NSString *URLString = nil;
    
    for (id activityItem in activityItems) {
        if ([activityItem isKindOfClass:[NSURL class]]) {
            NSURL *URL = (NSURL *)activityItem;
            URLString = URL.absoluteString;
        } else if ([activityItem isKindOfClass:[NSString class]]) {
            title = (NSString *)activityItem;
        }
    }
    
    if (title && URLString) {
        [BrowserBookmarkManager addTitle:title url:URLString];
    }
}

@end

#pragma mark - ViewSourceActivity

@implementation ViewSourceActivity

- (NSString *)activityType
{
    return @"View Source";
}

- (NSString *)activityTitle
{
    return LSTR(@"View Source");
}

- (UIImage *)activityImage
{
    return [UIImage imageNamed:@"activity_source"];
}

+ (UIActivityCategory)activityCategory
{
    return UIActivityCategoryAction;
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems
{
    for (id activityItem in activityItems) {
        if ([activityItem isKindOfClass:[NSURL class]]) {
            return YES;
        }
    }
    return NO;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems
{
    for (id activityItem in activityItems) {
        if ([activityItem isKindOfClass:[NSURL class]]) {
            // ...
        }
    }
}

@end

#pragma mark - PocketActivity

@implementation PocketActivity

- (NSString *)activityType
{
    return @"Send to Pocket";
}

- (NSString *)activityTitle
{
    return @"Pocket";
}

- (UIImage *)activityImage
{
    return [UIImage imageNamed:@"activity_pocket"];
}

+ (UIActivityCategory)activityCategory
{
    return UIActivityCategoryAction;
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems
{
    for (id activityItem in activityItems) {
        if ([activityItem isKindOfClass:[NSURL class]]) {
            return YES;
        }
    }
    return NO;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems
{
    for (id activityItem in activityItems) {
        if ([activityItem isKindOfClass:[NSURL class]]) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            [[PocketAPI sharedAPI] saveURL:(NSURL *)activityItem
                                   handler:^(PocketAPI *api, NSURL *url, NSError *error) {
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            }];
        }
    }
}

@end

#pragma mark - SafariActivity

@implementation SafariActivity

- (NSString *)activityType
{
    return @"Safari";
}

- (NSString *)activityTitle
{
    return @"Safari";
}

- (UIImage *)activityImage
{
    return [UIImage imageNamed:@"activity_safari"];
}

+ (UIActivityCategory)activityCategory
{
    return UIActivityCategoryAction;
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems
{
    for (id activityItem in activityItems) {
        if ([activityItem isKindOfClass:[NSURL class]]) {
            return YES;
        }
    }
    return NO;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems
{
    for (id activityItem in activityItems) {
        if ([activityItem isKindOfClass:[NSURL class]]) {
            [self openURL:(NSURL *)activityItem];
        }
    }
}

- (void)openURL:(NSURL *)URL
{
    [[UIApplication sharedApplication] openURL:URL options:@{} completionHandler:nil];
}

@end

#pragma mark - ChromeActivity

@implementation ChromeActivity

- (NSString *)activityType
{
    return @"Chrome";
}

- (NSString *)activityTitle
{
    return @"Chrome";
}

- (UIImage *)activityImage
{
    return [UIImage imageNamed:@"activity_chrome"];
}

+ (UIActivityCategory)activityCategory
{
    return UIActivityCategoryAction;
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems
{
    for (id activityItem in activityItems) {
        if ([activityItem isKindOfClass:[NSURL class]]) {
            return YES;
        }
    }
    return NO;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems
{
    for (id activityItem in activityItems) {
        if ([activityItem isKindOfClass:[NSURL class]]) {
            [self openURL:(NSURL *)activityItem];
        }
    }
}

- (void)openURL:(NSURL *)URL
{
    NSString *URLString = URL.absoluteString;
    URLString = [URLString stringByReplacingOccurrencesOfString:@"https:" withString:kActivityURLSchemesChrome];
    URLString = [URLString stringByReplacingOccurrencesOfString:@"http:" withString:kActivityURLSchemesChrome];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:URLString] options:@{} completionHandler:nil];
}

@end

#pragma mark - SleipnirActivity

@implementation SleipnirActivity

- (NSString *)activityType
{
    return @"Sleipnir";
}

- (NSString *)activityTitle
{
    return @"Sleipnir";
}

- (UIImage *)activityImage
{
    return [UIImage imageNamed:@"activity_sleipnir"];
}

+ (UIActivityCategory)activityCategory
{
    return UIActivityCategoryAction;
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems
{
    for (id activityItem in activityItems) {
        if ([activityItem isKindOfClass:[NSURL class]]) {
            return YES;
        }
    }
    return NO;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems
{
    for (id activityItem in activityItems) {
        if ([activityItem isKindOfClass:[NSURL class]]) {
            [self openURL:(NSURL *)activityItem];
        }
    }
}

- (void)openURL:(NSURL *)URL
{
    NSString *URLString = URL.absoluteString;
    URLString = [URLString stringByReplacingOccurrencesOfString:@"https:" withString:kActivityURLSchemesSleipnir];
    URLString = [URLString stringByReplacingOccurrencesOfString:@"http:" withString:kActivityURLSchemesSleipnir];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:URLString] options:@{} completionHandler:nil];
}

@end

#pragma mark - iCabMobileActivity

@implementation iCabMobileActivity

- (NSString *)activityType
{
    return @"iCab Mobile";
}

- (NSString *)activityTitle
{
    return @"iCab Mobile";
}

- (UIImage *)activityImage
{
    return [UIImage imageNamed:@"activity_icabmobile"];
}

+ (UIActivityCategory)activityCategory
{
    return UIActivityCategoryAction;
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems
{
    for (id activityItem in activityItems) {
        if ([activityItem isKindOfClass:[NSURL class]]) {
            return YES;
        }
    }
    return NO;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems
{
    for (id activityItem in activityItems) {
        if ([activityItem isKindOfClass:[NSURL class]]) {
            [self openURL:(NSURL *)activityItem];
        }
    }
}

- (void)openURL:(NSURL *)URL
{
    NSString *URLString = URL.absoluteString;
    URLString = [URLString stringByReplacingOccurrencesOfString:@"https:" withString:kActivityURLSchemesiCabMobile];
    URLString = [URLString stringByReplacingOccurrencesOfString:@"http:" withString:kActivityURLSchemesiCabMobile];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:URLString] options:@{} completionHandler:nil];
}

@end
