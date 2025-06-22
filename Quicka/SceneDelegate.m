//
//  SceneDelegate.m
//  Quicka
//
//  Created by Koichiro OCHIISHI on 2025/06/23.
//  Copyright © 2025 OCHIISHI Koichiro. All rights reserved.
//

#import "SceneDelegate.h"

@interface SceneDelegate ()

@end

@implementation SceneDelegate

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    
    UIWindowScene *windowScene = (UIWindowScene *)scene;
    
    UIWindow *window = [[UIWindow alloc] initWithWindowScene:windowScene];
    window.rootViewController = [ContainerViewController new];
    window.backgroundColor = [UIColor blackColor];
    [window makeKeyAndVisible];
    
    self.window = window;
}

- (void)scene:(UIScene *)scene openURLContexts:(NSSet<UIOpenURLContext *> *)URLContexts {
    if (URLContexts.allObjects.count == 0) return;

    // if you handle your own URLs, do it here
    NSURL *url = URLContexts.allObjects[0].URL;
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
