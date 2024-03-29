//
//  AppDelegate.m
//  Quicka
//
//  Created by OCHIISHI Koichiro on 9/14/13.
//  Copyright (c) 2013 OCHIISHI Koichiro. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSDictionary *titleTextAttrs = @{NSForegroundColorAttributeName:[UIColor whiteColor]};

    [[UINavigationBar appearance] setTintColor:QK_TINT_COLOR];
    [[UINavigationBar appearance] setBarTintColor:QK_BAR_TINT_COLOR];
    [[UINavigationBar appearance] setTitleTextAttributes:titleTextAttrs];
    [[UINavigationBar appearance] setTranslucent:false];
    [[UIToolbar appearance] setTintColor:QK_TINT_COLOR];
    [[UIToolbar appearance] setBarTintColor:QK_BAR_TINT_COLOR];

    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *navBarAppearance = [UINavigationBarAppearance new];
        [navBarAppearance configureWithOpaqueBackground];
        [navBarAppearance setTitleTextAttributes:titleTextAttrs];
        [navBarAppearance setBackgroundColor:QK_BAR_TINT_COLOR];
        [[UINavigationBar appearance] setStandardAppearance:navBarAppearance];
        [[UINavigationBar appearance] setScrollEdgeAppearance:navBarAppearance];

        UIToolbarAppearance *toolbarAppearance = [UIToolbarAppearance new];
        [toolbarAppearance configureWithOpaqueBackground];
        [toolbarAppearance setBackgroundColor:QK_BAR_TINT_COLOR];
        [[UIToolbar appearance] setStandardAppearance:toolbarAppearance];
        [[UIToolbar appearance] setScrollEdgeAppearance:toolbarAppearance];
    }

    [QuickaUtil setup];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [ContainerViewController new];
    self.window.backgroundColor = [UIColor blackColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    // if you handle your own URLs, do it here
    NSString *host = [url host];
    NSDictionary *dict = [self parseQueryString:[url query]];
    if ([host isEqualToString:@"add"]) {
        NSString *title = [dict objectForKey:@"title"];
        NSString *url = [dict objectForKey:@"url"];
        NSString *base64String = [dict objectForKey:@"image"];
        if (title.length && url.length) {
            title = [title UTF8DecodedString];
            url = [url UTF8DecodedString];
            if (base64String) {
                NSData *data = [[NSData alloc] initWithBase64EncodedString:base64String options:NSDataBase64DecodingIgnoreUnknownCharacters];
                UIImage *image = [UIImage imageWithData:data];
                [ActionManager addTitle:title url:url image:image];
            } else {
                [ActionManager addTitle:title url:url image:nil];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:QKApplicationReloadTableViewData object:nil];
        }
    } else {
        NSString *text = [dict objectForKey:@"text"];
        if (text.length) {
            [[NSNotificationCenter defaultCenter] postNotificationName:QKApplicationSetTextToSearchBar object:nil userInfo:dict];
        }
    }
    return YES;
}

- (NSDictionary *)parseQueryString:(NSString *)query
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:6];
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    
    for (NSString *pair in pairs) {
        NSArray *elements = [pair componentsSeparatedByString:@"="];
        NSString *key = [[elements objectAtIndex:0] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
        NSString *val = [[elements objectAtIndex:1] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
        [dict setObject:val forKey:key];
    }
    
    return dict;
}

@end
