// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to BrowserBookmark.m instead.

#import "_BrowserBookmark.h"

const struct BrowserBookmarkAttributes BrowserBookmarkAttributes = {
	.sort = @"sort",
	.title = @"title",
	.url = @"url",
};

const struct BrowserBookmarkRelationships BrowserBookmarkRelationships = {
};

const struct BrowserBookmarkFetchedProperties BrowserBookmarkFetchedProperties = {
};

@implementation BrowserBookmarkID
@end

@implementation _BrowserBookmark

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"BrowserBookmark" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"BrowserBookmark";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"BrowserBookmark" inManagedObjectContext:moc_];
}

- (BrowserBookmarkID*)objectID {
	return (BrowserBookmarkID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"sortValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"sort"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic sort;



- (int16_t)sortValue {
	NSNumber *result = [self sort];
	return [result shortValue];
}

- (void)setSortValue:(int16_t)value_ {
	[self setSort:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveSortValue {
	NSNumber *result = [self primitiveSort];
	return [result shortValue];
}

- (void)setPrimitiveSortValue:(int16_t)value_ {
	[self setPrimitiveSort:[NSNumber numberWithShort:value_]];
}





@dynamic title;






@dynamic url;











@end
