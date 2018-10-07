//
//  Action+CoreDataProperties.h
//  Quicka
//
//  Created by OCHIISHI Koichiro on 2018/10/07.
//  Copyright © 2018 OCHIISHI Koichiro. All rights reserved.
//
//

#import "Action+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Action (CoreDataProperties)

+ (NSFetchRequest<Action *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *imageName;
@property (nullable, nonatomic, copy) NSNumber *sort;
@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSString *url;

@end

NS_ASSUME_NONNULL_END
