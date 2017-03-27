//
//  BookmarkEditViewController.m
//  Quicka
//
//  Created by OCHIISHI Koichiro on 2013/10/05.
//  Copyright (c) 2013年 OCHIISHI Koichiro. All rights reserved.
//

#import "BookmarkEditViewController.h"

@interface BookmarkEditViewController ()

@property (nonatomic, strong) UITextField *titleField;
@property (nonatomic, strong) UITextField *urlField;

@end

@implementation BookmarkEditViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.navigationController setToolbarHidden:YES animated:YES];
    [self.tableView registerNib:[UINib nibWithNibName:@"TitleCell" bundle:nil] forCellReuseIdentifier:@"TitleCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"URLCell" bundle:nil] forCellReuseIdentifier:@"URLCell"];
    
    UIBarButtonItem *saveButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)];
    self.navigationItem.rightBarButtonItem = saveButtonItem;
    
    if (self.style == BookmarkEditViewControllerStyleInsert) {
        self.title = LSTR(@"New Bookmark");
        self.navigationItem.rightBarButtonItem.enabled = NO;
    } else {
        self.title = LSTR(@"Edit Bookmark");
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setToolbarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -

- (void)save
{
    if (self.style == BookmarkEditViewControllerStyleInsert) {
        [BrowserBookmarkManager addTitle:self.titleField.text url:self.urlField.text];
    } else {
        [BrowserBookmarkManager updateBookmark:self.bookmark title:self.titleField.text url:self.urlField.text];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        static NSString *CellIdentifier = @"TitleCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        // Configure the cell...
        if (self.titleField == nil) {
            self.titleField = (UITextField *)[cell viewWithTag:1];
            self.titleField.text = self.bookmark.title;
            self.titleField.delegate = self;
            self.titleField.returnKeyType = UIReturnKeyNext;
        }
        return cell;
    } else {
        static NSString *CellIdentifier = @"URLCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        // Configure the cell...
        if (self.urlField == nil) {
            self.urlField = (UITextField *)[cell viewWithTag:2];
            self.urlField.text = self.bookmark.url;
            self.urlField.delegate = self;
            self.urlField.returnKeyType = UIReturnKeyDone;
        }
        return cell;
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

@end
