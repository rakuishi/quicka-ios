//
//  RLMAction.h
//  Quicka
//
//  Created by Koichiro OCHIISHI on 2020/09/21.
//  Copyright © 2020 OCHIISHI Koichiro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Realm.h"

@interface RLMAction : RLMObject

@property NSString *imageName;
@property NSNumber<RLMInt> *sort;
@property NSString *title;
@property NSString *url;

@end
