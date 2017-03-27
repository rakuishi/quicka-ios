//
//  PerformanceTuningKit.m
//  Quicka
//
//  Created by OCHIISHI Koichiro on 1/13/14.
//  Copyright (c) 2014 OCHIISHI Koichiro. All rights reserved.
//

#import "PerformanceTuningKit.h"

@interface PerformanceTuningKit ()

@property (nonatomic, strong) NSDate *date;

@end

@implementation PerformanceTuningKit

static PerformanceTuningKit *performanceTuningKit = nil;

+ (PerformanceTuningKit *)sharedPerformanceTuningKit
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        performanceTuningKit = [PerformanceTuningKit new];
    });
    return performanceTuningKit;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.date = [NSDate date];
    }
    return self;
}

- (void)showLogTimeIntervalWithLogName:(NSString *)logName
{
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:self.date];
    NSLog(@"%@: %3.0lf (ms)", logName, interval * 1000);
}

@end
