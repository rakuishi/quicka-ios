//
//  RLMHistory.h
//  Quicka
//
//  Created by Koichiro OCHIISHI on 2020/09/21.
//  Copyright © 2020 OCHIISHI Koichiro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

@interface RLMHistory : RLMObject

@property NSString *query;
@property NSDate *updated;

@end
