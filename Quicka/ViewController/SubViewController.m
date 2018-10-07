//
//  SubViewController.m
//  Quicka
//
//  Created by OCHIISHI Koichiro on 9/14/13.
//  Copyright (c) 2013 OCHIISHI Koichiro. All rights reserved.
//

#import "SubViewController.h"

@interface SubViewController ()

@property (nonatomic) UILabel *barTitleLabel;
@property (nonatomic) UIButton *barUrlButton;
@property (nonatomic) UIBarButtonItem *goBackButtonItem;
@property (nonatomic) UIBarButtonItem *goForwardButtonItem;
@property (nonatomic) UIBarButtonItem *refreshButtonItem;
@property (nonatomic) UIBarButtonItem *shareButtonItem;

@property (nonatomic, assign) CGPoint scrollBeginingPoint;
@property (nonatomic, strong) NSString *userAgent;

@end

@implementation SubViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];

    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(60.f, 0.f, 200.f, 44.f)];
    self.navigationItem.titleView = titleView;
    
    self.barTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 3.f, 200.f, 18.f)];
    [self.barTitleLabel setTextColor:[UIColor whiteColor]];
    [self.barTitleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.barTitleLabel setFont:[UIFont boldSystemFontOfSize:14.f]];
    [titleView addSubview:self.barTitleLabel];
    
    self.barUrlButton = [[UIButton alloc] initWithFrame:CGRectMake(0.f, 20.f, 200.f, 18.f)];
    [self.barUrlButton.titleLabel setFont:[UIFont systemFontOfSize:12.f]];
    [self.barUrlButton setTitleColor:QK_TINT_COLOR forState:UIControlStateNormal];
    [self.barUrlButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.barUrlButton addTarget:self action:@selector(barUrlButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:self.barUrlButton];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"barbuttonitem_back"] style:UIBarButtonItemStylePlain target:self action:@selector(scrollToMainViewController)];
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    self.goBackButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"barbuttonitem_arrow_left"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    self.goForwardButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"barbuttonitem_arrow_right"] style:UIBarButtonItemStylePlain target:self action:@selector(goForward)];
    self.refreshButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)];
    self.shareButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"barbuttonitem_share"] style:UIBarButtonItemStylePlain target:self action:@selector(share)];
    self.toolbarItems = @[self.goBackButtonItem, flexibleSpace, self.goForwardButtonItem, flexibleSpace, self.refreshButtonItem, flexibleSpace, self.shareButtonItem];
    
    self.goBackButtonItem.enabled = NO;
    self.goForwardButtonItem.enabled = NO;
    self.refreshButtonItem.enabled = NO;
    self.shareButtonItem.enabled = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    // `viewDidLoad` でインスタンスを生成するのと比較して 50ms 短縮
    if (self.webView == nil) {
        CGSize size = [[UIScreen mainScreen] bounds].size;
        CGRect frame = CGRectMake(0.f, 0.f, size.width, size.height - 20.f - 44.f - 44.f);
        
        self.webView = [[WKWebView alloc] initWithFrame:frame];
        [self.webView setNavigationDelegate:self];
        [self.webView setHidden:YES];
        [self.view addSubview:self.webView];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -

- (void)searchWithQuery:(NSString *)query
{
    NSString *URLString = @"";
    if ([query hasPrefix:@"http:"] || [query hasPrefix:@"https:"]) {
        URLString = query;
    } else {
        query = [query UTF8EncodedString];
        URLString = [NSString stringWithFormat:[QuickaUtil getSearchEngineURL], query];
    }
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:URLString]]];
    [self.webView setHidden:NO];
}

- (void)viewSourceCode:(NSURL *)URL
{
    SourceCodeViewController *viewController = [SourceCodeViewController new];
    viewController.delegate = self;
    viewController.URL = URL;
    viewController.title = self.webView.title;
    viewController.userAgent = self.userAgent;
    MyNavigationController *navigationController = [[MyNavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark - SourceCodeViewControllerDelegate

- (void)didSelectURL:(NSURL *)URL
{
    [self.webView loadRequest:[NSURLRequest requestWithURL:URL]];
    [self.webView setHidden:NO];
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
	self.goBackButtonItem.enabled = _webView.canGoBack;
	self.goForwardButtonItem.enabled = _webView.canGoForward;
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    NSString *title = self.webView.title;
    NSString *url = [self.webView.URL absoluteString];
    
    self.barTitleLabel.text = title;
    [self.barUrlButton setTitle:[url UTF8DecodedString] forState:UIControlStateNormal];

	self.goBackButtonItem.enabled = _webView.canGoBack;
	self.goForwardButtonItem.enabled = _webView.canGoForward;
    
    self.refreshButtonItem.enabled = YES;
    self.shareButtonItem.enabled = YES;
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

	self.goBackButtonItem.enabled = _webView.canGoBack;
	self.goForwardButtonItem.enabled = _webView.canGoForward;
}

#pragma mark - UINavigationBarItems

- (void)barUrlButtonTapped:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(scrollToMainViewControllerWithQuery:)]) {
        [self.delegate scrollToMainViewControllerWithQuery:[sender.titleLabel.text UTF8DecodedString]];
    }
}

- (void)scrollToMainViewController
{
    if ([self.delegate respondsToSelector:@selector(scrollToMainViewControllerWithQuery:)]) {
        [self.delegate scrollToMainViewControllerWithQuery:nil];
    }
}

#pragma mark - UIToolbarItems

- (void)goBack
{
    if ([self.webView canGoBack]) {
		[self.webView goBack];
	}
}

- (void)goForward
{
    if ([self.webView canGoForward]) {
		[self.webView goForward];
	}
}

- (void)refresh
{
    [self.webView reload];
}

- (void)share
{
    NSString *title = self.webView.title;
    NSURL *URL = self.webView.URL;
    [self.webView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id _Nullable userAgent, NSError * _Nullable error) {
        self.userAgent = userAgent;
    }];

    NSArray *applicationActivities = [CustomActivity getApplicationActivities];
    UIActivityViewController *activityView = [[UIActivityViewController alloc] initWithActivityItems:@[title, URL] applicationActivities:applicationActivities];
    activityView.excludedActivityTypes = @[UIActivityTypeAirDrop, UIActivityTypeCopyToPasteboard, UIActivityTypeAddToReadingList];
    
    [activityView setCompletionWithItemsHandler:^(NSString * __nullable activityType, BOOL completed, NSArray * __nullable returnedItems, NSError * __nullable activityError) {
        if ([activityType isEqualToString:@"View Source"]) {
            [self viewSourceCode:URL];
        }
    }];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:activityView animated:YES completion:nil];
    });
}

@end
