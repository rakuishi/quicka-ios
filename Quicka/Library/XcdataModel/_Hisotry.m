// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Hisotry.m instead.

#import "_Hisotry.h"

const struct HisotryAttributes HisotryAttributes = {
	.query = @"query",
	.updated = @"updated",
};

const struct HisotryRelationships HisotryRelationships = {
};

const struct HisotryFetchedProperties HisotryFetchedProperties = {
};

@implementation HisotryID
@end

@implementation _Hisotry

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Hisotry" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Hisotry";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Hisotry" inManagedObjectContext:moc_];
}

- (HisotryID*)objectID {
	return (HisotryID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic query;






@dynamic updated;











@end
