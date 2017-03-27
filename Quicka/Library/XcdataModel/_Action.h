// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Action.h instead.

#import <CoreData/CoreData.h>


extern const struct ActionAttributes {
	__unsafe_unretained NSString *imageName;
	__unsafe_unretained NSString *sort;
	__unsafe_unretained NSString *title;
	__unsafe_unretained NSString *url;
} ActionAttributes;

extern const struct ActionRelationships {
} ActionRelationships;

extern const struct ActionFetchedProperties {
} ActionFetchedProperties;







@interface ActionID : NSManagedObjectID {}
@end

@interface _Action : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (ActionID*)objectID;





@property (nonatomic, strong) NSString* imageName;



//- (BOOL)validateImageName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* sort;



@property int16_t sortValue;
- (int16_t)sortValue;
- (void)setSortValue:(int16_t)value_;

//- (BOOL)validateSort:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* title;



//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* url;



//- (BOOL)validateUrl:(id*)value_ error:(NSError**)error_;






@end

@interface _Action (CoreDataGeneratedAccessors)

@end

@interface _Action (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveImageName;
- (void)setPrimitiveImageName:(NSString*)value;




- (NSNumber*)primitiveSort;
- (void)setPrimitiveSort:(NSNumber*)value;

- (int16_t)primitiveSortValue;
- (void)setPrimitiveSortValue:(int16_t)value_;




- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;




- (NSString*)primitiveUrl;
- (void)setPrimitiveUrl:(NSString*)value;




@end
