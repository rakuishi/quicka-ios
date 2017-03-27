//
//  BrowserHistoryManager.h
//  Quicka
//
//  Created by OCHIISHI Koichiro on 10/5/13.
//  Copyright (c) 2013 OCHIISHI Koichiro. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CoreData+MagicalRecord.h"
#import "BrowserHistory.h"

@interface BrowserHistoryManager : NSObject

+ (void)addTitle:(NSString *)title url:(NSString *)url;
+ (NSMutableArray *)getAllData;
+ (void)deleteHistory:(BrowserHistory *)history;
+ (void)deleteAllData;

@end
