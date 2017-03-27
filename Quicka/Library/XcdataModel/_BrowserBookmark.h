// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to BrowserBookmark.h instead.

#import <CoreData/CoreData.h>


extern const struct BrowserBookmarkAttributes {
	__unsafe_unretained NSString *sort;
	__unsafe_unretained NSString *title;
	__unsafe_unretained NSString *url;
} BrowserBookmarkAttributes;

extern const struct BrowserBookmarkRelationships {
} BrowserBookmarkRelationships;

extern const struct BrowserBookmarkFetchedProperties {
} BrowserBookmarkFetchedProperties;






@interface BrowserBookmarkID : NSManagedObjectID {}
@end

@interface _BrowserBookmark : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (BrowserBookmarkID*)objectID;





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

@interface _BrowserBookmark (CoreDataGeneratedAccessors)

@end

@interface _BrowserBookmark (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveSort;
- (void)setPrimitiveSort:(NSNumber*)value;

- (int16_t)primitiveSortValue;
- (void)setPrimitiveSortValue:(int16_t)value_;




- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;




- (NSString*)primitiveUrl;
- (void)setPrimitiveUrl:(NSString*)value;




@end
