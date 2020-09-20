//
//  SelectImageViewController.m
//  Quicka
//
//  Created by OCHIISHI Koichiro on 10/6/13.
//  Copyright (c) 2013 OCHIISHI Koichiro. All rights reserved.
//

#import "SelectImageViewController.h"

@interface SelectImageViewController ()

@property (nonatomic, strong) NSArray *objects;

@end

@implementation SelectImageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = LSTR(@"Select Image");
    self.tableView.separatorInset = UIEdgeInsetsMake(0.f, 15.f, 0.f, 0.f);
    [self.tableView registerNib:[UINib nibWithNibName:@"DefaultIconCell" bundle:nil] forCellReuseIdentifier:@"DefaultIconCell"];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonItemTapped)];
    
    NSURL *url = [NSURL URLWithString:QK_IMAGE_JSON_URL];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.requestCachePolicy = NSURLRequestReloadIgnoringCacheData;
    configuration.timeoutIntervalForRequest = 10.f;
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionTask *task = [session dataTaskWithURL:url
                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
                                        if (!error) {
                                            self.objects = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                                            [self.tableView reloadData];
                                        }
                                    }];
    [task resume];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -

- (void)cancelButtonItemTapped
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
    return self.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DefaultIconCell";
    DefaultIconCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    NSDictionary *dict = self.objects[indexPath.row];
    
    cell.textLabel.text = [dict objectForKey:@"title"];

    __weak UIImageView *imageView = cell.imageView;
    [imageView sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"artworkUrl"]]
                 placeholderImage:[UIImage imageNamed:@"icon_placeholder"]
                          options:SDWebImageQueryMemoryData
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                            imageView.image = [QuickaUtil maskImage:image];
                        }];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIImage *image = cell.imageView.image;
    [self.delegate didSelectImage:image];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
