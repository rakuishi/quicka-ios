//
//  CreateIconViewController.m
//  CollectionView
//
//  Created by OCHIISHI Koichiro on 11/3/13.
//  Copyright (c) 2013 OCHIISHI Koichiro. All rights reserved.
//

#import "CreateIconViewController.h"

@interface CreateIconViewController ()

@property (nonatomic, strong) NSArray *colors;
@property (nonatomic, strong) NSArray *icons;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, assign) NSInteger selectedColorIndex;
@property (nonatomic, assign) NSInteger selectedIconIndex;

@property (nonatomic, strong) UICollectionView *colorCollectionView;
@property (nonatomic, strong) UICollectionView *iconCollectionView;

@end

@implementation CreateIconViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = LSTR(@"Create Icon");
    
    [self.tableView registerNib:[UINib nibWithNibName:@"DefaultCenterCell" bundle:nil] forCellReuseIdentifier:@"DefaultCenterCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CollectionViewColorCell" bundle:nil] forCellReuseIdentifier:@"CollectionViewColorCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CollectionViewIconCell" bundle:nil] forCellReuseIdentifier:@"CollectionViewIconCell"];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonItemTapped)];
    
    self.colors = @[@"#157efb", @"#595ad3", @"#53d769", @"#fd9426", @"#fc3159", @"#fc3d39", @"#3ca8da", @"#8e8e93",
                    @"#1abc9c", @"#16a085", @"#2ecc71", @"#27ae60", @"#3498db", @"#2980b9", @"#9b59b6", @"#8e44ad",
                    @"#34495e", @"#2c3e50", @"#f1c40f", @"#f39c12", @"#e67e22", @"#d35400", @"#e74c3c", @"#c0392b",
                    @"#ecf0f1", @"#bdc3c7", @"#95a5a6", @"#7f8c8d"];
    self.icons = @[@"icon_appstore", @"icon_itunes", @"icon_world", @"icon_home", @"icon_clock", @"icon_book",
                   @"icon_controlcenter", @"icon_badge", @"icon_star", @"icon_setting", @"icon_check", @"icon_search",
                   @"icon_location", @"icon_place", @"icon_wifi", @"icon_microphone", @"icon_mail", @"icon_play",
                   @"icon_photo", @"icon_night", @"icon_icloud", @"icon_motion", @"icon_rocket", @"icon_transit",
                   @"icon_apple", @"icon_shopcart", @"icon_twitter", @"icon_facebook", @"icon_bookmark", @""];
    
    self.selectedColorIndex = 0;
    self.selectedIconIndex = 0;
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
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return LSTR(@"Preview");
        case 1:
            return LSTR(@"Select Color");
        case 2:
            return LSTR(@"Select Icon");
        default:
            return @"";
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return 44.f;
        default:
            return 100.f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *CellIdentifier = @"DefaultCenterCell";
        DefaultCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        // Configure the cell...
        cell.titleLabel.text = LSTR(@"Use this Icon");
        if (self.iconImageView == nil) {
            self.iconImageView = cell.imageView;
            UIImage *image = [self createImage:[UIImage imageNamed:self.icons[self.selectedIconIndex]]
                               backgroundColor:[self colorWithHexString:self.colors[self.selectedColorIndex]]];
            cell.imageView.image = image;
        }
        
        return cell;
    } else if (indexPath.section == 1) {
        static NSString *CellIdentifier = @"CollectionViewColorCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        // Configure the cell...
        if (self.colorCollectionView == nil) {
            self.colorCollectionView = (UICollectionView *)[cell viewWithTag:1];
            self.colorCollectionView.dataSource = self;
            self.colorCollectionView.delegate = self;
            
            [self.colorCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
        }
        
        return cell;
    } else {
        static NSString *CellIdentifier = @"CollectionViewIconCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        // Configure the cell...
        if (self.iconCollectionView == nil) {
            self.iconCollectionView = (UICollectionView *)[cell viewWithTag:2];
            self.iconCollectionView.dataSource = self;
            self.iconCollectionView.delegate = self;
            
            [self.iconCollectionView registerNib:[UINib nibWithNibName:@"MyCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];
        }
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        [self.delegate didCreateImage:self.iconImageView.image];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UICollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView.tag < 2) {
        return self.colors.count;
    } else {
        return self.icons.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag < 2) {
        
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
        cell.backgroundColor = [self colorWithHexString:self.colors[indexPath.row]];
        return cell;
        
    } else {

        MyCollectionViewCell *cell = (MyCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
        cell.backgroundColor = [self colorWithHexString:self.colors[self.selectedColorIndex]];
        cell.iconImageView.image = [UIImage imageNamed:self.icons[indexPath.row]];
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag < 2) {
        self.selectedColorIndex = indexPath.row;
        [self.iconCollectionView reloadData]; // 色を反映させる為に
    } else {
        self.selectedIconIndex = indexPath.row;
    }
    
    // 更新処理
    UIImage *image = [self createImage:[UIImage imageNamed:self.icons[self.selectedIconIndex]]
                       backgroundColor:[self colorWithHexString:self.colors[self.selectedColorIndex]]];
    [self.iconImageView setImage:image];
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    [UIView animateWithDuration:0.2f animations:^{
        cell.alpha = 0.f;
    }];
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    [UIView animateWithDuration:0.2f animations:^{
        cell.alpha = 1.f;
    }];
}

#pragma mark -

- (UIColor *)colorWithHexString:(NSString *)hexString
{
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

- (UIImage *)createImage:(UIImage *)image backgroundColor:(UIColor *)color
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 58.f, 58.f)];
    view.backgroundColor = color;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:view.frame];
    imageView.image = image;
    imageView.backgroundColor = [UIColor clearColor];
    [view addSubview:imageView];
    
    UIGraphicsBeginImageContext(view.frame.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *createImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [QuickaUtil maskImage:createImage];
}

@end
