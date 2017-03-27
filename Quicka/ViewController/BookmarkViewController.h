//
//  BookmarkViewController.h
//  Quicka
//
//  Created by OCHIISHI Koichiro on 10/5/13.
//  Copyright (c) 2013 OCHIISHI Koichiro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookmarkEditViewController.h"
#import "BrowserHistoryManager.h"
#import "BrowserBookmarkManager.h"
#import "QuickaUtil.h"
#import "CustomTableViewCell.h"

@protocol BookmarkViewControllerDelegate <NSObject>

- (void)didSelectURLString:(NSString *)URLString;

@end

@interface BookmarkViewController : UITableViewController <UIActionSheetDelegate, BookmarkEditViewControllerDelegate>

@property (nonatomic, assign) id <BookmarkViewControllerDelegate> delegate;

@end
