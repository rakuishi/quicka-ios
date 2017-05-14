//
//  ServiceViewController.m
//  Quicka
//
//  Created by OCHIISHI Koichiro on 10/29/13.
//  Copyright (c) 2013 OCHIISHI Koichiro. All rights reserved.
//

#import "ReadLaterViewController.h"
#import "QuickaUtil.h"
#import "PocketAPI.h"

@interface ReadLaterViewController ()

@property (nonatomic, strong) NSArray *readLaterNames;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) NSIndexPath *preIndexPath;

@end

@implementation ReadLaterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = LSTR(@"Read Later");
    self.readLaterNames = [QuickaUtil getReadLaterNames];
    self.tableView.tintColor = QK_BAR_TINT_COLOR; // チェックマーク色
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.readLaterNames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = LSTR(self.readLaterNames[indexPath.row]);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [QuickaUtil getReadLaterIndex]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSIndexPath *preIndexPath = [NSIndexPath indexPathForRow:[QuickaUtil getReadLaterIndex] inSection:0];
    
    if (indexPath.row == 0 || indexPath.row == 1) {
        // None, Reading List
        if (preIndexPath == indexPath) {
            return;
        }
        [self didSelectRowAtIndexPath:indexPath preIndexPath:preIndexPath];
        
    } else {
        // Pocket
        
        self.indexPath = indexPath;
        self.preIndexPath = preIndexPath;
        
        if ([[PocketAPI sharedAPI] isLoggedIn]) {
            NSString *title = [NSString stringWithFormat:LSTR(@"You are logged in as %@"), [[PocketAPI sharedAPI] username]];
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:LSTR(@"Cancel") destructiveButtonTitle:LSTR(@"Change Account") otherButtonTitles:LSTR(@"Use This Account"), nil];
            [actionSheet showInView:self.view];
        } else {
            [self loginPocket];
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return LSTR(@"This setting is enabled to use on Quicka Browser only.");
}

#pragma mark -

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath preIndexPath:(NSIndexPath *)preIndexPath
{
    {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:preIndexPath];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    [QuickaUtil setReadLaterIndex:indexPath.row];
}

- (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}

- (void)loginPocket
{
    [[PocketAPI sharedAPI] loginWithHandler:^(PocketAPI *api, NSError *error) {
        if (error) {
            [self showAlertViewWithTitle:@"Pocket" message:[NSString stringWithFormat:@"Error: %@", error.description]];
        } else {
            [self showAlertViewWithTitle:@"Pocket" message:[NSString stringWithFormat:LSTR(@"Logged in as %@."), api.username]];
            [self didSelectRowAtIndexPath:self.indexPath preIndexPath:self.preIndexPath];
        }
    }];
}

#pragma mark -

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.cancelButtonIndex == buttonIndex) {
        // ...
    } else if (actionSheet.destructiveButtonIndex == buttonIndex) {
        [self loginPocket];
    } else {
        [self didSelectRowAtIndexPath:self.indexPath preIndexPath:self.preIndexPath];
    }
}

@end
