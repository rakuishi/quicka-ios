//
//  BrowserBookmark+CoreDataProperties.m
//  Quicka
//
//  Created by OCHIISHI Koichiro on 2018/10/07.
//  Copyright © 2018 OCHIISHI Koichiro. All rights reserved.
//
//

#import "BrowserBookmark+CoreDataProperties.h"

@implementation BrowserBookmark (CoreDataProperties)

+ (NSFetchRequest<BrowserBookmark *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"BrowserBookmark"];
}

@dynamic sort;
@dynamic title;
@dynamic url;

@end
