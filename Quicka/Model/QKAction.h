//
//  QKAction.h
//  Quicka
//

#import <Foundation/Foundation.h>

@interface QKAction : NSObject

@property (nonatomic, copy, readonly) NSString *uuid;
@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, strong) NSNumber *sort;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *url;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)toDictionary;

@end
