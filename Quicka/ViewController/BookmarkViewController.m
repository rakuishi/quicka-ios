//
//  BookmarkViewController.m
//  Quicka
//
//  Created by OCHIISHI Koichiro on 10/5/13.
//  Copyright (c) 2013 OCHIISHI Koichiro. All rights reserved.
//

#import "BookmarkViewController.h"

@interface BookmarkViewController ()

@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) NSMutableArray *objects;
@property (nonatomic, strong) UIBarButtonItem *doneButtonItem;

@end

@implementation BookmarkViewController

// TODO: 使用頻度の高いと思われる JavaScript のプリセットを登録

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    [self.tableView setAllowsSelectionDuringEditing:YES];
    [self.tableView registerNib:[UINib nibWithNibName:@"BookmarkCell" bundle:nil] forCellReuseIdentifier:@"BookmarkCell"];
    [self.navigationController.toolbar setTranslucent:NO];
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.doneButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                        target:self
                                                                        action:@selector(doneButtonItemTapped)];
    self.navigationItem.rightBarButtonItem = self.doneButtonItem;
    
    CGFloat x = ([[UIScreen mainScreen] bounds].size.width - 200.f) / 2.f;
    
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:@[LSTR(@"Bookmarks"), LSTR(@"History")]];
    self.segmentedControl.frame = CGRectMake(x, 7.f, 200.f, 30.f);
    [self.segmentedControl addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.segmentedControl.selectedSegmentIndex = [QuickaUtil integerForKey:kQuickaBookmarkSegmentedControlIndex];
    for (int i = 0; i < self.segmentedControl.numberOfSegments; i++) {
        [self.segmentedControl setContentOffset:CGSizeMake(0.f, 1.f) forSegmentAtIndex:i];
    }
    [self.navigationController.toolbar addSubview:self.segmentedControl];
    
    [self refreshBarButtonItemWithSegmentIndex:self.segmentedControl.selectedSegmentIndex];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
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

- (void)deleteAllHistorys
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:LSTR(@"Cancel") destructiveButtonTitle:LSTR(@"Clear All Recents") otherButtonTitles:nil];
    [actionSheet showInView:self.view.window];
}

- (void)segmentedControlValueChanged:(UISegmentedControl *)segmentedControl
{
    [self setEditing:NO animated:NO];
    
    [QuickaUtil setInteger:segmentedControl.selectedSegmentIndex forKey:kQuickaBookmarkSegmentedControlIndex];
    [self refreshBarButtonItemWithSegmentIndex:segmentedControl.selectedSegmentIndex];
}

- (void)refreshBarButtonItemWithSegmentIndex:(NSInteger)index
{
    if (index == 0) {
        
        self.title = LSTR(@"Bookmarks");
        self.navigationItem.leftBarButtonItem = self.editButtonItem;
        
    } else {
        
        self.title = LSTR(@"History");
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:LSTR(@"Clear")
                                                                                 style:UIBarButtonItemStylePlain
                                                                                target:self
                                                                                action:@selector(deleteAllHistorys)];
    }
    
    [self reloadDataWithSegmentIndex:index];
}

- (void)reloadDataWithSegmentIndex:(NSInteger)index
{
    if (index == 0) {
        self.objects = [BrowserBookmarkManager getAllData];
    } else {
        self.objects = [BrowserHistoryManager getAllData];
    }
    [self.tableView reloadData];
}

#pragma mark - BookmarkEditViewControllerDelegate

- (void)didFinishSave
{
    [self reloadDataWithSegmentIndex:self.segmentedControl.selectedSegmentIndex];
}

#pragma mark - UIViewController

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    BOOL shouldNeedDeleteInsertCell = NO;
    if (self.tableView.editing == YES && self.segmentedControl.selectedSegmentIndex == 0) {
        shouldNeedDeleteInsertCell = YES;
    }

    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:YES];
    
    if (editing) {
        self.navigationItem.rightBarButtonItem = nil;
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationLeft];
    } else {
        self.navigationItem.rightBarButtonItem = self.doneButtonItem;
        if (shouldNeedDeleteInsertCell) {
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationLeft];
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.objects.count;
    } else {
        return (tableView.editing) ? 1 : 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BookmarkCell";
    BookmarkCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    if (self.segmentedControl.selectedSegmentIndex == 0) {
        
        cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        if (indexPath.section == 0) {

            BrowserBookmark *bookmark = self.objects[indexPath.row];
            cell.textLabel.text = bookmark.title;
            cell.detailTextLabel.text = @"";
            cell.showsReorderControl = YES;
            if ([bookmark.url hasPrefix:@"javascript:"]) {
                UIImage *image = [QuickaUtil resizeImage:[UIImage imageNamed:@"bookmark_javascript"] toSize:(CGSize){20.f, 20.f}];
                cell.imageView.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            } else {
                UIImage *image = [QuickaUtil resizeImage:[UIImage imageNamed:@"bookmark_star"] toSize:(CGSize){20.f, 20.f}];
                cell.imageView.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            }
            
        } else {
            
            cell.textLabel.text = LSTR(@"New Bookmark");
            cell.detailTextLabel.text = @"";
            cell.showsReorderControl = NO;
            UIImage *image = [QuickaUtil resizeImage:[UIImage imageNamed:@"bookmark_plus"] toSize:(CGSize){20.f, 20.f}];
            cell.imageView.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        }
        
    } else {

        cell.editingAccessoryType = UITableViewCellAccessoryNone;
        cell.showsReorderControl = NO;

        BrowserHistory *history = self.objects[indexPath.row];
        cell.textLabel.text = history.title;
        cell.detailTextLabel.text = history.url;
        UIImage *image = [QuickaUtil resizeImage:[UIImage imageNamed:@"bookmark_history"] toSize:(CGSize){20.f, 20.f}];
        cell.imageView.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.editing) {

        if (indexPath.section == 0) {
            BrowserBookmark *bookmark = self.objects[indexPath.row];
            BookmarkEditViewController *viewController = [[BookmarkEditViewController alloc] initWithStyle:UITableViewStyleGrouped];
            viewController.bookmark = bookmark;
            viewController.style = BookmarkEditViewControllerStyleEdit;
            viewController.delegate = self;
            [self.navigationController pushViewController:viewController animated:YES];
        } else {

            BookmarkEditViewController *viewController = [[BookmarkEditViewController alloc] initWithStyle:UITableViewStyleGrouped];
            viewController.bookmark = nil;
            viewController.style = BookmarkEditViewControllerStyleInsert;
            viewController.delegate = self;
            [self.navigationController pushViewController:viewController animated:YES];
        }
        
    } else {

        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        NSString *url = @"";
        
        if (self.segmentedControl.selectedSegmentIndex == 0) {
            BrowserBookmark *bookmark = self.objects[indexPath.row];
            url = bookmark.url;
        } else {
            BrowserHistory *history = self.objects[indexPath.row];
            url = history.url;
        }
        
        [self dismissViewControllerAnimated:YES completion:^{
            [self.delegate didSelectURLString:url];
        }];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        return UITableViewCellEditingStyleInsert;
    } else if (self.editing) {
        return UITableViewCellEditingStyleDelete;
    } else {
        return UITableViewCellEditingStyleNone;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {

        [tableView beginUpdates];

        if (self.segmentedControl.selectedSegmentIndex == 0) {
            BrowserBookmark *bookmark = self.objects[indexPath.row];
            [BrowserBookmarkManager deleteBookmark:bookmark];
        } else {
            BrowserHistory *history = self.objects[indexPath.row];
            [BrowserHistoryManager deleteHistory:history];
        }
        
        [self.objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        
        [tableView endUpdates];
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (indexPath.section == 0) ? YES : NO;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    if (fromIndexPath.section == toIndexPath.section) {

        id object = self.objects[fromIndexPath.row];
        [self.objects removeObject:object];
        [self.objects insertObject:object atIndex:toIndexPath.row];
        [BrowserBookmarkManager updateBookmarks:self.objects];
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
	if (proposedDestinationIndexPath.section != sourceIndexPath.section) {
		return sourceIndexPath;
	}
    return proposedDestinationIndexPath;
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.destructiveButtonIndex == buttonIndex) {
        [BrowserHistoryManager deleteAllData];
        self.objects = [NSMutableArray new];
        [self.tableView reloadData];
    }
}

@end
