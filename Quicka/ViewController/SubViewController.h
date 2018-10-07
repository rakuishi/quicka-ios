//
//  SubViewController.h
//  Quicka
//
//  Created by OCHIISHI Koichiro on 9/14/13.
//  Copyright (c) 2013 OCHIISHI Koichiro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

#import "QuickaUtil.h"
#import "CustomActivity.h"
#import "MyNavigationController.h"
#import "SourceCodeViewController.h"
#import "UIWebView+Quicka2.h"
#import "NSString+Quicka2.h"

@protocol SubViewControllerDelegate <NSObject>

- (void)scrollToMainViewControllerWithQuery:(NSString *)query;

@end

@interface SubViewController : UIViewController <UIScrollViewDelegate, WKNavigationDelegate, UIActionSheetDelegate, SourceCodeViewControllerDelegate>

@property (nonatomic, weak) id <SubViewControllerDelegate> delegate;
@property (nonatomic) WKWebView *webView;

- (void)searchWithQuery:(NSString *)query;
- (void)scrollToMainViewController;
- (void)goBack;
- (void)goForward;
- (void)refresh;
- (void)share;

@end

