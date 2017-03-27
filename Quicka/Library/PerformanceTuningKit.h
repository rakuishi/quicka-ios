//
//  PerformanceTuningKit.h
//  Quicka
//
//  Created by OCHIISHI Koichiro on 1/13/14.
//  Copyright (c) 2014 OCHIISHI Koichiro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PerformanceTuningKit : NSObject

+ (PerformanceTuningKit *)sharedPerformanceTuningKit;
- (void)showLogTimeIntervalWithLogName:(NSString *)logName;

@end
