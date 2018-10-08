//
//  ContainerViewController.h
//  Quicka
//
//  Created by OCHIISHI Koichiro on 9/14/13.
//  Copyright (c) 2013 OCHIISHI Koichiro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "MainViewController.h"
#import "SubViewController.h"

@interface ContainerViewController : UIViewController <MainViewControllerDelegate, SubViewControllerDelegate>

- (void)scrollToMainViewControllerWithQuery:(NSString *)query;
- (void)scrollToSubViewControllerWithQuery:(NSString *)query;

@end
