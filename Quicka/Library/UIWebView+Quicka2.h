//
//  UIWebView+Quicka2.h
//  Quicka
//
//  Created by OCHIISHI Koichiro on 11/14/13.
//  Copyright (c) 2013 OCHIISHI Koichiro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWebView (Quicka2)

// javascript:alert("hello world”); のような Alert を許可
- (void)webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(id *)frame;

@end
