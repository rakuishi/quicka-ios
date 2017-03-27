// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Hisotry.h instead.

#import <CoreData/CoreData.h>


extern const struct HisotryAttributes {
	__unsafe_unretained NSString *query;
	__unsafe_unretained NSString *updated;
} HisotryAttributes;

extern const struct HisotryRelationships {
} HisotryRelationships;

extern const struct HisotryFetchedProperties {
} HisotryFetchedProperties;





@interface HisotryID : NSManagedObjectID {}
@end

@interface _Hisotry : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (HisotryID*)objectID;





@property (nonatomic, strong) NSString* query;



//- (BOOL)validateQuery:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* updated;



//- (BOOL)validateUpdated:(id*)value_ error:(NSError**)error_;






@end

@interface _Hisotry (CoreDataGeneratedAccessors)

@end

@interface _Hisotry (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveQuery;
- (void)setPrimitiveQuery:(NSString*)value;




- (NSDate*)primitiveUpdated;
- (void)setPrimitiveUpdated:(NSDate*)value;




@end
