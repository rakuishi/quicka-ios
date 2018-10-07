//
//  BrowserHistory+CoreDataProperties.m
//  Quicka
//
//  Created by OCHIISHI Koichiro on 2018/10/07.
//  Copyright © 2018 OCHIISHI Koichiro. All rights reserved.
//
//

#import "BrowserHistory+CoreDataProperties.h"

@implementation BrowserHistory (CoreDataProperties)

+ (NSFetchRequest<BrowserHistory *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"BrowserHistory"];
}

@dynamic title;
@dynamic updated;
@dynamic url;

@end
