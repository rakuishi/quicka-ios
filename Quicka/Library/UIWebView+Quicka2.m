//
//  UIWebView+Quicka2.m
//  Quicka
//
//  Created by OCHIISHI Koichiro on 11/14/13.
//  Copyright (c) 2013 OCHIISHI Koichiro. All rights reserved.
//

#import "UIWebView+Quicka2.h"

@implementation UIWebView (Quicka2)

- (void)webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(id *)frame
{
    [[[UIAlertView alloc] initWithTitle:nil message:message
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil
      ] show];
}

@end
