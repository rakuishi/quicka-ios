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
@property (nonatomic, strong) NSMutableArray *tempQueries;
@property (nonatomic, strong) NSMutableData *data;
@property (nonatomic, strong) NSURLConnection *connection;
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
            if (UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                self.backgroundColor = UIColor.systemBackgroundColor;
            } else {
                self.backgroundColor = UIColor.systemGray4Color;
            }
        } else {
            self.backgroundColor = UIColor.whiteColor;
        }
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.frame];
        self.scrollView.decelerationRate = UIScrollViewDecelerationRateFast;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.scrollsToTop = NO; // SubViewController における UIWebView のステータスバータップによる移動を許可するために
        [self addSubview:self.scrollView];
        
        // self.queries = [NSMutableArray arrayWithArray:@[@"新宿", @"原宿", @"渋谷", @"千駄ヶ谷", @"立川", @"池袋"]];
        // [self updateButtons];
        self.alpha = 0.f;
        
        // ステータスバーの変動に対応する
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(statusBarFrameWillChange:)
                                                     name:UIApplicationWillChangeStatusBarFrameNotification
                                                   object:nil];
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
    [self.connection cancel]; // 通信を都度キャンセルする
    self.data = [[NSMutableData alloc] initWithLength:0];
    if ([query length])  {
        NSString *URLString = [NSString stringWithFormat:@"https://www.google.com/complete/search?hl=ja&q=%@&output=toolbar", [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        NSURL *URL = [NSURL URLWithString:URLString];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10.f];
        // iPhone に指定されたユーザーエージェントでは, hl=ja の場合にデータを取得できない問題を偽装で解決する
        [request setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/31.0.1650.63 Safari/537.36" forHTTPHeaderField:@"User-Agent"];
        
        self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    } else {
        self.alpha = 0.f;
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [self.data setLength:0];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self.connection cancel];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    self.tempQueries = [NSMutableArray new];
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:self.data];
    parser.delegate = self;
    [parser parse];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"suggestion"]) {
        [self.tempQueries addObject:[attributeDict objectForKey:@"data"]];
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    if (self.tempQueries.count) {
        self.queries = self.tempQueries;
        [self updateButtons];
    } else {
        // 正しくデータが取得できていない時は、そのままデータを表示しておく
    }
}

@end
