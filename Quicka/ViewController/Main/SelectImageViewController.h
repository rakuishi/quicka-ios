//
//  SelectImageViewController.h
//  Quicka
//
//  Created by OCHIISHI Koichiro on 10/6/13.
//  Copyright (c) 2013 OCHIISHI Koichiro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@protocol SelectImageViewControllerDelegate <NSObject>

- (void)didSelectImage:(UIImage *)image;

@end

@interface SelectImageViewController : UITableViewController

@property (nonatomic, assign) id <SelectImageViewControllerDelegate> delegate;

@end
