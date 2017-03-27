//
//  SourceCodeLinkManager.h
//  Quicka
//
//  Created by OCHIISHI Koichiro on 10/23/13.
//  Copyright (c) 2013 OCHIISHI Koichiro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SourceCodeLinkManager : NSObject

+ (id)sharedInstance;
- (BOOL)isSourceCodeLinkAvailable;
- (void)setSourceCodeLinkAvailable:(BOOL)available;

@end
