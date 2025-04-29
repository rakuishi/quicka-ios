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
#import "ActionManager.h"
#import "QuickaUtil.h"
#import <SDWebImage/UIImageView+WebCache.h>

typedef NS_ENUM(NSInteger, EditViewControllerStyle) {
    EditViewControllerStyleInsert,
    EditViewControllerStyleEdit,
};

@protocol EditViewControllerDelegate <NSObject>

- (void)didFinishSave;

@end

@interface EditViewController : UITableViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, SelectImageViewControllerDelegate, CreateIconViewControllerDelegate, UITextFieldDelegate>

@property (nonatomic, assign) id <EditViewControllerDelegate> delegate;
@property (nonatomic, assign) EditViewControllerStyle style;
@property (nonatomic, strong) RLMAction *action;

@end
