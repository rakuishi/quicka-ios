//
//  HistoryViewController.h
//  Quicka
//
//  Created by OCHIISHI Koichiro on 9/16/13.
//  Copyright (c) 2013 OCHIISHI Koichiro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HistoryManager.h"
#import "RLMHistory.h"

@protocol HistoryViewControllerDelegate <NSObject>

- (void)didSelectQuery:(NSString *)query;

@end

@interface HistoryViewController : UITableViewController

@property (nonatomic, assign) id <HistoryViewControllerDelegate> delegate;

@end
