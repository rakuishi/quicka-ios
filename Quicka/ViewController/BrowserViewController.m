//
//  BrowserViewController.m
//  Quicka
//
//  Created by rakuishi on 2017/05/14.
//  Copyright © 2017 OCHIISHI Koichiro. All rights reserved.
//

#import "BrowserViewController.h"
#import "QuickaUtil.h"

@interface BrowserViewController ()

@property (nonatomic, strong) NSArray *browserNames;

@end

@implementation BrowserViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = LSTR(@"Browser");
    self.browserNames = [QuickaUtil getBrowserNames];
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
    return self.browserNames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = LSTR(self.browserNames[indexPath.row]);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [QuickaUtil getBrowserIndex]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSIndexPath *preIndexPath = [NSIndexPath indexPathForRow:[QuickaUtil getBrowserIndex] inSection:0];
    
    // None, Reading List
    if (preIndexPath == indexPath) {
        return;
    }

    [self didSelectRowAtIndexPath:indexPath preIndexPath:preIndexPath];
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
    
    [QuickaUtil setBrowserIndex:indexPath.row];
}

@end
