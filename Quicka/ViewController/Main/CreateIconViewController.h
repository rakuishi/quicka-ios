//
//  CreateIconViewController.h
//  Quicka
//
//  Created by OCHIISHI Koichiro on 11/4/13.
//  Copyright (c) 2013 OCHIISHI Koichiro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTableViewCell.h"
#import "QuickaUtil.h"
#import "CustomCollectionViewCell.h"

@protocol CreateIconViewControllerDelegate <NSObject>

- (void)didCreateImage:(UIImage *)image;

@end

@interface CreateIconViewController : UITableViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, assign) id <CreateIconViewControllerDelegate> delegate;

@end
