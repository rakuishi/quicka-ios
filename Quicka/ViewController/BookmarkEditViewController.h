//
//  BookmarkEditViewController.h
//  Quicka
//
//  Created by OCHIISHI Koichiro on 2013/10/05.
//  Copyright (c) 2013年 OCHIISHI Koichiro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BrowserBookmarkManager.h"

typedef NS_ENUM(NSInteger, BookmarkEditViewControllerStyle) {
    BookmarkEditViewControllerStyleInsert,
    BookmarkEditViewControllerStyleEdit,
};

@protocol BookmarkEditViewControllerDelegate <NSObject>

- (void)didFinishSave;

@end

@interface BookmarkEditViewController : UITableViewController <UITextFieldDelegate>

@property (nonatomic, assign) id <BookmarkEditViewControllerDelegate> delegate;
@property (nonatomic, assign) BookmarkEditViewControllerStyle style;
@property (nonatomic, strong) BrowserBookmark *bookmark;

@end
