//
//  HistoryManager.h
//  Quicka
//
//  Created by OCHIISHI Koichiro on 9/16/13.
//  Copyright (c) 2013 OCHIISHI Koichiro. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CoreData+MagicalRecord.h"
#import "Hisotry.h"

@interface HistoryManager : NSObject

+ (void)addQuery:(NSString *)query;
+ (NSArray *)getAllData;
+ (void)deleteHistory:(Hisotry *)history;
+ (void)deleteAllData;

@end
