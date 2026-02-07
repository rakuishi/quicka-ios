//
//  QKHistory.m
//  Quicka
//

#import "QKHistory.h"

@implementation QKHistory

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        _query = dict[@"query"];
        NSNumber *timestamp = dict[@"updated"];
        if (timestamp) {
            _updated = [NSDate dateWithTimeIntervalSince1970:[timestamp doubleValue]];
        }
    }
    return self;
}

- (NSDictionary *)toDictionary
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (self.query)   dict[@"query"] = self.query;
    if (self.updated) dict[@"updated"] = @([self.updated timeIntervalSince1970]);
    return [dict copy];
}

@end
