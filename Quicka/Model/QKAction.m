//
//  QKAction.m
//  Quicka
//

#import "QKAction.h"

@implementation QKAction

- (instancetype)init
{
    self = [super init];
    if (self) {
        _uuid = [[NSUUID UUID] UUIDString];
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        _uuid = dict[@"uuid"] ?: [[NSUUID UUID] UUIDString];
        _imageName = dict[@"imageName"];
        _sort = dict[@"sort"];
        _title = dict[@"title"];
        _url = dict[@"url"];
    }
    return self;
}

- (NSDictionary *)toDictionary
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"uuid"] = self.uuid;
    if (self.imageName) dict[@"imageName"] = self.imageName;
    if (self.sort)      dict[@"sort"] = self.sort;
    if (self.title)     dict[@"title"] = self.title;
    if (self.url)       dict[@"url"] = self.url;
    return [dict copy];
}

@end
