//
//  MyApplication.m
//  Quicka
//
//  Created by OCHIISHI Koichiro on 10/20/13.
//  Copyright (c) 2013 OCHIISHI Koichiro. All rights reserved.
//

#import "MyApplication.h"

@implementation MyApplication

- (BOOL)openURL:(NSURL *)url
{
    if ([[SourceCodeLinkManager sharedInstance] isSourceCodeLinkAvailable]) {
        // 通知の受取側に送る値を作成する
        NSDictionary *dict = [NSDictionary dictionaryWithObject:url
                                                         forKey:@"url"];
        
        // 通知を作成する
        NSNotification *notification = [NSNotification notificationWithName:@"openTappedURL"
                                                                     object:self
                                                                   userInfo:dict];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        
        return NO;
    } else {
        
        [super openURL:url];
        return YES;
    }
}

@end
