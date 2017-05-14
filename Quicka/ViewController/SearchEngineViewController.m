//
//  SearchEngineViewController.m
//  Quicka
//
//  Created by OCHIISHI Koichiro on 10/4/13.
//  Copyright (c) 2013 OCHIISHI Koichiro. All rights reserved.
//

#import "SearchEngineViewController.h"
#import "MyNavigationController.h"
#import "QuickaUtil.h"

@interface SearchEngineViewController ()

@property (nonatomic, strong) NSArray *searchEngineNames;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) NSIndexPath *preIndexPath;

@end

@implementation SearchEngineViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = LSTR(@"Search Engine");
    self.searchEngineNames = [QuickaUtil getSearchEngineNames];
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
    return self.searchEngineNames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = self.searchEngineNames[indexPath.row];
    cell.detailTextLabel.text = [QuickaUtil getSearchEngineURLWithIndex:indexPath.row];

    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [QuickaUtil getSearchEngineIndex]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSIndexPath *preIndexPath = [NSIndexPath indexPathForRow:[QuickaUtil getSearchEngineIndex] inSection:0];
    
    if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2) {
        // Google, Yahoo!, Bing
        if (preIndexPath == indexPath) {
            return;
        }
        [self didSelectRowAtIndexPath:indexPath preIndexPath:preIndexPath];
    } else {
        // Custom
        self.indexPath = indexPath;
        self.preIndexPath = preIndexPath;
        
        CustomEngineViewController *viewController = [[CustomEngineViewController alloc] initWithStyle:UITableViewStyleGrouped];
        viewController.delegate = self;
        MyNavigationController *navigationController = [[MyNavigationController alloc] initWithRootViewController:viewController];
        [self presentViewController:navigationController animated:YES completion:nil];
    }
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
    
    [QuickaUtil setSearchEngineIndex:indexPath.row];
}

#pragma mark - CustomEngineViewControllerDelegate

- (void)didEditCustomEngine
{
    [self didSelectRowAtIndexPath:self.indexPath preIndexPath:self.preIndexPath];
    [self.tableView reloadData];
}

@end
