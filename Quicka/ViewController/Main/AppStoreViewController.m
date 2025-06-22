//
//  AppStoreViewController.m
//  Quicka
//
//  Created by OCHIISHI Koichiro on 2013/10/05.
//  Copyright (c) 2013年 OCHIISHI Koichiro. All rights reserved.
//

#import "AppStoreViewController.h"

@interface AppStoreViewController ()

@property (nonatomic, strong) NSArray *objects;
@property (nonatomic, assign) BOOL isNoResult;

@end

@implementation AppStoreViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = LSTR(@"App Store");
    [self.tableView registerNib:[UINib nibWithNibName:@"DefaultCell" bundle:nil] forCellReuseIdentifier:@"DefaultCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"DefaultSubtitleIconCell" bundle:nil] forCellReuseIdentifier:@"DefaultSubtitleIconCell"];
    
    UIBarButtonSystemItem systemItemDone;
    if (@available(iOS 26.0, *)) {
        systemItemDone = UIBarButtonSystemItemClose;
    } else {
        systemItemDone = UIBarButtonSystemItemDone;
    }

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:systemItemDone target:self action:@selector(doneButtonItemTapped)];

    self.tableView.separatorInset = UIEdgeInsetsMake(0.f, 15.f, 0.f, 0.f);
    __weak UITableView *tableView = self.tableView;
    dispatch_queue_t q_main = dispatch_get_main_queue();
    
    self.query = [self.query stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:(JP) ? QK_APPSTORE_JP_URL(self.query) : QK_APPSTORE_EN_URL(self.query)];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.requestCachePolicy = NSURLRequestReloadIgnoringCacheData;
    configuration.timeoutIntervalForRequest = 10.f;
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionTask *task = [session dataTaskWithURL:url
                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
                                        dispatch_async(q_main, ^{
                                            if (!error) {
                                                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                                                self.objects = [dict objectForKey:@"results"];
                                                if (self.objects.count == 0) {
                                                    self.isNoResult = YES;
                                                }
                                                [tableView reloadData];
                                            }
                                        });
                                    }];
    [task resume];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -

- (void)doneButtonItemTapped
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isNoResult) {
        return 1;
    } else {
        return self.objects.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isNoResult) {
        static NSString *CellIdentifier = @"DefaultCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = LSTR(@"No results");
        return cell;
    } else {
        static NSString *CellIdentifier = @"DefaultSubtitleIconCell";
        DefaultSubtitleIconCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        NSDictionary *dict = self.objects[indexPath.row];
        
        NSString *genre = [[dict objectForKey:@"genres"] lastObject];
        NSInteger averageUserRating = [[dict objectForKey:@"averageUserRating"] integerValue];
        NSString *rating = @"";
        for (int i = 0; i < 5; i++) {
            if (i < averageUserRating) {
                rating = [rating stringByAppendingString:@"★"];
            } else {
                rating = [rating stringByAppendingString:@"☆"];
            }
        }
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@（%@）", [dict objectForKey:@"trackName"], [dict objectForKey:@"formattedPrice"]];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@", rating, genre];
        
        __weak UIImageView *imageView = cell.imageView;
        [imageView sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"artworkUrl60"]]
                     placeholderImage:[UIImage imageNamed:@"icon_placeholder"]
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                imageView.image = [QuickaUtil maskImage:image];
                            }];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.isNoResult) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        NSDictionary *dict = self.objects[indexPath.row];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:QK_APP_DOWNLOAD_URL([dict objectForKey:@"trackId"])] options:@{} completionHandler:nil];
    }
}

@end
