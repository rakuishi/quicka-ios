//
//  HistoryViewController.m
//  Quicka
//
//  Created by OCHIISHI Koichiro on 9/16/13.
//  Copyright (c) 2013 OCHIISHI Koichiro. All rights reserved.
//

#import "HistoryViewController.h"

@interface HistoryViewController ()

@property (nonatomic) NSMutableArray *historys;

@end

@implementation HistoryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setTitle:LSTR(@"Recents")];
    [self.tableView registerNib:[UINib nibWithNibName:@"DefaultCell" bundle:nil] forCellReuseIdentifier:@"DefaultCell"];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:LSTR(@"Clear")
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self action:@selector(deleteButtonItemTapped)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                           target:self action:@selector(doneButtonItemTapped)];
    
    self.historys = [[HistoryManager getAllData] mutableCopy];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction

- (void)doneButtonItemTapped
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)deleteButtonItemTapped
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:LSTR(@"Cancel") destructiveButtonTitle:LSTR(@"Clear All Recents") otherButtonTitles:nil];
    [actionSheet showInView:self.view];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.destructiveButtonIndex == buttonIndex) {
        [HistoryManager deleteAllData];
        self.historys = [NSMutableArray new];
        [self.tableView reloadData];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.historys.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.f;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [tableView beginUpdates];
        
        Hisotry *history = self.historys[indexPath.row];
        [HistoryManager deleteHistory:history];    // データベースから削除
        [self.historys removeObjectAtIndex:indexPath.row]; // 配列に持たせているデータを削除
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        
        [tableView endUpdates];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DefaultCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    Hisotry *history = self.historys[indexPath.row];
    cell.textLabel.text = history.query;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Hisotry *history = self.historys[indexPath.row];
    [self dismissViewControllerAnimated:YES completion:^{
        if ([self.delegate respondsToSelector:@selector(didSelectQuery:)]) {
            [self.delegate didSelectQuery:history.query];
        }
    }];
}

@end
