//
//  EditViewController.h
//  Quicka
//
//  Created by OCHIISHI Koichiro on 9/16/13.
//  Copyright (c) 2013 OCHIISHI Koichiro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTableViewCell.h"
#import "SelectImageViewController.h"
#import "CreateIconViewController.h"
#import "MyNavigationController.h"
#import "UIImageView+WebCache.h"
#import "ActionManager.h"
#import "QuickaUtil.h"

typedef NS_ENUM(NSInteger, EditViewControllerStyle) {
    EditViewControllerStyleInsert,
    EditViewControllerStyleEdit,
};

@protocol EditViewControllerDelegate <NSObject>

- (void)didFinishSave;

@end

@interface EditViewController : UITableViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate, UIActionSheetDelegate, SelectImageViewControllerDelegate, CreateIconViewControllerDelegate, UITextFieldDelegate>

@property (nonatomic, assign) id <EditViewControllerDelegate> delegate;
@property (nonatomic, assign) EditViewControllerStyle style;
@property (nonatomic, strong) Action *action;

@end
