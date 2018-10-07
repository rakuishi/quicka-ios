//
//  Hisotry+CoreDataProperties.m
//  Quicka
//
//  Created by OCHIISHI Koichiro on 2018/10/07.
//  Copyright © 2018 OCHIISHI Koichiro. All rights reserved.
//
//

#import "Hisotry+CoreDataProperties.h"

@implementation Hisotry (CoreDataProperties)

+ (NSFetchRequest<Hisotry *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Hisotry"];
}

@dynamic query;
@dynamic updated;

@end
