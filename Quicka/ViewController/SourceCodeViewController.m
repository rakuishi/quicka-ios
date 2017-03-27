//
//  SourceCodeViewController.m
//  Quicka
//
//  Created by OCHIISHI Koichiro on 10/16/13.
//  Copyright (c) 2013 OCHIISHI Koichiro. All rights reserved.
//

#import "SourceCodeViewController.h"

@interface SourceCodeViewController ()

@property (nonatomic, strong) UITextView *textView;

@end

@implementation SourceCodeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"barbuttonitem_share"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(shareButtonItemTapped)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                           target:self
                                                                                           action:@selector(doneButtonItemTapped)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(openTappedURL:)
                                                 name:@"openTappedURL"
                                               object:nil];
    
    CGRect frame = self.view.frame;
    frame.size.height = frame.size.height - 20.f - 44.f;
    self.textView = [[UITextView alloc] initWithFrame:frame];
    self.textView.editable = NO;
    self.textView.dataDetectorTypes = UIDataDetectorTypeLink;
    [self.view addSubview:self.textView];
    
    [self getContentFromURL:self.URL userAgent:self.userAgent];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[SourceCodeLinkManager sharedInstance] setSourceCodeLinkAvailable:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[SourceCodeLinkManager sharedInstance] setSourceCodeLinkAvailable:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -

- (void)shareButtonItemTapped
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Mail", nil),
                                  NSLocalizedString(@"Copy", nil), nil];
    [actionSheet showInView:self.view];
}

- (void)doneButtonItemTapped
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)openTappedURL:(NSNotification *)notification
{
    // 通知の送信側から送られた値を取得する
    NSURL *URL = [[notification userInfo] objectForKey:@"url"];
    [self.delegate didSelectURL:URL];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)getContentFromURL:(NSURL *)URL userAgent:(NSString *)userAgent
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL];
    [request setValue:userAgent forHTTPHeaderField:@"User-Agent"];
    
    dispatch_queue_t q_global = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_queue_t q_main = dispatch_get_main_queue();
    
    dispatch_async(q_global, ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        NSURLResponse *response = nil;
        NSError *error = nil;
        
        NSData *data = [NSURLConnection sendSynchronousRequest:request
                                             returningResponse:&response
                                                         error:&error];
        
        int encodes[] = {
            NSUTF8StringEncoding,        // UTF-8
            NSShiftJISStringEncoding,    // Shift JIS
            NSJapaneseEUCStringEncoding, // Japanees EUC
            NSISO2022JPStringEncoding,   // JIS
            NSUnicodeStringEncoding,     // Unicode
            NSASCIIStringEncoding        // ASCII
        };
        
        NSString *page = nil;
        int limit = sizeof(encodes) / sizeof(encodes[0]);
        for (int i = 0; i < limit; i++) {
            page = [[NSString alloc] initWithData:data encoding:encodes[i]];
            if (page != nil) {
                // DLog(@"%d", i);
                break;
            }
        }
        
        dispatch_async(q_main, ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            if (error) {
                // DLog(@"%@", error);
            } else {
                // DLog(@"%@", page);
                self.textView.text = page;
            }
        });
    });
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0: {
            // メールで共有する
            MFMailComposeViewController *composeViewController = [MFMailComposeViewController new];
            composeViewController.mailComposeDelegate = self;
            [composeViewController setSubject:self.title];
            [composeViewController setMessageBody:[NSString stringWithFormat:@"\n%@", self.textView.text] isHTML:NO];
            [self presentViewController:composeViewController animated:YES completion:nil];
            break;
        }
        case 1: {
            // コピーする
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            [pasteboard setValue:self.textView.text forPasteboardType: @"public.utf8-plain-text"];
            break;
        }
        default:
            // キャンセル
            break;
    }
}

#pragma mark - MFMailComposeViewController delegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
