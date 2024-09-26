//
//  EditViewController.m
//  Quicka
//
//  Created by OCHIISHI Koichiro on 9/16/13.
//  Copyright (c) 2013 OCHIISHI Koichiro. All rights reserved.
//

#import "EditViewController.h"

@interface EditViewController ()

@property (nonatomic) UITextField *titleField;
@property (nonatomic) UITextField *urlField;
@property (nonatomic) UIImageView *iconImageView;
@property (nonatomic) NSString *trackId; // Download する場合
@property (nonatomic) NSArray *json;

@end

@implementation EditViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.separatorInset = UIEdgeInsetsMake(0.f, 15.f, 0.f, 0.f);
    [self.tableView registerNib:[UINib nibWithNibName:@"DefaultSubtitleIconCell" bundle:nil] forCellReuseIdentifier:@"DefaultSubtitleIconCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"DefaultCenterCell" bundle:nil] forCellReuseIdentifier:@"DefaultCenterCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TitleCell" bundle:nil] forCellReuseIdentifier:@"TitleCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"URLCell" bundle:nil] forCellReuseIdentifier:@"URLCell"];
    
    UIBarButtonItem *saveButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)];
    self.navigationItem.rightBarButtonItem = saveButtonItem;
    
    if (self.style == EditViewControllerStyleInsert) {
        self.title = LSTR(@"New Action");
        self.navigationItem.rightBarButtonItem.enabled = NO;
        dispatch_queue_t q_main = dispatch_get_main_queue();
        
        NSURL *url = [NSURL URLWithString:QK_ACTION_JSON_URL];
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.requestCachePolicy = NSURLRequestReloadIgnoringCacheData;
        configuration.timeoutIntervalForRequest = 10.f;
        
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
        NSURLSessionTask *task = [session dataTaskWithURL:url
                                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                            dispatch_async(q_main, ^{
                                                if (!error) {
                                                    self.json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                                                    [self.tableView reloadData];
                                                }
                                            });
                                        }];
        [task resume];
        
    } else if (self.style == EditViewControllerStyleEdit) {
        self.title = LSTR(@"Edit Action");
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:YES animated:YES];
    [self postNotificationWithScrollEnabled:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setToolbarHidden:NO animated:YES];
    [self postNotificationWithScrollEnabled:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -

- (void)save
{
    if (self.style == EditViewControllerStyleInsert) {
        
        [ActionManager addTitle:self.titleField.text
                            url:self.urlField.text
                          image:self.iconImageView.image];
        
    } else if (self.style == EditViewControllerStyleEdit) {
        
        [ActionManager updateAction:self.action
                              title:self.titleField.text
                                url:self.urlField.text
                              image:self.iconImageView.image];
    }
    
    if ([self.delegate respondsToSelector:@selector(didFinishSave)]) {
        [self.delegate didFinishSave];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)checkToSaveButtonItemEnabled
{
    if (self.titleField.text.length && self.urlField.text.length) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    } else {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

- (void)postNotificationWithScrollEnabled:(BOOL)enable
{
    NSDictionary *userInfo = @{@"enable": [NSNumber numberWithBool:enable]};
    NSNotification *notification = [NSNotification notificationWithName:@"didChangeToUseBuiltInBrowser"
                                                                 object:self
                                                               userInfo:userInfo];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.style == EditViewControllerStyleInsert) {
        return (_json.count) ? 2 : 1;
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    } else {
        return _json.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    } else {
        return LSTR(@"Select From Library");
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            static NSString *CellIdentifier = @"TitleCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            
            // Configure the cell...
            if (self.titleField == nil) {
                self.titleField = (UITextField *)[cell viewWithTag:1];
                self.titleField.delegate = self;
                self.titleField.returnKeyType = UIReturnKeyNext;
                if (@available(iOS 13.0, *)) {
                    self.titleField.textColor = UIColor.labelColor;
                }
                if (self.action) {
                    self.titleField.text = self.action.title;
                }
            }
            return cell;
        } else if (indexPath.row == 1) {
            static NSString *CellIdentifier = @"URLCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            // Configure the cell...
            if (self.urlField == nil) {
                self.urlField = (UITextField *)[cell viewWithTag:2];
                self.urlField.delegate = self;
                self.urlField.returnKeyType = UIReturnKeyDone;
                if (@available(iOS 13.0, *)) {
                    self.urlField.textColor = UIColor.labelColor;
                }
                if (self.action) {
                    self.urlField.text = self.action.url;
                }
            }
            return cell;
        } else {
            static NSString *CellIdentifier = @"DefaultCenterCell";
            DefaultCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            cell.titleLabel.text = LSTR(@"Select Image");
            // Configure the cell...
            if (self.iconImageView == nil) {
                self.iconImageView = (UIImageView *)[cell viewWithTag:3];
                if (self.action) {
                    self.iconImageView.image = [QuickaUtil maskImage:[UIImage imageWithContentsOfFile:IMAGE_PATH(self.action.imageName)]];
                } else {
                    self.iconImageView.image = [QuickaUtil maskImage:[UIImage imageNamed:@"icon_placeholder"]];
                }
            }
            return cell;
        }
    } else {
        static NSString *CellIdentifier = @"DefaultSubtitleIconCell";
        DefaultSubtitleIconCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        NSDictionary *dict = _json[indexPath.row];
        NSString *title = (JP) ? [dict objectForKey:@"title_ja"] : [dict objectForKey:@"title"];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@", [dict objectForKey:@"trackName"], title];
        cell.detailTextLabel.text = [dict objectForKey:@"url"];
        
        __weak UIImageView *imageView = cell.imageView;
        [imageView sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"artworkUrl"]]
                     placeholderImage:[UIImage imageNamed:@"icon_placeholder"]
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                imageView.image = [QuickaUtil maskImage:image];
                            }];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        NSDictionary *dict = _json[indexPath.row];
        NSString *URLString = [dict objectForKey:@"url"];
        NSString *title = (JP) ? [dict objectForKey:@"title_ja"] : [dict objectForKey:@"title"];
        
        self.titleField.text = [NSString stringWithFormat:@"%@ - %@", [dict objectForKey:@"trackName"], title];
        self.urlField.text = URLString;
        
        __weak UIImageView *imageView = self.iconImageView;
        [imageView sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"artworkUrl"]]
                     placeholderImage:[UIImage imageNamed:@"icon_placeholder"]
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                imageView.image = [QuickaUtil maskImage:image];
                            }];
        
        [self checkToSaveButtonItemEnabled];
        [self.tableView setContentOffset:CGPointZero animated:YES];
        
    } else if (indexPath.section == 0 && indexPath.row == 2) {

        [self showActionSheet];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self checkToSaveButtonItemEnabled];
    
    if (textField.returnKeyType == UIReturnKeyNext) {
        [self.urlField becomeFirstResponder];
    } else {
        [self.urlField resignFirstResponder];
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    self.navigationItem.rightBarButtonItem.enabled = NO;
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *text1 = self.titleField.text;
    NSString *text2 = self.urlField.text;
    
    NSString *text = textField.text;
    text = [text stringByReplacingCharactersInRange:range withString:string];
    if (textField.tag == 1) {
        text1 = text;
    } else {
        text2 = text;
    }
    
    self.navigationItem.rightBarButtonItem.enabled = (text1.length && text2.length);
    
    return YES;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.titleField resignFirstResponder];
    [self.urlField resignFirstResponder];
}

#pragma mark - UIActionSheet

- (void)showActionSheet
{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    [actionSheet addAction:[UIAlertAction actionWithTitle:LSTR(@"Cancel") style:UIAlertActionStyleCancel handler:nil]];

    [actionSheet addAction:[UIAlertAction actionWithTitle:LSTR(@"Select From Photos App") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            picker.allowsEditing = YES;
            picker.delegate = self;
            [self presentViewController:picker animated:YES completion:nil];
        }
    }]];

    [actionSheet addAction:[UIAlertAction actionWithTitle:LSTR(@"Select From Quicka's Library") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        SelectImageViewController *viewController = [[SelectImageViewController alloc] initWithStyle:UITableViewStylePlain];
        viewController.delegate = self;
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
        [self presentViewController:navigationController animated:YES completion:nil];
    }]];

    [actionSheet addAction:[UIAlertAction actionWithTitle:LSTR(@"Create Icon") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        CreateIconViewController *viewController = [[CreateIconViewController alloc] initWithStyle:UITableViewStyleGrouped];
        viewController.delegate = self;
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
        [self presentViewController:navigationController animated:YES completion:nil];
    }]];

    [self presentViewController:actionSheet animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];

    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    UIImage *newImage = [QuickaUtil resizeImage:image toSize:CGSizeMake(58.f, 58.f)];
    self.iconImageView.image = [QuickaUtil maskImage:newImage];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - SelectImageViewControllerDelegate

- (void)didSelectImage:(UIImage *)image
{
    self.iconImageView.image = image;
}

#pragma mark - CreateIconViewControllerDelegate

- (void)didCreateImage:(UIImage *)image
{
    self.iconImageView.image = image;
}

@end
