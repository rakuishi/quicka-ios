//
//  BrowserHistory+CoreDataProperties.h
//  Quicka
//
//  Created by OCHIISHI Koichiro on 2018/10/07.
//  Copyright © 2018 OCHIISHI Koichiro. All rights reserved.
//
//

#import "BrowserHistory+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface BrowserHistory (CoreDataProperties)

+ (NSFetchRequest<BrowserHistory *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSDate *updated;
@property (nullable, nonatomic, copy) NSString *url;

@end

NS_ASSUME_NONNULL_END
