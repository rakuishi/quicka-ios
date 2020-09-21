//
//  ActionManager.h
//  Quicka
//
//  Created by OCHIISHI Koichiro on 9/16/13.
//  Copyright (c) 2013 OCHIISHI Koichiro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RLMAction.h"
#import "CoreData+MagicalRecord.h"
#import "Action+CoreDataClass.h"
#import <CommonCrypto/CommonDigest.h>   // MD5

#define IMAGE_PATH(__imageName__) [[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"Images"] stringByAppendingPathComponent:(__imageName__)]

@interface ActionManager : NSObject

+ (void)setupInitAction;
+ (void)addTitle:(NSString *)title url:(NSString *)url image:(UIImage *)image;
+ (void)updateAction:(RLMAction *)action title:(NSString *)title url:(NSString *)url image:(UIImage *)image;
+ (void)updateActions:(NSMutableArray *)actions;
+ (void)deleteAction:(RLMAction *)action;
+ (NSMutableArray *)getAllData;
+ (void)migrateFromCoreDataToRealm;

@end
