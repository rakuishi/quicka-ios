//
//  CustomEngineViewController.h
//  Quicka
//
//  Created by OCHIISHI Koichiro on 10/31/13.
//  Copyright (c) 2013 OCHIISHI Koichiro. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomEngineViewControllerDelegate <NSObject>

- (void)didEditCustomEngine;

@end

@interface CustomEngineViewController : UITableViewController <UITextFieldDelegate>

@property (nonatomic, assign) id <CustomEngineViewControllerDelegate> delegate;

@end
