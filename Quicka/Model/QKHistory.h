//
//  QKHistory.h
//  Quicka
//

#import <Foundation/Foundation.h>

@interface QKHistory : NSObject

@property (nonatomic, copy) NSString *query;
@property (nonatomic, strong) NSDate *updated;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)toDictionary;

@end
