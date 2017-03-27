//
//  MainViewController.m
//  Quicka
//
//  Created by OCHIISHI Koichiro on 9/14/13.
//  Copyright (c) 2013 OCHIISHI Koichiro. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@property (nonatomic, strong) NSMutableArray *actions;
@property (nonatomic, strong) SuggestView *suggestView;
@property (nonatomic, strong) NSString *preQuery;
@property (nonatomic, assign) BOOL isBeginDragging;

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    self.tableView.scrollsToTop = NO;
    self.tableView.separatorInset = UIEdgeInsetsMake(0.f, 15.f, 0.f, 0.f);
    self.tableView.allowsSelectionDuringEditing = YES;
    [self.tableView registerNib:[UINib nibWithNibName:@"DefaultIconCell" bundle:nil] forCellReuseIdentifier:@"DefaultIconCell"];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
    self.searchBar.delegate = self;
    self.searchBar.translucent = NO;
    self.searchBar.enablesReturnKeyAutomatically = NO;
    self.searchBar.tintColor = [UIColor colorWithRed:69.f/255.f green:111.f/255.f blue:238.f/255.f alpha:1.f]; // カーソル色

    self.navigationItem.titleView = self.searchBar;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"barbuttonitem_bookmark"] style:UIBarButtonItemStylePlain target:self action:@selector(bookmark)];

    // 通知を登録
    NSNotificationCenter *notification = [NSNotificationCenter defaultCenter];
    [notification addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [notification addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [notification addObserver:self selector:@selector(didBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    [notification addObserver:self selector:@selector(reloadTableViewData) name:QKApplicationReloadTableViewData object:nil];
    [notification addObserver:self selector:@selector(setTextToSearchBar:) name:QKApplicationSetTextToSearchBar object:nil];

    [self reloadTableViewData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    // `viewDidLoad` でインスタンスを生成するのと比較して 200ms 短縮
    if (self.toolbarItems.count == 0) {
        [self didBecomeActive];

        UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *settingsButtonItem = [[UIBarButtonItem alloc] initWithTitle:LSTR(@"Settings") style:UIBarButtonItemStylePlain target:self action:@selector(settingsButtonItemTapped)];
        [self setToolbarItems:@[settingsButtonItem, flexibleSpace, self.editButtonItem] animated:NO];
    }
    
    if ([QuickaUtil isOnForKey:kQuickaUseSuggestView]) {
        if (self.suggestView == nil) {
            self.suggestView = [SuggestView new];
            self.suggestView.delegate = self;
            self.suggestView.hidden = YES;
            [self.navigationController.view addSubview:self.suggestView];
        }
    } else {
        if (self.suggestView != nil) {
            [self.suggestView removeFromSuperview];
            self.suggestView.delegate = nil;
            self.suggestView = nil;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    NSNotificationCenter *notification = [NSNotificationCenter defaultCenter];
    [notification removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [notification removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [notification removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [notification removeObserver:self name:QKApplicationReloadTableViewData object:nil];
    [notification removeObserver:self name:QKApplicationSetTextToSearchBar object:nil];
}

#pragma mark -

- (void)insertButtonItemTapped
{
    EditViewController *viewController = [[EditViewController alloc] initWithStyle:UITableViewStyleGrouped];
    viewController.delegate = self;
    viewController.style = EditViewControllerStyleInsert;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)settingsButtonItemTapped
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Settings" bundle:[NSBundle mainBundle]];
    SettingsViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
    MyNavigationController *navigationController = [[MyNavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)reloadTableViewData
{
    self.actions = [ActionManager getAllData];
    [self.tableView reloadData];
}

#pragma mark - From ContainerViewController

- (void)didBecomeActive
{
    if (self.isActive && self.editing == NO) {
        [self.searchBar becomeFirstResponder];
    }
}

- (void)willBecomeResignActive
{
    [self.searchBar resignFirstResponder];
}

#pragma mark - SuggestViewDelegate

- (void)selectedSuggestedWord:(NSString *)suggestedWord
{
    self.searchBar.text = suggestedWord;
    [self.suggestView setQuery:suggestedWord];
}

#pragma mark - NSNotification

- (void)keyboardDidShow:(NSNotification *)notification
{
    // MainViewController が前面にいる場合
    if (self.isActive) {
        CGRect frame = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        self.suggestView.hidden = NO;
        [self.suggestView moveOriginYFromKeyboardRect:frame];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    self.suggestView.hidden = YES;
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsZero;
}

- (void)setTextToSearchBar:(NSNotification *)notification
{
    [self.searchBar setText:[(NSString *)[notification.userInfo objectForKey:@"text"] UTF8DecodedString]];
    [self.searchBar becomeFirstResponder];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self performQuickaSearchWithQuery:searchBar.text url:[QuickaUtil getSearchEngineURL] isSearchBarAction:YES];
}

- (void)bookmark
{
    HistoryViewController *viewController = [[HistoryViewController alloc] initWithStyle:UITableViewStylePlain];
    viewController.delegate = self;
    MyNavigationController *navigationController = [[MyNavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString *query = searchBar.text;
    query = [query stringByReplacingCharactersInRange:range withString:text];
    query = [query convertedString];
    
    if (![query isEqualToString:self.preQuery]) {
        if (self.suggestView.delegate == nil) {
            self.suggestView.delegate = self;
        }
        [self.suggestView setQuery:query];
    }
    self.preQuery = query;
    
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length == 0) {
        [self.suggestView setQuery:nil];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.isBeginDragging = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint currentPoint = [scrollView contentOffset];
    if (self.isBeginDragging) {
        self.isBeginDragging = NO;
        if (currentPoint.y < 0.f) {
            if ([self.searchBar isFirstResponder]) {
                [self.searchBar resignFirstResponder];
            } else {
                [self.searchBar becomeFirstResponder];
            }
        } else {
            if ([self.searchBar isFirstResponder]) {
                [self.searchBar resignFirstResponder];
            }
        }
    }
}

#pragma mark - UIViewController

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:QKApplicationEnablePanGesture object:nil userInfo:@{@"enable": [NSNumber numberWithBool:!editing]}];
    
    self.searchBarTextField.enabled = !editing;

    if (editing) {
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationLeft];
    } else {
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationLeft];
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.actions.count;
    } else {
        return (tableView.editing) ? 1 : 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DefaultIconCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DefaultIconCell" forIndexPath:indexPath];
    cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;

    if (indexPath.section == 0) {
        
        cell.showsReorderControl = YES;

        Action *action = self.actions[indexPath.row];
        cell.textLabel.text = action.title;
        UIImage *image = [UIImage imageWithContentsOfFile:IMAGE_PATH(action.imageName)];
        if (image == nil) image = [UIImage imageNamed:@"icon_placeholder"];
        cell.imageView.image = [QuickaUtil maskImage:image];

    } else {
        
        cell.textLabel.text = LSTR(@"New Action");
        cell.imageView.image = [UIImage imageNamed:@"icon_plus"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.editing) {

        if (indexPath.section == 0) {
            
            Action *action = self.actions[indexPath.row];
            
            EditViewController *editViewController = [[EditViewController alloc] initWithStyle:UITableViewStyleGrouped];
            editViewController.delegate = self;
            editViewController.style = EditViewControllerStyleEdit;
            editViewController.action = action;
            [self.navigationController pushViewController:editViewController animated:YES];

        } else {
            
            [self insertButtonItemTapped];
        }

    } else {
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];

        Action *action = self.actions[indexPath.row];
        [self performQuickaSearchWithQuery:self.searchBar.text url:action.url isSearchBarAction:NO];
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
        
        Action *action = self.actions[indexPath.row];
        [ActionManager deleteAction:action];    // データベースから削除
        [self.actions removeObjectAtIndex:indexPath.row]; // 配列に持たせているデータを削除
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
        id object = self.actions[fromIndexPath.row];
        [self.actions removeObject:object];
        [self.actions insertObject:object atIndex:toIndexPath.row];
        [ActionManager updateActions:self.actions];
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
	if (proposedDestinationIndexPath.section != sourceIndexPath.section) {
		return sourceIndexPath;
	}
    return proposedDestinationIndexPath;
}

#pragma mark - HistoryViewControllerDelegate

- (void)didSelectQuery:(NSString *)query
{
    self.searchBar.text = query;
    [self.searchBar becomeFirstResponder];
}

#pragma mark - EditViewControllerDelegate

- (void)didFinishSave
{
    [self reloadTableViewData];
}

#pragma mark - perform Quicka Search

- (void)performQuickaSearchWithQuery:(NSString *)query url:(NSString *)url isSearchBarAction:(BOOL)isSearchBarAction
{
    [self.searchBar resignFirstResponder];

    // 検索欄に文字列が存在しない場合は、クリップボードの文字列を利用
    if (query.length == 0) {
        [[UIPasteboard generalPasteboard] containsPasteboardTypes:UIPasteboardTypeListString];
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        if (pasteboard.string != nil) {
            query = pasteboard.string;
        }
    }

    // 検索後に語句を消去
    if ([QuickaUtil isOnForKey:kQuickaClearTextAfterSearch]) {
        self.searchBar.text = @"";
        [self.suggestView setQuery:nil];
    }

    // Quicka に登録されているオリジナルアクションを処理
    BOOL isOnlyLaunchApp = YES;
    if ([url isEqualToString:@"quicka2://?action=reference"]) {
        
        [HistoryManager addQuery:query];

        MyReferenceLibraryViewController *referenceLibraryViewController = [[MyReferenceLibraryViewController alloc] initWithTerm:query];
        [self presentViewController:referenceLibraryViewController animated:YES completion:nil];

        return;
        
    } else if ([url isEqualToString:@"quicka2://?action=appstore"]) {
        
        [HistoryManager addQuery:query];

        AppStoreViewController *viewController = [[AppStoreViewController alloc] initWithStyle:UITableViewStylePlain];
        viewController.query = query;
        MyNavigationController *navigationController = [[MyNavigationController alloc] initWithRootViewController:viewController];
        [self presentViewController:navigationController animated:YES completion:nil];

        return;
        
    } else if ([url isEqualToString:@"quicka2://?action=transit"]) {

        isOnlyLaunchApp = NO;
        url = [query transitYahooURLString];
    }
    
    // 検索欄で起動した時に、内蔵ブラウザを使用し、クエリに URL が存在する場合はそちらを優先
    if (isSearchBarAction && [QuickaUtil isOnForKey:kQuickaUseBuiltInBrowser] && ([query hasPrefix:@"http:"] || [query hasPrefix:@"https:"])) {
        
        isOnlyLaunchApp = NO;
        url = query;
    }

    if ([url rangeOfString:@"[U]"].location != NSNotFound) {
        isOnlyLaunchApp = NO;
        // 後で検索欄に格納する文字列がエンコードされないように、仮 Query を用意
        NSString *encodedQuery = [query UTF8EncodedString];
        url = [url stringByReplacingOccurrencesOfString:@"[U]" withString:encodedQuery];
    } else if ([url rangeOfString:@"[S]"].location != NSNotFound) {
        isOnlyLaunchApp = NO;
        NSString *encodedQuery = [query stringByAddingPercentEscapesUsingEncoding:NSShiftJISStringEncoding];
        url = [url stringByReplacingOccurrencesOfString:@"[S]" withString:encodedQuery];
    } else if ([url rangeOfString:@"[E]"].location != NSNotFound) {
        isOnlyLaunchApp = NO;
        NSString *encodedQuery = [query stringByAddingPercentEscapesUsingEncoding:NSJapaneseEUCStringEncoding];
        url = [url stringByReplacingOccurrencesOfString:@"[E]" withString:encodedQuery];
    }
    
    if (isOnlyLaunchApp) {
        // アプリを起動するだけの場合、履歴には格納しないように
    } else {
        // 履歴を使用する場合には残る
        [HistoryManager addQuery:query];
    }

    if ([url hasPrefix:@"http:"] || [url hasPrefix:@"https:"]) {
        if ([QuickaUtil isOnForKey:kQuickaUseBuiltInBrowser]) {
            if ([self.delegate respondsToSelector:@selector(scrollToSubViewControllerWithQuery:)]) {
                [self.delegate scrollToSubViewControllerWithQuery:url];
            }
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        }
    } else {
        [[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];
    }
}

@end