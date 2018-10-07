//
//  BrowserBookmark+CoreDataProperties.h
//  Quicka
//
//  Created by OCHIISHI Koichiro on 2018/10/07.
//  Copyright © 2018 OCHIISHI Koichiro. All rights reserved.
//
//

#import "BrowserBookmark+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface BrowserBookmark (CoreDataProperties)

+ (NSFetchRequest<BrowserBookmark *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *sort;
@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSString *url;

@end

NS_ASSUME_NONNULL_END
