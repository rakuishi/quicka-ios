//
//  SourceCodeViewController.h
//  Quicka
//
//  Created by OCHIISHI Koichiro on 10/16/13.
//  Copyright (c) 2013 OCHIISHI Koichiro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "SourceCodeLinkManager.h"

@protocol SourceCodeViewControllerDelegate <NSObject>

- (void)didSelectURL:(NSURL *)URL;

@end

@interface SourceCodeViewController : UIViewController <UIActionSheetDelegate, MFMailComposeViewControllerDelegate>

@property (nonatomic, assign) id <SourceCodeViewControllerDelegate> delegate;
@property (nonatomic, strong) NSURL *URL;
@property (nonatomic, strong) NSString *userAgent;

@end
