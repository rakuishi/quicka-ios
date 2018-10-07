//
//  Action+CoreDataProperties.m
//  Quicka
//
//  Created by OCHIISHI Koichiro on 2018/10/07.
//  Copyright © 2018 OCHIISHI Koichiro. All rights reserved.
//
//

#import "Action+CoreDataProperties.h"

@implementation Action (CoreDataProperties)

+ (NSFetchRequest<Action *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Action"];
}

@dynamic imageName;
@dynamic sort;
@dynamic title;
@dynamic url;

@end
