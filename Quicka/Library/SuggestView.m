//
//  SuggestView.m
//  Quicka
//
//  Created by OCHIISHI Koichiro on 9/29/13.
//  Copyright (c) 2013 OCHIISHI Koichiro. All rights reserved.
//

#import "SuggestView.h"

// MainViewController からは、SuggestView を hidden で管理
// SuggestView 内では、自身を alpha で管理

int const kSuggestViewMaxQuery = 10;
CGFloat const kSuggestViewButtonPadding = 24.f;
CGFloat const kSuggestViewFrameSizeHeight = 36.f;

@interface SuggestView ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *buttonBaseView;
@property (nonatomic, strong) NSMutableArray *queries;
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSURLSessionDataTask *sessionDataTask;
@property (nonatomic, assign) CGRect keyboardRect;

@end

@implementation SuggestView {
    UIButton *_button[kSuggestViewMaxQuery];
}

#pragma mark -

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)init
{
    CGFloat width = [[UIScreen mainScreen] bounds].size.width;
    self = [super initWithFrame:CGRectMake(0.f, 0.f, width, kSuggestViewFrameSizeHeight)];
    if (self) {
        if (@available(iOS 13.0, *)) {
            self.backgroundColor = UIColor.systemGray5Color;
        } else {
            self.backgroundColor = UIColor.whiteColor;
        }
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.frame];
        self.scrollView.decelerationRate = UIScrollViewDecelerationRateFast;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.scrollsToTop = NO; // SubViewController における UIWebView のステータスバータップによる移動を許可するために
        [self addSubview:self.scrollView];
        
        self.alpha = 0.f;
        
        // ステータスバーの変動に対応する
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(statusBarFrameWillChange:)
                                                     name:UIApplicationWillChangeStatusBarFrameNotification
                                                   object:nil];
        
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.session = [NSURLSession sessionWithConfiguration:config];
    }

    return self;
}

- (void)statusBarFrameWillChange:(NSNotification *)notification
{
    [self moveOriginY];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationWillChangeStatusBarFrameNotification
                                                  object:nil];
}

- (void)moveOriginYFromKeyboardRect:(CGRect)frame
{
    self.keyboardRect = frame;
    [self moveOriginY];
}

- (void)moveOriginY
{
    CGRect toRect = self.keyboardRect;
    toRect.origin.y = self.keyboardRect.origin.y - kSuggestViewFrameSizeHeight;
    toRect.size.height = kSuggestViewFrameSizeHeight;
    self.frame = toRect;
}

- (void)updateButtons
{
    if (self.queries.count == 0) {
        self.alpha = 0.f;
        return;
    }
    
    // 初期化
    [self.buttonBaseView removeFromSuperview];
    self.buttonBaseView = nil;
    
    for (int i = 0; i < kSuggestViewMaxQuery; i++) {
        [_button[i] removeFromSuperview];
        _button[i] = nil;
    }
    
    UIFont *font = [UIFont systemFontOfSize:17.f];
    
    int max = (int) MIN(self.queries.count, kSuggestViewMaxQuery);

    for (int i = 0; i < max; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        CGSize size = [self.queries[i] sizeWithAttributes:@{NSFontAttributeName:font}];
        
        if (i == 0) {
            button.frame = CGRectMake(0.f , 0.f, size.width + kSuggestViewButtonPadding, kSuggestViewFrameSizeHeight);
        } else {
            button.frame = CGRectMake(0.f + CGRectGetMaxX(_button[i-1].frame), 0.f, size.width + kSuggestViewButtonPadding, kSuggestViewFrameSizeHeight);
        }
        
        [button setTag:i];
        [button setTitle:self.queries[i] forState:UIControlStateNormal];
        [button.titleLabel setFont:font];
        if (@available(iOS 13.0, *)) {
            [button setTitleColor:UIColor.labelColor forState:UIControlStateNormal];
            [button setTitleColor:UIColor.secondaryLabelColor forState:UIControlStateHighlighted];
        } else {
            [button setTitleColor:UIColor.darkTextColor forState:UIControlStateNormal];
            [button setTitleColor:UIColor.lightTextColor forState:UIControlStateHighlighted];
        }
        [button setTitleEdgeInsets:UIEdgeInsetsMake(3.f, 0.f, 0.f, 0.f)];
        [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        _button[i] = button;
    }
    
    // UIButton が載る BaseView を作成する
    self.buttonBaseView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, CGRectGetMaxX(_button[max - 1].frame), kSuggestViewFrameSizeHeight)];
    self.buttonBaseView.backgroundColor = [UIColor clearColor];
    
    for (int i = 0; i < max; i++) {
        [self.buttonBaseView addSubview:_button[i]];
    }
    
    // スクロールバーの可動域を設定する
    self.scrollView.contentSize = self.buttonBaseView.frame.size;
    [self.scrollView addSubview:self.buttonBaseView];
    
    // スクロール位置を最初にする
    [self.scrollView scrollRectToVisible:_scrollView.frame animated:YES];
    self.alpha = 1.f;
}

- (void)buttonTapped:(UIButton *)button
{
    if (button.tag < self.queries.count) {
        [self.delegate selectedSuggestedWord:self.queries[button.tag]];
    }
}

#pragma mark -

- (void)setQuery:(NSString *)query
{
    if (self.sessionDataTask != nil) {
        [self.sessionDataTask cancel];
    }

    if ([query length])  {
        NSString *URLString = [NSString stringWithFormat:@"https://www.google.com/complete/search?hl=ja&q=%@&output=toolbar", [query stringByAddingPercentEncodingWithAllowedCharacters: NSCharacterSet.alphanumericCharacterSet]];
        
        NSURL *URL = [NSURL URLWithString:URLString];
        self.sessionDataTask = [self.session dataTaskWithURL:URL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (data != nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self parse:[[NSString alloc] initWithData:data encoding:NSShiftJISStringEncoding]];
                });
            }
        }];
        [self.sessionDataTask resume];
        
    } else {
        self.alpha = 0.f;
    }
}

- (void)parse:(NSString *)text {
    NSMutableArray *queries = [NSMutableArray new];

    NSString *pattern = @"<suggestion data=\\\"(.*?)\\\"/>";
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    if (error == nil) {
        NSArray *matches = [regex matchesInString:text options:0 range:NSMakeRange(0, text.length)];
        for (NSTextCheckingResult *match in matches) {
            [queries addObject:[text substringWithRange:[match rangeAtIndex:1]]];
        }
    }
    
    if ([queries count] > 0) {
        self.queries = queries;
        [self updateButtons];
    }
}

@end
