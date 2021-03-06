//
//  MainViewController.h
//  Quicka
//
//  Created by OCHIISHI Koichiro on 9/14/13.
//  Copyright (c) 2013 OCHIISHI Koichiro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SafariServices/SafariServices.h>

#import "HistoryViewController.h"
#import "EditViewController.h"
#import "SettingsViewController.h"
#import "ActionManager.h"
#import "CustomTableViewCell.h"
#import "HistoryManager.h"
#import "QuickaUtil.h"
#import "SuggestView.h"
#import "AppStoreViewController.h"
#import "NSString+Quicka2.h"

@protocol MainViewControllerDelegate <NSObject>

- (void)scrollToSubViewControllerWithQuery:(NSString *)query;

@end

@interface MainViewController : UITableViewController <EditViewControllerDelegate, HistoryViewControllerDelegate, SuggestViewDelegate, UISearchBarDelegate>

@property (nonatomic, weak) id <MainViewControllerDelegate> delegate;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, assign) BOOL isActive;

- (void)showSoftwareKeyboardIfPossible;
- (void)hideSoftwareKeyboard;

@end
