// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Action.m instead.

#import "_Action.h"

const struct ActionAttributes ActionAttributes = {
	.imageName = @"imageName",
	.sort = @"sort",
	.title = @"title",
	.url = @"url",
};

const struct ActionRelationships ActionRelationships = {
};

const struct ActionFetchedProperties ActionFetchedProperties = {
};

@implementation ActionID
@end

@implementation _Action

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Action" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Action";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Action" inManagedObjectContext:moc_];
}

- (ActionID*)objectID {
	return (ActionID*)[super objectID];
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




@dynamic imageName;






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
