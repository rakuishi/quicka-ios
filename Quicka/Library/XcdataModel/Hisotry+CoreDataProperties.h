//
//  Hisotry+CoreDataProperties.h
//  Quicka
//
//  Created by OCHIISHI Koichiro on 2018/10/07.
//  Copyright © 2018 OCHIISHI Koichiro. All rights reserved.
//
//

#import "Hisotry+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Hisotry (CoreDataProperties)

+ (NSFetchRequest<Hisotry *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *query;
@property (nullable, nonatomic, copy) NSDate *updated;

@end

NS_ASSUME_NONNULL_END
