// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to BrowserHistory.m instead.

#import "_BrowserHistory.h"

const struct BrowserHistoryAttributes BrowserHistoryAttributes = {
	.title = @"title",
	.updated = @"updated",
	.url = @"url",
};

const struct BrowserHistoryRelationships BrowserHistoryRelationships = {
};

const struct BrowserHistoryFetchedProperties BrowserHistoryFetchedProperties = {
};

@implementation BrowserHistoryID
@end

@implementation _BrowserHistory

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"BrowserHistory" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"BrowserHistory";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"BrowserHistory" inManagedObjectContext:moc_];
}

- (BrowserHistoryID*)objectID {
	return (BrowserHistoryID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic title;






@dynamic updated;






@dynamic url;











@end
