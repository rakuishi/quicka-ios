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
    if (@available(iOS 26.0, *)) {
        // appearance for iOS 26.0 and later
    } else {
        NSDictionary *titleTextAttrs = @{NSForegroundColorAttributeName:[UIColor whiteColor]};

        [[UINavigationBar appearance] setTintColor:QK_TINT_COLOR];
        [[UINavigationBar appearance] setBarTintColor:QK_BAR_TINT_COLOR];
        [[UINavigationBar appearance] setTitleTextAttributes:titleTextAttrs];
        [[UINavigationBar appearance] setTranslucent:false];
        [[UIToolbar appearance] setTintColor:QK_TINT_COLOR];
        [[UIToolbar appearance] setBarTintColor:QK_BAR_TINT_COLOR];

        UINavigationBarAppearance *navBarAppearance = [UINavigationBarAppearance new];
        [navBarAppearance configureWithOpaqueBackground];
        [navBarAppearance configureWithDefaultBackground];
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
    
    return YES;
}

@end
