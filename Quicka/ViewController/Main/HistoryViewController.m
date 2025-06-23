//
//  HistoryViewController.m
//  Quicka
//
//  Created by OCHIISHI Koichiro on 9/16/13.
//  Copyright (c) 2013 OCHIISHI Koichiro. All rights reserved.
//

#import "HistoryViewController.h"

@interface HistoryViewController ()

@property (nonatomic) NSMutableArray *histories;

@end

@implementation HistoryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setTitle:LSTR(@"Recents")];
    [self.tableView registerNib:[UINib nibWithNibName:@"DefaultCell" bundle:nil] forCellReuseIdentifier:@"DefaultCell"];
    
    UIBarButtonSystemItem systemItemDone;
    if (@available(iOS 26.0, *)) {
        systemItemDone = UIBarButtonSystemItemClose;
    } else {
        systemItemDone = UIBarButtonSystemItemDone;
    }
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:LSTR(@"Clear") style:UIBarButtonItemStylePlain target:self action:@selector(deleteButtonItemTapped)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:systemItemDone target:self action:@selector(doneButtonItemTapped)];
    
    self.histories = [[HistoryManager getAllData] mutableCopy];
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
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:LSTR(@"Cancel") style:UIAlertActionStyleCancel handler:nil]];

    [actionSheet addAction:[UIAlertAction actionWithTitle:LSTR(@"Clear All Recents") style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [HistoryManager deleteAllData];
        self.histories = [NSMutableArray new];
        [self.tableView reloadData];
    }]];
    
    [self presentViewController:actionSheet animated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.histories.count;
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
        
        RLMHistory *history = self.histories[indexPath.row];
        [HistoryManager deleteHistory:history];    // データベースから削除
        [self.histories removeObjectAtIndex:indexPath.row]; // 配列に持たせているデータを削除
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        
        [tableView endUpdates];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DefaultCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    RLMHistory *history = self.histories[indexPath.row];
    cell.textLabel.text = history.query;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RLMHistory *history = self.histories[indexPath.row];
    [self dismissViewControllerAnimated:YES completion:^{
        if ([self.delegate respondsToSelector:@selector(didSelectQuery:)]) {
            [self.delegate didSelectQuery:history.query];
        }
    }];
}

@end
