//
//  SourceCodeLinkManager.m
//  Quicka
//
//  Created by OCHIISHI Koichiro on 10/23/13.
//  Copyright (c) 2013 OCHIISHI Koichiro. All rights reserved.
//

#import "SourceCodeLinkManager.h"

@interface SourceCodeLinkManager ()

@property (nonatomic, assign) BOOL available;

@end

@implementation SourceCodeLinkManager

static id instance = nil;

+ (id)sharedInstance
{
    @synchronized(self) {
        if (!instance) {
            instance = [[self alloc] init];
        }
    }
	return instance;
}

- (BOOL)isSourceCodeLinkAvailable
{
    return self.available;
}

- (void)setSourceCodeLinkAvailable:(BOOL)available
{
    self.available = available;
}

@end
